class Economy {
  final int cash;
  final int weeklyIncome;
  final int weeklyCosts;

  // Metrics
  final int spentWeek;      // manual expenses this week (casino, purchases, etc.)
  final int spentSeason;    // accumulated season expenses
  final int spentAllTime;   // accumulated lifetime expenses
  final int earnedSeason;   // accumulated season earnings
  final int earnedAllTime;  // accumulated lifetime earnings

  const Economy({
    required this.cash,
    required this.weeklyIncome,
    required this.weeklyCosts,
    this.spentWeek = 0,
    this.spentSeason = 0,
    this.spentAllTime = 0,
    this.earnedSeason = 0,
    this.earnedAllTime = 0,
  });

  Economy copyWith({
    int? cash,
    int? weeklyIncome,
    int? weeklyCosts,
    int? spentWeek,
    int? spentSeason,
    int? spentAllTime,
    int? earnedSeason,
    int? earnedAllTime,
  }) {
    return Economy(
      cash: cash ?? this.cash,
      weeklyIncome: weeklyIncome ?? this.weeklyIncome,
      weeklyCosts: weeklyCosts ?? this.weeklyCosts,
      spentWeek: spentWeek ?? this.spentWeek,
      spentSeason: spentSeason ?? this.spentSeason,
      spentAllTime: spentAllTime ?? this.spentAllTime,
      earnedSeason: earnedSeason ?? this.earnedSeason,
      earnedAllTime: earnedAllTime ?? this.earnedAllTime,
    );
  }
}
