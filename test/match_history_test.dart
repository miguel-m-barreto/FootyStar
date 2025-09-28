import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footy_star/providers/providers.dart';
import 'package:footy_star/state/game_state.dart';

void main() {
  test('playing a match appends a PlayedMatch to history', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    GameState s0 = container.read(gameControllerProvider);
    final ctrl = container.read(gameControllerProvider.notifier);

    expect(s0.history.length, 0);

    ctrl.playMatch();
    final s1 = container.read(gameControllerProvider);

    expect(s1.history.length, 1);
    final m = s1.history.last;
    expect(m.week, s0.week);
    expect(m.homeGoals, inInclusiveRange(0, 10));
    expect(m.awayGoals, inInclusiveRange(0, 10));
  });
}
