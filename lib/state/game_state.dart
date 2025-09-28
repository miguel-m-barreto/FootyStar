import '../domain/team.dart';
import '../domain/league.dart';
import '../domain/economy.dart';
import '../models/played_match.dart';

class GameState {
  final Team myTeam;
  final Team opponent;
  final League league;
  final Economy economy;
  final int week;
  final List<PlayedMatch> history; // NEW

  const GameState({
    required this.myTeam,
    required this.opponent,
    required this.league,
    required this.economy,
    required this.week,
    required this.history, // NEW
  });

  GameState copyWith({
    Team? myTeam,
    Team? opponent,
    League? league,
    Economy? economy,
    int? week,
    List<PlayedMatch>? history, // NEW
  }) => GameState(
    myTeam: myTeam ?? this.myTeam,
    opponent: opponent ?? this.opponent,
    league: league ?? this.league,
    economy: economy ?? this.economy,
    week: week ?? this.week,
    history: history ?? this.history, // NEW
  );
}
