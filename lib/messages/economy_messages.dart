class EconomyMessages {
  static String weekSummary(int earned, int spent, int delta, int cash) =>
      'Income: \$$earned • Costs: \$$spent • '
      'Delta: ${delta >= 0 ? '+' : ''}\$$delta • Cash: \$$cash';
}
