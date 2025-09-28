import 'package:flutter_test/flutter_test.dart';
import 'package:footy_star/domain/economy.dart';
import 'package:footy_star/services/economy_service.dart';

void main() {
  group('EconomyService', () {
    test('applyWeekly adjusts cash by income - costs', () {
      final svc = EconomyService();
      final e0 = const Economy(cash: 1000, weeklyIncome: 800, weeklyCosts: 500);
      final e1 = svc.applyWeekly(e0);
      expect(e1.cash, 1300);
    });

    test('casino clamps wager to available cash and never goes negative', () {
      final svc = EconomyService();
      final e0 = const Economy(cash: 200, weeklyIncome: 0, weeklyCosts: 0);

      // Try to over-bet
      final e1 = svc.casino(e0, 99999);
      // Outcome must be either +200 (win) or 0 (lose)
      expect(<int>{0, 400}.contains(e1.cash), isTrue);

      // Bet zero should be no-op
      final e2 = svc.casino(e1, 0);
      expect(e2.cash, e1.cash);
    });

    test('casino with normal wager changes cash by exactly ±wager', () {
      final svc = EconomyService();
      final e0 = const Economy(cash: 1000, weeklyIncome: 0, weeklyCosts: 0);
      final e1 = svc.casino(e0, 100);
      expect(<int>{900, 1100}.contains(e1.cash), isTrue);
    });
  });
}
