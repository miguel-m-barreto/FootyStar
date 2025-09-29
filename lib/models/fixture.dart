class Fixture {
  final int week;            // 1-based
  final String homeTeam;
  final String awayTeam;
  final bool played;
  final int? homeGoals;
  final int? awayGoals;

  const Fixture({
    required this.week,
    required this.homeTeam,
    required this.awayTeam,
    this.played = false,
    this.homeGoals,
    this.awayGoals,
  });

  bool get isMyTeamHome => false; // controller can ignore if not needed

  Fixture markPlayed(int hg, int ag) => Fixture(
    week: week,
    homeTeam: homeTeam,
    awayTeam: awayTeam,
    played: true,
    homeGoals: hg,
    awayGoals: ag,
  );
}
