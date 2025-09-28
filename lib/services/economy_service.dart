import '../domain/economy.dart';
import 'dart:math';

class EconomyService {
  final _rng = Random();

  Economy applyWeekly(Economy e) {
    final delta = e.weeklyIncome - e.weeklyCosts;
    return e.copyWith(cash: e.cash + delta);
  }

  Economy casino(Economy e, int wager) {
    // Allow betting up to available cash (all-in possible).
    final w = wager.clamp(0, e.cash);
    if (w == 0) return e;

    // Simple house edge: ~48% win double, ~52% lose wager.
    final win = _rng.nextDouble() < 0.48;
    final nextCash = win ? (e.cash + w) : (e.cash - w);
    return e.copyWith(cash: nextCash);
  }
}
