class Economy {
  final int cash;         // $
  final int weeklyIncome; // baseline
  final int weeklyCosts;  // salaries, etc.

  const Economy({
    required this.cash,
    required this.weeklyIncome,
    required this.weeklyCosts,
  });

  Economy copyWith({int? cash, int? weeklyIncome, int? weeklyCosts}) =>
      Economy(
        cash: cash ?? this.cash,
        weeklyIncome: weeklyIncome ?? this.weeklyIncome,
        weeklyCosts: weeklyCosts ?? this.weeklyCosts,
      );
}
