import 'dart:math';
import '../../../domain/models/team.dart';
import '../../../domain/models/player.dart';
import '../models/match_moment.dart';

/// Simple "match moments" engine (90' running time).
/// - generates attacks per minute (approx. Poisson)
/// - resolves chance quality -> xG -> outcome
/// - updates per-player stats
class MatchMomentsEngine {
  final Random _rng;

  MatchMomentsEngine([Random? rng]) : _rng = rng ?? Random();

  MatchSim simulate({required Team home, required Team away}) {
    final moments = <MatchMoment>[];
    final stats = <String, PlayerStats>{};
    int homeGoals = 0, awayGoals = 0;

    // kick-off
    moments.add(
      MatchMoment(
        minute: 1,
        teamId: home.id,
        type: MomentType.kickOff,
        key: 'match_kickoff',
        args: {'home': home.name, 'away': away.name},
      ),
    );

    // simple global ratings
    final atkHome = _attackRating(home);
    final defHome = _defenseRating(home);
    final atkAway = _attackRating(away);
    final defAway = _defenseRating(away);

    // expected intensity (events per minute)
    final lambdaHome = max(0.8, atkHome / (defAway + 1)) * 0.9; // events/min
    final lambdaAway = max(0.8, atkAway / (defHome + 1)) * 0.9;

    // helpers
    Player pickAttacker(Team t) =>
        _weightedPick(t.squad, (p) => _attackerWeight(p));
    Player pickAssistant(Team t, Player exclude) => _weightedPick(
      t.squad.where((x) => x.id != exclude.id).toList(),
      (p) => _assistantWeight(p),
    );
    Player pickDefender(Team t) =>
        _weightedPick(t.squad, (p) => _defenderWeight(p));
    Player pickGK(Team t) => t.squad.firstWhere(
      (p) => p.role.name.toLowerCase().contains('gk'),
      orElse: () => _fallbackGK(t),
    );

    final gkHome = pickGK(home);
    final gkAway = pickGK(away);

    // 1..90 loop
    for (int m = 1; m <= 90; m++) {
      // half-time marker
      if (m == 46) {
        moments.add(
          MatchMoment(
            minute: m,
            teamId: '',
            type: MomentType.halfTime,
            key: 'match_halftime',
          ),
        );
      }

      // decide whether home attacks
      final homeAttacks = _bernoulli(lambdaHome);
      if (homeAttacks) {
        final res = _resolveAttack(
          minute: m,
          team: home,
          opponent: away,
          gkOpponent: gkAway,
          pickAttacker: pickAttacker,
          pickAssistant: pickAssistant,
          pickDefender: pickDefender,
          stats: stats,
        );
        moments.addAll(res.moments);
        if (res.goal) homeGoals++;
      }

      // decide whether away attacks
      final awayAttacks = _bernoulli(lambdaAway);
      if (awayAttacks) {
        final res = _resolveAttack(
          minute: m,
          team: away,
          opponent: home,
          gkOpponent: gkHome,
          pickAttacker: pickAttacker,
          pickAssistant: pickAssistant,
          pickDefender: pickDefender,
          stats: stats,
        );
        moments.addAll(res.moments);
        if (res.goal) awayGoals++;
      }

      // occasional disciplinary events
      if (_rng.nextDouble() < 0.03) {
        final foulTeam = _rng.nextBool() ? home : away;
        final offender = _weightedPick(
          foulTeam.squad,
          (p) => _disciplineWeight(p),
        );
        final roll = _rng.nextDouble();
        if (roll < 0.85) {
          _inc(stats, offender.id).yellow++;
          moments.add(
            MatchMoment(
              minute: m,
              teamId: foulTeam.id,
              type: MomentType.yellow,
              key: 'match_yellow',
              args: {'player': offender.name},
            ),
          );
        } else {
          _inc(stats, offender.id).red++;
          moments.add(
            MatchMoment(
              minute: m,
              teamId: foulTeam.id,
              type: MomentType.red,
              key: 'match_red',
              args: {'player': offender.name},
            ),
          );
        }
      }
    }

    // full-time
    moments.add(
      MatchMoment(
        minute: 90,
        teamId: '',
        type: MomentType.fullTime,
        key: 'match_fulltime',
      ),
    );

    return MatchSim(
      moments: moments..sort((a, b) => a.minute.compareTo(b.minute)),
      score: MatchScore(homeGoals, awayGoals),
      playerStats: stats,
    );
  }

  // ---------- internals ----------

  // One "event per minute" ~ Bernoulli with p = clamp(lambda/2.5, ...).
  // Here we already receive λ normalized per minute (above).
  bool _bernoulli(double lambdaPerMin) {
    final p = min(
      0.9,
      lambdaPerMin / 2.5,
    ); // controls intensity; ~0.3..0.4 => lively match
    return _rng.nextDouble() < p;
  }

  // Resolve a single attack: build-up -> chance -> shot -> goal/save/miss
  _AttackResult _resolveAttack({
    required int minute,
    required Team team,
    required Team opponent,
    required Player gkOpponent,
    required Player Function(Team) pickAttacker,
    required Player Function(Team, Player) pickAssistant,
    required Player Function(Team) pickDefender,
    required Map<String, PlayerStats> stats,
  }) {
    final moments = <MatchMoment>[];

    // build-up
    moments.add(
      MatchMoment(
        minute: minute,
        teamId: team.id,
        type: MomentType.buildUp,
        key: 'match_buildup',
      ),
    );

    // who attacks / assists / defends
    final att = pickAttacker(team);
    final maybeAssist = pickAssistant(team, att);
    final def = pickDefender(opponent);

    // offensive vs defensive quality
    final off = _offensiveScore(att, maybeAssist);
    final dea = _defensiveScore(def, gkOpponent);

    // base xG
    final raw = (off - dea); // can be negative
    double xg = 0.03 + 0.004 * raw; // ~ 0.03..0.45
    xg = xg.clamp(0.02, 0.55);

    // create the "chance"
    moments.add(
      MatchMoment(
        minute: minute,
        teamId: team.id,
        type: MomentType.chance,
        key: 'match_chance',
        args: {
          'att': att.name,
          'ast': maybeAssist.name,
          'xg': xg.toStringAsFixed(2),
        },
      ),
    );

    // shot
    _inc(stats, att.id).shots++;
    final onTargetProb =
        0.45 +
        0.003 * (_skill(att, 'finishing') + _skill(att, 'composure') - 100);
    final onTarget = _rng.nextDouble() < onTargetProb.clamp(0.15, 0.85);
    if (onTarget) _inc(stats, att.id).shotsOnTarget++;

    moments.add(
      MatchMoment(
        minute: minute,
        teamId: team.id,
        type: onTarget ? MomentType.shotOnTarget : MomentType.shotOffTarget,
        key: onTarget ? 'match_shot_on' : 'match_shot_off',
        args: {'att': att.name},
      ),
    );

    // goal?
    bool goal = false;
    if (onTarget) {
      final gkSaveBonus =
          0.0025 *
          (_skill(gkOpponent, 'gk_reflexes') +
              _skill(gkOpponent, 'gk_diving') -
              100);
      final goalProb = (xg - gkSaveBonus).clamp(0.03, 0.75);
      if (_rng.nextDouble() < goalProb) {
        goal = true;
        _inc(stats, att.id).goals++;
        // 40% chance to credit an assist

        _inc(stats, att.id).spEarned += 3;
        if (_rng.nextDouble() < 0.4) {
          _inc(stats, maybeAssist.id).assists++;
          _inc(stats, maybeAssist.id).spEarned += 2;
        }
        moments.add(
          MatchMoment(
            minute: minute,
            teamId: team.id,
            type: MomentType.goal,
            key: 'match_goal_basic',
            args: {
              'scorer': att.name,
              'assist': maybeAssist.name,
              'xg': xg.toStringAsFixed(2),
            },
          ),
        );
      } else {
        moments.add(
          MatchMoment(
            minute: minute,
            teamId: opponent.id,
            type: MomentType.save,
            key: 'match_save',
            args: {'gk': gkOpponent.name},
          ),
        );
      }
    }

    return _AttackResult(moments, goal);
  }

  // --------- ratings & weights ----------

  double _attackRating(Team t) {
    // average of top 6 attackers (role bias) + form - fatigue
    final players = [...t.squad]
      ..sort((a, b) => _attackerWeight(b).compareTo(_attackerWeight(a)));
    final top = players.take(min(6, players.length)).toList();
    final avg =
        top.map((p) => _attackComposite(p)).fold<double>(0, (a, b) => a + b) /
        max(1, top.length);
    final teamForm = t.morale * 10; // 0..10
    return avg + teamForm;
  }

  double _defenseRating(Team t) {
    final players = [...t.squad]
      ..sort((a, b) => _defenderWeight(b).compareTo(_defenderWeight(a)));
    final top = players.take(min(6, players.length)).toList();
    final avg =
        top.map((p) => _defenseComposite(p)).fold<double>(0, (a, b) => a + b) /
        max(1, top.length);
    return avg;
  }

  double _attackComposite(Player p) {
    final s =
        (_skill(p, 'finishing') * 0.35 +
        _skill(p, 'dribbling') * 0.15 +
        _skill(p, 'short_passing') * 0.15 +
        _skill(p, 'vision') * 0.15 +
        _skill(p, 'positioning') * 0.10 +
        _skill(p, 'composure') * 0.10);
    return _applyState(s, p);
  }

  double _defenseComposite(Player p) {
    final s =
        (_skill(p, 'tackling') * 0.30 +
        _skill(p, 'marking') * 0.25 +
        _skill(p, 'interceptions') * 0.25 +
        _skill(p, 'strength') * 0.10 +
        _skill(p, 'aggression') * 0.10);
    return _applyState(s, p);
  }

  double _offensiveScore(Player att, Player ast) {
    final s =
        (_skill(att, 'finishing') * 0.40 +
        _skill(att, 'dribbling') * 0.20 +
        _skill(att, 'positioning') * 0.15 +
        _skill(ast, 'short_passing') * 0.15 +
        _skill(ast, 'vision') * 0.10);
    return _applyState(s, att);
  }

  double _defensiveScore(Player def, Player gk) {
    final sDef =
        (_skill(def, 'tackling') * 0.35 +
        _skill(def, 'marking') * 0.35 +
        _skill(def, 'interceptions') * 0.20 +
        _skill(def, 'strength') * 0.10);
    final sGk = (_skill(gk, 'gk_diving') + _skill(gk, 'gk_reflexes')) / 2;
    return 0.7 * _applyState(sDef, def) + 0.3 * _applyState(sGk, gk);
  }

  double _applyState(double base, Player p) {
    final form = (p.form).clamp(0.4, 1.2); // 0.4..1.2
    final fatigue = (1.0 - p.fatigue).clamp(
      0.6,
      1.1,
    ); // more fatigue -> lower value
    return base * (0.5 + 0.5 * form) * (0.7 + 0.3 * fatigue);
  }

  // Weights for picks
  double _attackerWeight(Player p) {
    final roleBias = p.role.name.toLowerCase().contains('striker')
        ? 1.25
        : p.role.name.toLowerCase().contains('wing')
        ? 1.15
        : 1.0;
    return roleBias * (_attackComposite(p) + 1);
  }

  double _assistantWeight(Player p) {
    final roleBias = p.role.name.toLowerCase().contains('mid') ? 1.2 : 1.0;
    return roleBias *
        (_skill(p, 'short_passing') + _skill(p, 'vision') + 0.001);
  }

  double _defenderWeight(Player p) {
    final roleBias = p.role.name.toLowerCase().contains('cb') ? 1.25 : 1.0;
    return roleBias * (_defenseComposite(p) + 1);
  }

  double _disciplineWeight(Player p) {
    // more aggressive players show up more often
    return 0.5 + _skill(p, 'aggression') / 100.0;
  }

  // Utils
  T _weightedPick<T>(List<T> list, double Function(T) weight) {
    double sum = 0;
    for (final x in list) sum += max(0.0001, weight(x));
    var r = _rng.nextDouble() * sum;
    for (final x in list) {
      r -= max(0.0001, weight(x));
      if (r <= 0) return x;
    }
    return list.last;
  }

  double _skill(Player p, String id) => (p.skills[id]?.level ?? 50).toDouble();

  Player _fallbackGK(Team t) {
    // choose the best "defensive" player as emergency GK
    return _weightedPick(t.squad, (p) => _defenseComposite(p));
  }

  PlayerStats _inc(Map<String, PlayerStats> stats, String id) {
    return stats.putIfAbsent(id, () => PlayerStats());
  }
}

class _AttackResult {
  final List<MatchMoment> moments;
  final bool goal;

  _AttackResult(this.moments, this.goal);
}
