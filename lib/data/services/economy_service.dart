import 'dart:math';
import 'package:footy_star/domain/models/economy.dart';

/// Pure functions to transform Economy while keeping counters consistent.
/// Keep UI and controller logic thin by delegating cash/metrics math here.
class EconomyService {
  final _rng = Random();

  /// Apply the weekly delta (income - costs) to cash.
  /// Aggregations for season/all-time remain as-is.
  Economy applyWeekly(Economy e) {
    final delta = e.weeklyIncome - e.weeklyCosts;
    return e.copyWith(cash: e.cash + delta);
  }

  /// Casino bet: wagers up to available cash.
  /// Returns a new Economy with updated cash only; the controller updates metrics.
  Economy casino(Economy e, int wager) {
    final w = wager.clamp(0, e.cash);
    if (w == 0) return e;

    // ~48% win (earn +w), ~52% lose (spend w)
    final win = _rng.nextDouble() < 0.48;
    final nextCash = win ? (e.cash + w) : (e.cash - w);
    return e.copyWith(cash: nextCash);
  }

  /// Records a manual expense (e.g., purchase, fee).
  /// Clamps amount to not drive cash below zero.
  Economy recordExpense(Economy e, int amount) {
    final a = amount <= 0 ? 0 : amount;
    if (a == 0) return e;
    final spend = a.clamp(0, e.cash);
    return e.copyWith(
      cash: e.cash - spend,
      spentWeek: e.spentWeek + spend,
      spentSeason: e.spentSeason + spend,
      spentAllTime: e.spentAllTime + spend,
    );
  }

  /// Records a manual earning (e.g., prize, sponsorship).
  Economy recordEarning(Economy e, int amount) {
    final a = amount <= 0 ? 0 : amount;
    if (a == 0) return e;
    return e.copyWith(
      cash: e.cash + a,
      earnedSeason: e.earnedSeason + a,
      earnedAllTime: e.earnedAllTime + a,
    );
  }
}
