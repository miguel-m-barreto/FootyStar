import 'package:flutter_test/flutter_test.dart';
import 'package:footy_star/controllers/game_controller.dart';
import 'package:footy_star/state/game_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footy_star/providers/providers.dart';

void main() {
  test('initial state and basic actions', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    GameState s0 = container.read(gameControllerProvider);
    expect(s0.week, 1);
    final initialCash = s0.economy.cash;

    // Train first player, first skill id (known from seed)
    final ctrl = container.read(gameControllerProvider.notifier);
    final pId = s0.myTeam.squad.first.id;
    final firstSkillId = s0.myTeam.squad.first.skills.keys.first;

    ctrl.train(pId, firstSkillId);
    GameState s1 = container.read(gameControllerProvider);
    expect(s1.myTeam.squad.first.skills[firstSkillId]!.level,
        greaterThan(s0.myTeam.squad.first.skills[firstSkillId]!.level));

    // Play a match (should change fatigue/form/reputation)
    ctrl.playMatch();
    GameState s2 = container.read(gameControllerProvider);
    expect(s2.myTeam.squad.first.fatigue, greaterThanOrEqualTo(s1.myTeam.squad.first.fatigue));

    // End of week applies economy and increments week
    ctrl.endOfWeekEconomy();
    GameState s3 = container.read(gameControllerProvider);
    expect(s3.week, s2.week + 1);
    expect(s3.economy.cash, initialCash + s3.economy.weeklyIncome - s3.economy.weeklyCosts);
  });
}
