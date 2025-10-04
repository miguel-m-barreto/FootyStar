import 'package:footy_star/core/l10n/l10n_singleton.dart';

class EconomyMessages {
  static String weekSummary(int earned, int spent, int delta, int cash) =>
      L10n.i.weekSummary(earned, spent, delta, cash);
}
