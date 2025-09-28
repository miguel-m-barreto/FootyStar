import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/player.dart';
import '../domain/skill.dart';
import '../domain/team.dart';
import '../domain/league.dart';
import '../domain/economy.dart';
import '../services/training_service.dart';
import '../services/match_service.dart';
import '../services/economy_service.dart';
import 'game_state.dart';
import '../models/played_match.dart';

class GameController extends Notifier<GameState> {
  late final _training = TrainingService();
  late final _match = MatchService();
  late final _eco = EconomyService();

  @override
  GameState build() {
    return _initialState();
  }

  GameState _initialState() {
    final p = Player(
      id: "p1", name: "Rui Silva", age: 22, form: 0.8, fatigue: 0.2, reputation: 15,
      skills: {
        "fin": Skill(id:"fin", name:"Finishing", level:62, stars:1),
        "pas": Skill(id:"pas", name:"Passing", level:58, stars:0),
        "spd": Skill(id:"spd", name:"Speed", level:64, stars:0),
      },
    );
    final q = Player(
      id: "p2", name: "João Costa", age: 24, form: 0.7, fatigue: 0.3, reputation: 12,
      skills: {
        "fin": Skill(id:"fin", name:"Finishing", level:55, stars:0),
        "pas": Skill(id:"pas", name:"Passing", level:61, stars:1),
        "spd": Skill(id:"spd", name:"Speed", level:59, stars:0),
      },
    );

    final my = Team(id:"t1", name:"HashStorm FC", squad:[p,q], morale:0.75);
    final opp = Team(id:"t2", name:"Lisbon United", squad:[p.copyWith(), q.copyWith()], morale:0.7);
    final lg = League(id:"pt2", name:"Segunda Liga", multiplier:1.00);
    final eco = Economy(cash: 10000, weeklyIncome: 800, weeklyCosts: 500);

    return GameState(
      myTeam: my,
      opponent: opp,
      league: lg,
      economy: eco,
      week: 1,
      history: const [], // NEW
    );
  }

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

  void endOfWeekEconomy() {
    state = state.copyWith(economy: _eco.applyWeekly(state.economy), week: state.week + 1);
  }

  void playMatch() {
    final res = _match.play(state.myTeam, state.opponent);

    final upd = state.myTeam.squad.map((p)=>p.copyWith(
      reputation: (p.reputation + res.homeRepDelta).clamp(0, 100),
      form: (p.form * 0.98 + (res.homeGoals > 0 ? 0.04 : 0.02)).clamp(0,1),
      fatigue: (p.fatigue + 0.15).clamp(0,1),
    )).toList();

    final played = PlayedMatch(
      week: state.week,
      homeName: state.myTeam.name,
      awayName: state.opponent.name,
      homeGoals: res.homeGoals,
      awayGoals: res.awayGoals,
    );

    state = state.copyWith(
      myTeam: state.myTeam.copyWith(squad: upd),
      history: [...state.history, played], // NEW
    );
  }

  void casinoWager(int amount) {
    state = state.copyWith(economy: _eco.casino(state.economy, amount));
  }
}
