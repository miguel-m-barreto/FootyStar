class PlayedMatch {
  final int week;
  final String homeName;
  final String awayName;
  final int homeGoals;
  final int awayGoals;

  const PlayedMatch({
    required this.week,
    required this.homeName,
    required this.awayName,
    required this.homeGoals,
    required this.awayGoals,
  });

  String get scoreline => '$homeGoals–$awayGoals';
  bool get homeWin => homeGoals > awayGoals;
  bool get awayWin => awayGoals > homeGoals;
  bool get draw => homeGoals == awayGoals;
}
