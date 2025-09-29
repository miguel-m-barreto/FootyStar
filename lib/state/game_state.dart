import '../domain/team.dart';
import '../domain/league.dart';
import '../domain/economy.dart';
import '../models/played_match.dart';
import '../models/fixture.dart';
import '../models/league_table.dart';

class GameState {
  final Team myTeam;
  final Team opponent;
  final League league;
  final Economy economy;
  final int week;                     // drives the current fixture
  final List<PlayedMatch> history;
  final List<Fixture> fixtures;       // NEW
  final LeagueTable table;            // NEW
  final List<String> aiTeams;         // NEW

  const GameState({
    required this.myTeam,
    required this.opponent,
    required this.league,
    required this.economy,
    required this.week,
    required this.history,
    required this.fixtures,           // NEW
    required this.table,              // NEW
    required this.aiTeams,            // NEW
  });

  GameState copyWith({
    Team? myTeam,
    Team? opponent,
    League? league,
    Economy? economy,
    int? week,
    List<PlayedMatch>? history,
    List<Fixture>? fixtures,
    LeagueTable? table,
    List<String>? aiTeams,
  }) => GameState(
    myTeam: myTeam ?? this.myTeam,
    opponent: opponent ?? this.opponent,
    league: league ?? this.league,
    economy: economy ?? this.economy,
    week: week ?? this.week,
    history: history ?? this.history,
    fixtures: fixtures ?? this.fixtures,
    table: table ?? this.table,
    aiTeams: aiTeams ?? this.aiTeams,
  );
}
