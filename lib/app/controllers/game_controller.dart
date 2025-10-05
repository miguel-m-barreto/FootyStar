import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/app_message.dart';
import '../../domain/models/player.dart';
import '../../domain/models/skill.dart';
import '../../domain/models/team.dart';
import '../../domain/models/league.dart';
import '../../domain/models/economy.dart';

import '../../domain/models/played_match.dart';
import '../../domain/models/fixture.dart';
import '../../domain/models/league_table.dart';

import '../../data/services/training_service.dart';
import '../../data/services/match_service.dart';
import '../../data/services/economy_service.dart';

import '../../features/match/models/match_moment.dart';
import '../../features/match/services/match_moments_engine.dart';
import '../providers/providers.dart';
import '../state/game_state.dart';

// Notifications & message templates
import '../../messages/general_messages.dart';
import '../../messages/economy_messages.dart';
import '../../messages/match_messages.dart';
import '../../messages/skill_messages.dart';
import '../../messages/casino_messages.dart';
import '../../domain/models/skills_catalog.dart';

class GameController extends Notifier<GameState> {
  late final _training = TrainingService();
  late final _match = MatchService();
  late final _eco = EconomyService();
  final _rng = Random();
  late final _moments = MatchMomentsEngine();

  @override
  GameState build() => _initialState();

  GameState _initialState() {
    // Seed players
    final p = _createInitialPlayer();
    final q = _createInitialPlayer().copyWith(
      name: "Joao Costa",
      role: PlayerRole.striker,
    );
    final my = Team(
      id: "t1",
      name: "HashStorm FC",
      squad: [p, q],
      morale: 0.75,
    );

    final lg = const League(
      id: "pt2",
      name: "Second Division",
      multiplier: 1.00,
    );
    final eco = const Economy(cash: 10000, weeklyIncome: 800, weeklyCosts: 500);

    // Generate AI teams
    final aiTeams = <String>[
      "Lisbon United",
      "Coimbra City",
      "Porto Athletic",
      "Braga Royals",
      "Faro Mariners",
      "Setubal Rangers",
      "Aveiro Town",
      "Leiria Eagles",
    ];

    // Initial opponent: first AI team
    final opponent = _generateAIOpponent(aiTeams.first);

    // Create fixtures: my team plays each AI team once, one per week
    final fixtures = <Fixture>[];
    for (var i = 0; i < aiTeams.length; i++) {
      fixtures.add(
        Fixture(week: i + 1, homeTeam: my.name, awayTeam: aiTeams[i]),
      );
    }

    // Seed empty table with all teams
    var table = const LeagueTable({});
    table = table.upsertTeam(my.name);
    for (final t in aiTeams) {
      table = table.upsertTeam(t);
    }

    return GameState(
      myTeam: my,
      opponent: opponent,
      league: lg,
      economy: eco,
      week: 1,
      history: const [],
      fixtures: fixtures,
      table: table,
      aiTeams: aiTeams,
    );
  }

  Team _generateAIOpponent(String name) {
    // Local helpers -------------------------------------------------------------
    PlayerRole _findRole(List<String> hints) {
      for (final h in hints) {
        final hint = h.toLowerCase();
        for (final r in PlayerRole.values) {
          if (r.name.toLowerCase().contains(hint)) return r;
        }
      }
      return PlayerRole.values.first; // fallback
    }

    Map<String, Skill> _baseSkillsWithNoise() {
      final skills = <String, Skill>{};
      SkillsCatalog.all28Skills.forEach((id, base) {
        skills[id] = base.copyWith(
          level: 45 + _rng.nextInt(26), // 45..70
          currentXp: _rng.nextInt(30),
        );
      });
      return skills;
    }

    Player _mk(int idx, PlayerRole role) {
      return Player(
        id: "ai$idx",
        name: "AI-$idx",
        age: 18 + _rng.nextInt(15),
        role: role,
        skills: _baseSkillsWithNoise(),
        form: 0.6 + _rng.nextDouble() * 0.3,
        fatigue: 0.1 + _rng.nextDouble() * 0.3,
        reputation: 10 + _rng.nextDouble() * 15,
        sp: 0,
        consistency: 45 + _rng.nextInt(20).toDouble(),
        determination: 45 + _rng.nextInt(20).toDouble(),
        leadership: 40 + _rng.nextInt(25).toDouble(),
      );
    }
    // --------------------------------------------------------------------------

    // Target XI (4-4-2-ish)
    final templateRoles = <PlayerRole>[
      _findRole(['gk', 'goal']), // GK
      _findRole(['cb', 'def']), // CB
      _findRole(['cb', 'def']), // CB
      _findRole(['back', 'wing', 'def']), // LB/RB/WB
      _findRole(['back', 'wing', 'def']), // LB/RB/WB
      _findRole(['mid', 'cm']), // CM
      _findRole(['mid', 'cm']), // CM
      _findRole(['mid', 'cm']), // CM/Wide mid
      _findRole(['mid', 'cm']), // CM/Wide mid
      _findRole(['st', 'striker', 'forward']), // ST
      _findRole(['st', 'striker', 'forward']), // ST
    ];

    final squad = <Player>[];
    for (int i = 0; i < templateRoles.length; i++) {
      squad.add(_mk(i, templateRoles[i]));
    }
    squad.shuffle(_rng); // randomize order a bit

    return Team(
      id: "ai_${name.hashCode}",
      name: name,
      squad: squad, // exactly 11 with a GK guaranteed by hints
      morale: 0.6 + _rng.nextDouble() * 0.3,
    );
  }

  // =========================
  // PLAYER-CENTRIC UTILITIES
  // =========================

  String get _meId => state.myTeam.squad.first.id;

  Player get _me => state.myTeam.squad.firstWhere((p) => p.id == _meId);

  void _commitMe(Player updated) {
    final squad = [...state.myTeam.squad];
    final idx = squad.indexWhere((p) => p.id == updated.id);
    if (idx != -1) {
      squad[idx] = updated;
      state = state.copyWith(myTeam: state.myTeam.copyWith(squad: squad));
    }
  }

  /// Treino pessoal numa skill específica usando o novo sistema XP
  void selfTrain(String skillId) {
    final me0 = _me;

    // Usa o novo sistema de trainSkill com XP
    final trained = _training.trainSkill(me0, skillId, baseXp: 30);

    // Aplica fadiga e forma adicionais do treino manual
    final updatedPlayer = trained.copyWith(
      fatigue: (trained.fatigue + 0.05).clamp(0, 1),
      // Fadiga extra do treino manual
      form: (trained.form * 0.99).clamp(0, 1), // Pequeno ajuste na forma
    );

    _commitMe(updatedPlayer);

    // Notificação com skill name localizado
    final skill = updatedPlayer.skills[skillId];
    if (skill != null) {
      _notify(
        'Training',
        'Trained ${skill.id} - Level ${skill.level}' +
            (skill.queuedLevels > 0 ? ' (+${skill.queuedLevels} queued)' : ''),
      );
    }
  }

  /// Sessão de recuperação pessoal
  void recoverSelf() {
    final me0 = _me;
    final rested = me0.copyWith(
      fatigue: (me0.fatigue - 0.18).clamp(0, 1),
      form: (me0.form * 0.97 + 0.03).clamp(0, 1),
    );
    _commitMe(rested);
    _notify('Training', '${me0.name} completed a recovery session');
  }

  // =========================
  // TRAINING (legacy wrappers)
  // =========================

  /// [LEGACY] Treinar um jogador específico — mantém para compatibilidade.
  /// Se o playerId for o "eu", delega em selfTrain; caso contrário, ignora.
  void train(String playerId, String skillId) {
    if (playerId == _meId) {
      selfTrain(skillId);
      return;
    }
    // No-op para outros jogadores (não és treinador).
  }

  /// [LEGACY] Descansar a equipa toda — não faz sentido para player. Mapeado para recoverSelf().
  void restAll() {
    recoverSelf();
  }

  // =========================
  // ECONOMY
  // =========================

  void _setEconomy(Economy next) {
    state = state.copyWith(economy: next);
  }

  /// Records a manual expense and updates all spend metrics consistently.
  void addExpense(int amount) {
    if (amount <= 0) return;
    final next = _eco.recordExpense(state.economy, amount);
    _setEconomy(next);
  }

  /// Records a manual earning and updates all earn metrics consistently.
  void addEarning(int amount) {
    if (amount <= 0) return;
    final next = _eco.recordEarning(state.economy, amount);
    _setEconomy(next);
  }

  /// Apply weekly finances, roll to next week, and (if fixtures exist) prepare next opponent.
  /// Clears `spentWeek` and aggregates weekly income/costs into season/lifetime metrics.
  /// Also emits notifications (general + economy summary).
  void endOfWeekEconomy() {
    // 1) Aggregate this week's scheduled flows into cumulative metrics
    final e0 = state.economy;
    final earned = e0.weeklyIncome;
    final spent = e0.weeklyCosts;

    final eAggregated = e0.copyWith(
      earnedSeason: e0.earnedSeason + earned,
      earnedAllTime: e0.earnedAllTime + earned,
      spentSeason: e0.spentSeason + spent,
      spentAllTime: e0.spentAllTime + spent,
    );

    // 2) Apply weekly delta to cash (income - costs)
    final applied = _eco.applyWeekly(eAggregated);
    final delta = earned - spent;

    // 3) New week: clear manual weekly spent
    final economyNextWeek = applied.copyWith(spentWeek: 0);

    // 4) Advance calendar
    final nextWeek = state.week + 1;

    // 5) Optional: set next opponent from fixtures (keeps current if none)
    var nextOpponent = state.opponent;
    try {
      final nextFixture = state.fixtures.firstWhere(
        (f) => f.week == nextWeek,
        orElse: () => const Fixture(week: -1, homeTeam: '', awayTeam: ''),
      );
      if (nextFixture.week > 0) {
        nextOpponent = _generateAIOpponent(nextFixture.awayTeam);
      }
    } catch (_) {
      // Keep current opponent if anything goes wrong
    }

    // 6) Commit state
    state = state.copyWith(
      week: nextWeek,
      economy: economyNextWeek,
      opponent: nextOpponent,
    );

    // 7) Notify (general + economy summary)
    _notify('General', GeneralMessages.weekEnded(nextWeek - 1));
    _notify(
      'Economy',
      EconomyMessages.weekSummary(earned, spent, delta, economyNextWeek.cash),
    );
  }

  /// Place a casino wager. Updates cash and tracks spent/earned metrics accordingly.
  /// Emits a notification about win/loss.
  void casinoWager(int amount) {
    final e0 = state.economy;

    // Sanitize amount
    final wager = amount.clamp(0, e0.cash);
    if (wager == 0) return;

    final beforeCash = e0.cash;
    final afterEconomy = _eco.casino(e0, wager);
    final afterCash = afterEconomy.cash;

    final delta = afterCash - beforeCash;

    Economy withStats;
    if (delta >= 0) {
      // Win: add to earnings
      withStats = afterEconomy.copyWith(
        earnedSeason: e0.earnedSeason + delta,
        earnedAllTime: e0.earnedAllTime + delta,
      );
      state = state.copyWith(economy: withStats);
      _notify('Casino', CasinoMessages.win(delta, withStats.cash));
    } else {
      // Loss: add to expenses
      final loss = -delta;
      withStats = afterEconomy.copyWith(
        spentWeek: e0.spentWeek + loss,
        spentSeason: e0.spentSeason + loss,
        spentAllTime: e0.spentAllTime + loss,
      );
      state = state.copyWith(economy: withStats);
      _notify('Casino', CasinoMessages.loss(loss, withStats.cash));
    }
  }

  /// Convenience: all-in using current cash.
  void casinoAllIn() {
    casinoWager(state.economy.cash);
  }

  /// Same as casinoWager but returns (delta, win) for UI feedback.
  ({int delta, bool win}) casinoWagerWithResult(int amount) {
    final before = state.economy.cash;
    casinoWager(amount);
    final after = state.economy.cash;
    final delta = after - before;
    final win = delta > 0;
    return (delta: delta, win: win);
  }

  // =========================
  // MATCH / FIXTURES
  // =========================

  double _calculateRatingAux(PlayerStats? stats) {
    if (stats == null) return 6.0;

    // 6.0 base + contributos - penalizações
    final rating = 6.0
        + 1.2 * (stats.goals)
        + 0.6 * (stats.assists)
        - 0.3 * (stats.yellow)
        - 1.0 * (stats.red);

    return rating.clamp(4.0, 10.0);
  }

  void playMatch() {
    // Allow only one official match per week (based on fixtures)
    final fxIndex = state.fixtures.indexWhere((f) => f.week == state.week);
    if (fxIndex == -1) {
      // No fixture defined for this week; fallback to current opponent (friendly)
      final fullHome = _ensureXI(state.myTeam);
      final fullAway = _ensureXI(state.opponent);
      final sim = _moments.simulate(home: fullHome, away: fullAway);
      final homeGoals = sim.score.home;
      final awayGoals = sim.score.away;

      _playAndRecord(fullHome.name, fullAway.name);
      _notify('Match', MatchMessages.friendly(fullHome.name, fullAway.name));

      // SP: rating * multiplier(moments) — friendly still dá SP
      final myStats = sim.playerStats[_meId];
      final double rating = _calculateRatingAux(myStats);
      final momentsMult = (1.0 + (sim.moments.length * 0.05)).clamp(1.0, 2.0);
      final spGain = (rating * momentsMult).round().clamp(1, 20);

      // Minimal XP por match nas skills (progresso lento)
      final meAfterMinimalXp = _training.applyMinimalMatchXp(
        fullHome.squad.firstWhere((p) => p.id == _meId),
        perSkill: 2,
      ).copyWith(sp: fullHome.squad.firstWhere((p) => p.id == _meId).sp + spGain);

      // Atualiza squad (apenas eu mudo aqui)
      final newSquad = fullHome.squad.map((p) {
        if (p.id != _meId) return p;
        return meAfterMinimalXp.copyWith(
          form: (meAfterMinimalXp.form * 0.98 + (homeGoals > 0 ? 0.04 : 0.02)).clamp(0, 1),
          fatigue: (meAfterMinimalXp.fatigue + 0.15).clamp(0, 1),
        );
      }).toList();

      state = state.copyWith(
        myTeam: fullHome.copyWith(squad: newSquad),
        opponent: fullAway,
        lastMatchMoments: sim.moments,
        lastMatchScore: sim.score,
        lastMatchPlayerStats: sim.playerStats,
      );

      _notify('Skills', 'Earned $spGain SP from match performance!');
      return;
    }

    final fx = state.fixtures[fxIndex];
    if (fx.played) return;

    final oppName = fx.awayTeam;
    final ensuredOpp = state.opponent.name == oppName
        ? state.opponent
        : _generateAIOpponent(oppName);

    final fullHome = _ensureXI(state.myTeam);
    final fullAway = _ensureXI(ensuredOpp);

    final sim = _moments.simulate(home: fullHome, away: fullAway);

    final homeGoals = sim.score.home;
    final awayGoals = sim.score.away;

    // Reputação simples para lado da casa (mantém lógica existente)
    final homeRepDelta = homeGoals > awayGoals ? 0.5 : (homeGoals < awayGoals ? -0.5 : 0.1);

    // SP: rating * multiplier(moments)
    final myStats = sim.playerStats[_meId];
    final rating = (myStats?.rating ?? 6.0);
    final momentsMult = (1.0 + (sim.moments.length * 0.05)).clamp(1.0, 2.0);
    final int spGain = (rating * momentsMult).round().clamp(1, 20);

    // Minimal XP por match nas skills (progresso lento)
    final me0 = fullHome.squad.firstWhere((p) => p.id == _meId);
    final meAfterMinimalXp = _training.applyMinimalMatchXp(me0, perSkill: 2)
        .copyWith(sp: me0.sp + spGain);

    // Atualiza apenas o meu jogador com rep/form/fadiga + SP e XP mínimo
    final finalSquad = fullHome.squad.map((p) {
      if (p.id != _meId) return p;
      return meAfterMinimalXp.copyWith(
        reputation: (meAfterMinimalXp.reputation + homeRepDelta).clamp(0, 100),
        form: (meAfterMinimalXp.form * 0.98 + (homeGoals > 0 ? 0.04 : 0.02)).clamp(0, 1),
        fatigue: (meAfterMinimalXp.fatigue + 0.15).clamp(0, 1),
      );
    }).toList();

    // Record PlayedMatch
    final played = PlayedMatch(
      week: state.week,
      homeName: fullHome.name,
      awayName: fullAway.name,
      homeGoals: homeGoals,
      awayGoals: awayGoals,
    );

    // Mark fixture as played
    final newFixtures = [...state.fixtures];
    newFixtures[fxIndex] = fx.markPlayed(homeGoals, awayGoals);

    // Update table
    var newTable = state.table.applyMatch(
      home: fullHome.name,
      away: fullAway.name,
      homeGoals: homeGoals,
      awayGoals: awayGoals,
    );

    // Simulate AI vs AI
    final others = state.aiTeams.where((t) => t != fullAway.name).toList();
    others.shuffle(_rng);
    for (int i = 0; i + 1 < others.length; i += 2) {
      final a = others[i];
      final b = others[i + 1];
      final hg = _poisson(1.4 + _rng.nextDouble());
      final ag = _poisson(1.2 + _rng.nextDouble());
      newTable = newTable.applyMatch(
        home: a,
        away: b,
        homeGoals: hg,
        awayGoals: ag,
      );
    }

    // Commit
    state = state.copyWith(
      myTeam: fullHome.copyWith(squad: finalSquad),
      opponent: fullAway,
      history: [...state.history, played],
      fixtures: newFixtures,
      table: newTable,
      lastMatchMoments: sim.moments,
      lastMatchScore: sim.score,
      lastMatchPlayerStats: sim.playerStats,
    );

    // Notifies
    _notify('Skills', 'Earned $spGain SP from match performance!');
    _notify(
      'Match',
      MatchMessages.result(
        state.week,
        fullHome.name,
        homeGoals,
        fullAway.name,
        awayGoals,
      ),
    );
  }


  int _poisson(double lambda) {
    final L = _exp(-lambda);
    int k = 0;
    double p = 1.0;
    do {
      k++;
      p *= _rng.nextDouble();
    } while (p > L);
    return k - 1;
  }

  double _exp(double x) => x == 0 ? 1 : (x > 0 ? _expPos(x) : 1 / _expPos(-x));

  double _expPos(double x) {
    double sum = 1, term = 1;
    for (int n = 1; n < 16; n++) {
      term *= x / n;
      sum += term;
    }
    return sum;
  }

  // Convenience for potential fallback use-cases (not used in fixture flow)
  void _playAndRecord(String home, String away) {
    final r = _match.play(state.myTeam, state.opponent);

    // Declarar as variáveis primeiro
    final homeGoals = r.homeGoals;
    final awayGoals = r.awayGoals;
    final homeRepDelta = r.homeRepDelta;

    final upd = state.myTeam.squad
        .map(
          (p) => p.id == _meId
              ? p.copyWith(
                  reputation: (p.reputation + homeRepDelta).clamp(0, 100),
                  form: (p.form * 0.98 + (homeGoals > 0 ? 0.04 : 0.02)).clamp(
                    0,
                    1,
                  ),
                  fatigue: (p.fatigue + 0.15).clamp(0, 1),
                )
              : p,
        )
        .toList();

    final played = PlayedMatch(
      week: state.week,
      homeName: home,
      awayName: away,
      homeGoals: r.homeGoals,
      awayGoals: r.awayGoals,
    );

    final newTable = state.table.applyMatch(
      home: home,
      away: away,
      homeGoals: r.homeGoals,
      awayGoals: r.awayGoals,
    );

    state = state.copyWith(
      myTeam: state.myTeam.copyWith(squad: upd),
      history: [...state.history, played],
      table: newTable,
    );
  }

  // =========================
  // WEEKLY LOOP
  // =========================

  /// Advance full weekly loop focado no jogador:
  Future<void> advanceWeek() async {
    // 1) match
    playMatch();

    // 2) passive train + recovery
    final trained = _training.passiveWeeklyTraining(_me);
    final rested = _training.rest(trained);
    _commitMe(rested);

    // 3) Economy and next week
    endOfWeekEconomy();
  }

  /// Simular várias semanas seguidas
  Future<void> simulateWeeks(int n) async {
    if (n <= 0) return;
    for (int i = 0; i < n; i++) {
      await advanceWeek();
    }
  }

  // =========================
  // NOTIFICATIONS HELPER
  // =========================

  void _notify(String title, String body) {
    ref
        .read(notificationsProvider.notifier)
        .push(
          AppMessage(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            title: title,
            body: body,
            ts: DateTime.now(),
          ),
        );
  }

  // Em game_controller.dart, após o jogo:
  void _notifyMatchSPRewards(Map<String, PlayerStats> stats) {
    final meStats = stats[_meId];
    if (meStats != null && meStats.spEarned > 0) {
      _notify(
        'Skills',
        'Earned ${meStats.spEarned} SP from match performance!',
      );
    }
  }

  // =========================
  // COACH TRUST (derived)
  // =========================

  /// Métrica derivada 0..1 baseada na tua forma (60%) e reputação (40%).
  double get coachTrust {
    final f = _me.form; // 0..1
    final rep = _me.reputation; // 0..100
    final trust = 0.6 * f + 0.4 * (rep / 100.0);
    return trust.clamp(0, 1);
  }

  /// Conveniência para status textual com base no trust.
  String get coachStatus {
    final t = coachTrust;
    if (t >= 0.75) return 'Starter';
    if (t >= 0.55) return 'Rotation';
    return 'Bench';
  }

  // =========================
  // PLAYER CONTRACT / AGENT
  // =========================

  /// Pede transferência — só cria um evento/notification do agente/coach.
  void requestTransfer() {
    final lines = [
      'Your agent: A transfer request has been filed.',
      'Coach will review your status this month.',
      'Stay focused: performance affects interest from other clubs.',
    ];
    _notify('Agent', lines.join(' '));
  }

  /// Pede aumento com probabilidade baseada no Coach Trust.
  /// Base chance = coachTrust; “pedidos fáceis” têm +10% de bónus.
  void askForRaise() {
    final base = coachTrust; // 0..1
    final bonus = 0.10; // indulgência
    final chance = (base + bonus).clamp(0, 0.95); // cap 95%
    final roll = _rng.nextDouble(); // 0..1

    final cur = state.economy;
    if (roll < chance) {
      // aprovação simples: +10% arredondado
      final inc = (cur.weeklyIncome * 0.10).round();
      final next = cur.copyWith(weeklyIncome: cur.weeklyIncome + inc);
      state = state.copyWith(economy: next);
      _notify(
        'Agent',
        'Raise approved (+\$${inc}/week). New salary: \$${next.weeklyIncome}/week.',
      );
    } else {
      _notify(
        'Coach',
        'Raise denied for now. Improve your form & reputation to increase chances.',
      );
    }
  }

  // DUMMY PLAYER //

  Player _createInitialPlayer() {
    // Initialize all 28 skills with base values
    final Map<String, Skill> allSkills = {};

    for (final entry in SkillsCatalog.all28Skills.entries) {
      allSkills[entry.key] = entry.value.copyWith(
        level: 45 + _rng.nextInt(20), // Random 45-65
        currentXp: _rng.nextInt(30),
      );
    }

    return Player(
      id: "p1",
      name: "Rui Silva",
      age: 22,
      role: PlayerRole.midfielder,
      // Or striker/defender
      skills: allSkills,
      form: 0.8,
      fatigue: 0.2,
      reputation: 15.0,
      sp: 10,
      // Starting SP
      consistency: 55.0,
      determination: 60.0,
      leadership: 45.0,
    );
  }

  // =========================
  // SKILLS SYSTEM
  // =========================

  /// Train a specific skill using the new XP system
  void trainSkillWithXP(String skillId) {
    final me = _me;
    final updatedPlayer = _training.trainSkill(me, skillId, baseXp: 30);
    _commitMe(updatedPlayer);

    final skill = updatedPlayer.skills[skillId];
    if (skill != null) {
      _notify('Training', 'Trained $skillId - Level ${skill.level}');
    }
  }

  /// Use SP to boost a skill
  void useSpOnSkill(String skillId, int spAmount) {
    if (spAmount <= 0 || spAmount > _me.sp) return;

    final updatedPlayer = _training.useSpOnSkill(_me, skillId, spAmount);
    _commitMe(updatedPlayer);

    _notify('Skills', 'Used $spAmount SP on ${skillId}');
  }

  /// Promote a single skill (pay cost)
  void promoteSkill(String skillId) {
    final skill = _me.skills[skillId];
    if (skill == null || skill.queuedLevels <= 0) return;

    final cost = skill.promotionCost(skill.level);
    if (state.economy.cash < cost) {
      _notify('Skills', 'Not enough cash to promote (need \$$cost)');
      return;
    }

    final (updatedPlayer, success, actualCost) = _training.promoteSkill(
      _me,
      skillId,
      state.economy.cash,
    );

    if (success) {
      _commitMe(updatedPlayer);
      addExpense(actualCost);

      final newSkill = updatedPlayer.skills[skillId];
      _notify('Skills', 'Promoted ${skillId} to level ${newSkill?.level ?? 0}');
    }
  }

  /// Promote all queued skills
  void promoteAllSkills() {
    final (updatedPlayer, totalCost, promotedSkills) = _training
        .promoteAllSkills(_me, state.economy.cash);

    if (promotedSkills.isNotEmpty) {
      _commitMe(updatedPlayer);
      addExpense(totalCost);
      _notify(
        'Skills',
        'Promoted ${promotedSkills.length} skills for \$$totalCost',
      );
    } else {
      _notify('Skills', 'No skills to promote or insufficient funds');
    }
  }

  /// Weekly passive training (called in advanceWeek)
  void _applyWeeklyTraining() {
    final updatedPlayer = _training.passiveWeeklyTraining(_me);
    _commitMe(updatedPlayer);
  }

  // --- XI helpers ---

  bool _isGK(Player p) {
    final n = p.role.name.toLowerCase();
    return n.contains('gk') ||
        n.contains('goal'); // matches 'gk' or 'goalkeeper'
  }

  PlayerRole _findRole(List<String> hints) {
    // Tries each hint until it finds a role name that contains it
    for (final h in hints) {
      final i = PlayerRole.values.indexWhere(
        (r) => r.name.toLowerCase().contains(h),
      );
      if (i != -1) return PlayerRole.values[i];
    }
    // fallback to the first role if nothing matches
    return PlayerRole.values.first;
  }

  String _randName() {
    const first = [
      'Joao',
      'Miguel',
      'Rui',
      'Tiago',
      'Luis',
      'Pedro',
      'Carlos',
      'Bruno',
      'Andre',
      'Diogo',
      'Marco',
      'Ricardo',
      'Daniel',
      'Hugo',
      'Paulo',
    ];
    const last = [
      'Silva',
      'Santos',
      'Pereira',
      'Rodrigues',
      'Ferreira',
      'Costa',
      'Martins',
      'Araujo',
      'Gomes',
      'Carvalho',
      'Sousa',
      'Rocha',
      'Mendes',
      'Barbosa',
      'Almeida',
    ];
    return '${first[_rng.nextInt(first.length)]} ${last[_rng.nextInt(last.length)]}';
  }

  Map<String, Skill> _baseSkillsWithNoise() {
    final out = <String, Skill>{};
    // Uses your catalog; adjust import path if needed
    SkillsCatalog.all28Skills.forEach((id, base) {
      out[id] = base.copyWith(
        level: 45 + _rng.nextInt(26), // 45..70
        currentXp: _rng.nextInt(30),
      );
    });
    return out;
  }

  Player _makeAIPlayer({
    required String teamId,
    required int index,
    required PlayerRole role,
  }) {
    return Player(
      id: 'ai_${teamId}_$index',
      name: _randName(),
      age: 18 + _rng.nextInt(15),
      role: role,
      skills: _baseSkillsWithNoise(),
      form: 0.6 + _rng.nextDouble() * 0.3,
      fatigue: _rng.nextDouble() * 0.25,
      reputation: 5 + _rng.nextDouble() * 20,
      sp: 0,
      consistency: 50 + _rng.nextInt(30).toDouble(),
      determination: 50 + _rng.nextInt(30).toDouble(),
      leadership: 40 + _rng.nextInt(35).toDouble(),
    );
  }

  Team _ensureXI(Team t) {
    final squad = [...t.squad];

    // Ensure exactly one GK if none present
    if (!squad.any(_isGK)) {
      final gkRole = _findRole(['gk', 'goal']);
      squad.add(
        _makeAIPlayer(teamId: t.id, index: squad.length + 1, role: gkRole),
      );
    }

    // Fill up to 11 with a 4-4-2-ish template
    final wantedOrder = <PlayerRole>[
      _findRole(['cb', 'def']),
      _findRole(['cb', 'def']),
      _findRole(['wing', 'back', 'def']),
      _findRole(['wing', 'back', 'def']),
      _findRole(['mid', 'cm']),
      _findRole(['mid', 'cm']),
      _findRole(['mid', 'cm']),
      _findRole(['mid', 'cm']),
      _findRole(['striker', 'st', 'forward']),
      _findRole(['striker', 'st', 'forward']),
    ];

    // Add from template until we reach 11
    var idx = 0;
    while (squad.length < 11) {
      final role = (idx < wantedOrder.length)
          ? wantedOrder[idx]
          : _findRole(['mid', 'cm']);
      squad.add(
        _makeAIPlayer(teamId: t.id, index: squad.length + 1, role: role),
      );
      idx++;
    }

    return t.copyWith(squad: squad);
  }
}
