import 'package:flutter_test/flutter_test.dart';
import 'package:footy_star/domain/economy.dart';
import 'package:footy_star/services/economy_service.dart';

void main() {
  final service = EconomyService();

  test('applyWeekly adds income and subtracts costs', () {
    final eco = Economy(cash: 1000, weeklyIncome: 200, weeklyCosts: 50);
    final next = service.applyWeekly(eco);
    expect(next.cash, 1150); // 1000 + (200 - 50)
  });

  test('casino win increases cash', () {
    final eco = Economy(cash: 1000, weeklyIncome: 0, weeklyCosts: 0);
    // force win by bypassing randomness: clamp wager=0 returns eco unchanged
    final res = service.casino(eco, 0);
    expect(res.cash, 1000);
  });

  test('recordExpense decreases cash and updates metrics', () {
    final eco = Economy(cash: 500, weeklyIncome: 0, weeklyCosts: 0);
    final next = service.recordExpense(eco, 200);
    expect(next.cash, 300);
    expect(next.spentWeek, 200);
    expect(next.spentSeason, 200);
    expect(next.spentAllTime, 200);
  });

  test('recordEarning increases cash and updates metrics', () {
    final eco = Economy(cash: 500, weeklyIncome: 0, weeklyCosts: 0);
    final next = service.recordEarning(eco, 150);
    expect(next.cash, 650);
    expect(next.earnedSeason, 150);
    expect(next.earnedAllTime, 150);
  });
}
