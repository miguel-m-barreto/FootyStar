import '../../domain/team.dart';
import '../../domain/league.dart';
import '../../domain/economy.dart';
import '../../domain/business.dart';
import '../../domain/models/played_match.dart';
import '../../domain/models/fixture.dart';
import '../../domain/models/league_table.dart';

class GameState {
  final Team myTeam;
  final Team opponent;
  final League league;
  final Economy economy;
  final int week;                     // drives the current fixture
  final List<PlayedMatch> history;
  final List<Fixture> fixtures;
  final LeagueTable table;
  final List<String> aiTeams;

  // NEW: businesses
  final List<Business> catalogBusinesses; // available to buy (templates)
  final List<Business> myBusinesses;      // owned with levels

  const GameState({
    required this.myTeam,
    required this.opponent,
    required this.league,
    required this.economy,
    required this.week,
    required this.history,
    required this.fixtures,
    required this.table,
    required this.aiTeams,
    this.catalogBusinesses = const [],
    this.myBusinesses = const [],
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
    List<Business>? catalogBusinesses,
    List<Business>? myBusinesses,
  }) {
    return GameState(
      myTeam: myTeam ?? this.myTeam,
      opponent: opponent ?? this.opponent,
      league: league ?? this.league,
      economy: economy ?? this.economy,
      week: week ?? this.week,
      history: history ?? this.history,
      fixtures: fixtures ?? this.fixtures,
      table: table ?? this.table,
      aiTeams: aiTeams ?? this.aiTeams,
      catalogBusinesses: catalogBusinesses ?? this.catalogBusinesses,
      myBusinesses: myBusinesses ?? this.myBusinesses,
    );
  }
}
