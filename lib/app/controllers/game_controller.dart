import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/player.dart';
import '../../domain/skill.dart';
import '../../domain/team.dart';
import '../../domain/league.dart';
import '../../domain/economy.dart';

import '../../domain/models/played_match.dart';
import '../../domain/models/fixture.dart';
import '../../domain/models/league_table.dart';

import '../../data/services/training_service.dart';
import '../../data/services/match_service.dart';
import '../../data/services/economy_service.dart';

import '../providers/providers.dart';
import '../state/game_state.dart';

// Notifications & message templates
import '../../domain/app_message.dart';
import '../../messages/general_messages.dart';
import '../../messages/economy_messages.dart';
import '../../messages/match_messages.dart';
import '../../messages/skill_messages.dart';
import '../../messages/casino_messages.dart';

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
      id: "p1",
      name: "Rui Silva",
      age: 22,
      form: 0.8,
      fatigue: 0.2,
      reputation: 15,
      skills: const {
        "fin": Skill(id: "fin", name: "Finishing", level: 62, stars: 1),
        "pas": Skill(id: "pas", name: "Passing", level: 58, stars: 0),
        "spd": Skill(id: "spd", name: "Speed", level: 64, stars: 0),
      },
    );
    final q = Player(
      id: "p2",
      name: "Joao Costa",
      age: 24,
      form: 0.7,
      fatigue: 0.3,
      reputation: 12,
      skills: const {
        "fin": Skill(id: "fin", name: "Finishing", level: 55, stars: 0),
        "pas": Skill(id: "pas", name: "Passing", level: 61, stars: 1),
        "spd": Skill(id: "spd", name: "Speed", level: 59, stars: 0),
      },
    );

    final my = Team(id: "t1", name: "HashStorm FC", squad: [p, q], morale: 0.75);
    final lg = const League(id: "pt2", name: "Second Division", multiplier: 1.00);
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
        "fin": Skill(id: "fin", name: "Finishing", level: 55 + _rng.nextInt(16), stars: _rng.nextInt(2)),
        "pas": Skill(id: "pas", name: "Passing", level: 55 + _rng.nextInt(16), stars: _rng.nextInt(2)),
        "spd": Skill(id: "spd", name: "Speed", level: 55 + _rng.nextInt(16), stars: _rng.nextInt(2)),
      },
    );
    final squad = List.generate(12, (i) => mk(i));
    return Team(
      id: "ai_${name.hashCode}",
      name: name,
      squad: squad,
      morale: 0.6 + _rng.nextDouble() * 0.3,
    );
  }

  // =========================
  // PLAYER-CENTRIC UTILITIES
  // =========================

  /// ID do jogador controlado (ajusta se tiveres outra flag)
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

  double _clamp01(double v) => v < 0 ? 0 : (v > 1 ? 1 : v);

  Player _passiveTrainOne(Player p) {
    // +1 em skills com estrela (até 99)
    final updated = <String, Skill>{};
    p.skills.forEach((id, sk) {
      if (sk.stars > 0) {
        updated[id] = sk.copyWith(level: (sk.level + 1).clamp(1, 99));
      } else {
        updated[id] = sk;
      }
    });
    return p.copyWith(skills: updated);
  }

  Player _recoverOne(Player p) {
    // recupera fadiga e “recentra” forma lentamente
    final newFatigue = _clamp01(p.fatigue - 0.10);
    final newForm = _clamp01(p.form * 0.96 + 0.02);
    return p.copyWith(fatigue: newFatigue, form: newForm);
  }

  /// Treino pessoal numa skill específica (não altera colegas).
  void selfTrain(String skillId) {
    final me0 = _me;
    final trained = _training.trainSkill(me0, skillId).copyWith(
      fatigue: (me0.fatigue + 0.12).clamp(0, 1),
      form: (me0.form * 0.98 + 0.02).clamp(0, 1),
    );
    _commitMe(trained);

    final lvl = trained.skills[skillId]?.level;
    if (lvl != null) {
      _notify('Training', SkillMessages.trained(trained.name, skillId, lvl));
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
    _notify('Economy', EconomyMessages.weekSummary(earned, spent, delta, economyNextWeek.cash));
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

  void playMatch() {
    // Allow only one official match per week (based on fixtures)
    final fxIndex = state.fixtures.indexWhere((f) => f.week == state.week);
    if (fxIndex == -1) {
      // No fixture defined for this week; fallback to current opponent (friendly)
      _playAndRecord(state.myTeam.name, state.opponent.name);
      _notify('Match', MatchMessages.friendly(state.myTeam.name, state.opponent.name));
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
    final upd = state.myTeam.squad
        .map((p) => p.id == _meId
        ? p.copyWith(
      reputation: (p.reputation + r.homeRepDelta).clamp(0, 100),
      form: (p.form * 0.98 + (r.homeGoals > 0 ? 0.04 : 0.02)).clamp(0, 1),
      fatigue: (p.fatigue + 0.15).clamp(0, 1),
    )
        : p)
        .toList();

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

    // Notify result
    _notify(
      'Match',
      MatchMessages.result(state.week, state.myTeam.name, r.homeGoals, ensuredOpp.name, r.awayGoals),
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
    final upd = state.myTeam.squad
        .map((p) => p.id == _meId
        ? p.copyWith(
      reputation: (p.reputation + r.homeRepDelta).clamp(0, 100),
      form: (p.form * 0.98 + (r.homeGoals > 0 ? 0.04 : 0.02)).clamp(0, 1),
      fatigue: (p.fatigue + 0.15).clamp(0, 1),
    )
        : p)
        .toList();

    final played = PlayedMatch(
      week: state.week,
      homeName: home,
      awayName: away,
      homeGoals: r.homeGoals,
      awayGoals: r.awayGoals,
    );

    final newTable =
    state.table.applyMatch(home: home, away: away, homeGoals: r.homeGoals, awayGoals: r.awayGoals);

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
  /// 1) Joga a jornada atual (ou friendly)
  /// 2) Treino passivo + recuperação do **teu** jogador
  /// 3) Economia semanal + avançar semana
  Future<void> advanceWeek() async {
    // 1) Jogo
    playMatch();

    // 2) Passivo + recovery (só no "eu")
    var me1 = _passiveTrainOne(_me);
    me1 = _recoverOne(me1);
    _commitMe(me1);

    // 3) Economia e avanço de semana (gera notificações)
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
    ref.read(notificationsProvider.notifier).push(
      AppMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        body: body,
        ts: DateTime.now(),
      ),
    );
  }
  // =========================
  // COACH TRUST (derived)
  // =========================

  /// Métrica derivada 0..1 baseada na tua forma (60%) e reputação (40%).
  double get coachTrust {
    final f = _me.form;            // 0..1
    final rep = _me.reputation;    // 0..100
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
    final base = coachTrust;                 // 0..1
    final bonus = 0.10;                      // indulgência
    final chance = (base + bonus).clamp(0, 0.95);  // cap 95%
    final roll = _rng.nextDouble();          // 0..1

    final cur = state.economy;
    if (roll < chance) {
      // aprovação simples: +10% arredondado
      final inc = (cur.weeklyIncome * 0.10).round();
      final next = cur.copyWith(weeklyIncome: cur.weeklyIncome + inc);
      state = state.copyWith(economy: next);
      _notify('Agent', 'Raise approved (+\$${inc}/week). New salary: \$${next.weeklyIncome}/week.');
    } else {
      _notify('Coach', 'Raise denied for now. Improve your form & reputation to increase chances.');
    }
  }



}
