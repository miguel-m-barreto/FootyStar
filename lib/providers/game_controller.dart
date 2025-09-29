import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/player.dart';
import '../domain/skill.dart';
import '../domain/team.dart';
import '../domain/league.dart';
import '../domain/economy.dart';
import '../models/played_match.dart';
import '../models/fixture.dart';
import '../models/league_table.dart';
import '../services/training_service.dart';
import '../services/match_service.dart';
import '../services/economy_service.dart';
import '../state/game_state.dart';

class GameController extends Notifier<GameState> {
  late final _training = TrainingService();
  late final _match = MatchService();
  late final _eco = EconomyService();
  final _rng = Random();

  @override
  GameState build() => _initialState();

  GameState _initialState() {
    // Seed players
    final p = Player(
      id: "p1", name: "Rui Silva", age: 22, form: 0.8, fatigue: 0.2, reputation: 15,
      skills: {
        "fin": const Skill(id:"fin", name:"Finishing", level:62, stars:1),
        "pas": const Skill(id:"pas", name:"Passing", level:58, stars:0),
        "spd": const Skill(id:"spd", name:"Speed", level:64, stars:0),
      },
    );
    final q = Player(
      id: "p2", name: "João Costa", age: 24, form: 0.7, fatigue: 0.3, reputation: 12,
      skills: {
        "fin": const Skill(id:"fin", name:"Finishing", level:55, stars:0),
        "pas": const Skill(id:"pas", name:"Passing", level:61, stars:1),
        "spd": const Skill(id:"spd", name:"Speed", level:59, stars:0),
      },
    );

    final my = Team(id:"t1", name:"HashStorm FC", squad:[p,q], morale:0.75);
    final lg = League(id:"pt2", name:"Segunda Liga", multiplier:1.00);
    final eco = Economy(cash: 10000, weeklyIncome: 800, weeklyCosts: 500);

    // Generate AI teams
    final aiTeams = <String>[
      "Lisbon United",
      "Coimbra City",
      "Porto Athletic",
      "Braga Royals",
      "Faro Mariners",
      "Setúbal Rangers",
      "Aveiro Town",
      "Leiria Eagles",
    ];

    // Initial opponent: first AI team
    final opponent = _generateAIOpponent(aiTeams.first);

    // Create fixtures: my team plays each AI team once, one per week
    final fixtures = <Fixture>[];
    for (var i = 0; i < aiTeams.length; i++) {
      fixtures.add(Fixture(
        week: i + 1,
        homeTeam: my.name,
        awayTeam: aiTeams[i],
      ));
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
    // Create a basic AI team by cloning template players with noise
    Player mk(int idx) => Player(
      id: "ai$idx",
      name: "AI-$idx",
      age: 22 + (_rng.nextInt(6)),
      form: 0.6 + _rng.nextDouble() * 0.3,
      fatigue: 0.1 + _rng.nextDouble() * 0.3,
      reputation: 10 + _rng.nextDouble() * 15,
      skills: {
        "fin": Skill(id:"fin", name:"Finishing", level:55 + _rng.nextInt(16), stars: _rng.nextInt(2)),
        "pas": Skill(id:"pas", name:"Passing", level:55 + _rng.nextInt(16), stars: _rng.nextInt(2)),
        "spd": Skill(id:"spd", name:"Speed",    level:55 + _rng.nextInt(16), stars: _rng.nextInt(2)),
      },
    );
    final squad = List.generate(12, (i) => mk(i));
    return Team(id: "ai_${name.hashCode}", name: name, squad: squad, morale: 0.6 + _rng.nextDouble() * 0.3);
  }

  // TRAINING

  void train(String playerId, String skillId) {
    final idx = state.myTeam.squad.indexWhere((p)=>p.id == playerId);
    if (idx == -1) return;
    final trained = _training.trainSkill(state.myTeam.squad[idx], skillId);
    final newSquad = [...state.myTeam.squad]..[idx] = trained;
    state = state.copyWith(myTeam: state.myTeam.copyWith(squad: newSquad));
  }

  void restAll() {
    final rested = state.myTeam.squad.map(_training.rest).toList();
    state = state.copyWith(myTeam: state.myTeam.copyWith(squad: rested));
  }

  // ECONOMY

  void endOfWeekEconomy() {
    // Apply finances and advance to next week
    final nextEconomy = _eco.applyWeekly(state.economy);
    final nextWeek = state.week + 1;

    // Update next week's opponent if we have a fixture
    Team nextOpponent = state.opponent;
    final nextFixture = state.fixtures.firstWhere(
          (f) => f.week == nextWeek,
      orElse: () => const Fixture(week: -1, homeTeam: "", awayTeam: ""),
    );
    if (nextFixture.week > 0) {
      nextOpponent = _generateAIOpponent(nextFixture.awayTeam);
    }

    state = state.copyWith(
      economy: nextEconomy,
      week: nextWeek,
      opponent: nextOpponent,
    );
  }

  // MATCH

  void playMatch() {
    // Allow only one official match per week (based on fixtures)
    final fxIndex = state.fixtures.indexWhere((f) => f.week == state.week);
    if (fxIndex == -1) {
      // No fixture defined for this week; fallback to current opponent
      _playAndRecord(state.myTeam.name, state.opponent.name);
      return;
    }
    final fx = state.fixtures[fxIndex];
    if (fx.played) {
      // Already played; ignore
      return;
    }

    // Ensure opponent matches fixture
    final oppName = fx.awayTeam;
    final ensuredOpp = state.opponent.name == oppName ? state.opponent : _generateAIOpponent(oppName);

    // Simulate my match
    final r = _match.play(state.myTeam, ensuredOpp);

    // Update my players stats
    final upd = state.myTeam.squad.map((p)=>p.copyWith(
      reputation: (p.reputation + r.homeRepDelta).clamp(0, 100),
      form: (p.form * 0.98 + (r.homeGoals > 0 ? 0.04 : 0.02)).clamp(0,1),
      fatigue: (p.fatigue + 0.15).clamp(0,1),
    )).toList();

    // Record PlayedMatch
    final played = PlayedMatch(
      week: state.week,
      homeName: state.myTeam.name,
      awayName: ensuredOpp.name,
      homeGoals: r.homeGoals,
      awayGoals: r.awayGoals,
    );

    // Mark fixture as played
    final newFixtures = [...state.fixtures];
    newFixtures[fxIndex] = fx.markPlayed(r.homeGoals, r.awayGoals);

    // Update table for my match
    var newTable = state.table.applyMatch(
      home: state.myTeam.name,
      away: ensuredOpp.name,
      homeGoals: r.homeGoals,
      awayGoals: r.awayGoals,
    );

    // Simulate AI vs AI matches this week (pair remaining AI teams randomly)
    final others = state.aiTeams.where((t) => t != ensuredOpp.name).toList();
    others.shuffle(_rng);
    for (int i = 0; i + 1 < others.length; i += 2) {
      final a = others[i];
      final b = others[i + 1];
      final hg = _poisson(1.4 + _rng.nextDouble()); // light scoring
      final ag = _poisson(1.2 + _rng.nextDouble());
      newTable = newTable.applyMatch(home: a, away: b, homeGoals: hg, awayGoals: ag);
    }

    state = state.copyWith(
      myTeam: state.myTeam.copyWith(squad: upd),
      opponent: ensuredOpp,
      history: [...state.history, played],
      fixtures: newFixtures,
      table: newTable,
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
    final upd = state.myTeam.squad.map((p)=>p.copyWith(
      reputation: (p.reputation + r.homeRepDelta).clamp(0, 100),
      form: (p.form * 0.98 + (r.homeGoals > 0 ? 0.04 : 0.02)).clamp(0,1),
      fatigue: (p.fatigue + 0.15).clamp(0,1),
    )).toList();

    final played = PlayedMatch(
      week: state.week,
      homeName: home,
      awayName: away,
      homeGoals: r.homeGoals,
      awayGoals: r.awayGoals,
    );

    final newTable = state.table.applyMatch(home: home, away: away, homeGoals: r.homeGoals, awayGoals: r.awayGoals);

    state = state.copyWith(
      myTeam: state.myTeam.copyWith(squad: upd),
      history: [...state.history, played],
      table: newTable,
    );
  }
}
