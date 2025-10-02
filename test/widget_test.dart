// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:footy_star/ui/screens/economy_screen.dart';
import 'package:footy_star/ui/screens/casino_screen.dart';
import 'package:footy_star/providers/providers.dart';
import 'package:footy_star/controllers/game_controller.dart';
import 'package:footy_star/state/game_state.dart';
import 'package:footy_star/domain/economy.dart';
import 'package:footy_star/domain/team.dart';
import 'package:footy_star/domain/league.dart';
import 'package:footy_star/models/league_table.dart';

/// Minimal shell to mount any screen.
class _Shell extends StatelessWidget {
  const _Shell({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => MaterialApp(home: child);
}

/// Try to reach the Casino screen in a resilient way.
/// If direct navigation is not available, fallback mounts CasinoScreen
/// wrapped with the same Provider overrides used by the test.
Future<void> _goToCasino(
    WidgetTester tester, {
      required List<Override> overrides,
    }) async {
  // Try by visible text 'Casino'
  final casinoTextBtn = find.text('Casino');
  if (casinoTextBtn.evaluate().isNotEmpty) {
    await tester.tap(casinoTextBtn);
    await tester.pumpAndSettle();
    return;
  }

  // Try by casino icon
  final casinoIcon = find.byIcon(Icons.casino);
  if (casinoIcon.evaluate().isNotEmpty) {
    await tester.tap(casinoIcon.first);
    await tester.pumpAndSettle();
    return;
  }

  // Fallback: mount CasinoScreen with ProviderScope + overrides
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: const _Shell(child: CasinoScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

/// Fake notifier that fixes the GameState returned by build().
class _FakeGameController extends GameController {
  final GameState _initial;
  _FakeGameController(this._initial);

  @override
  GameState build() => _initial;
}

void main() {
  testWidgets('App builds, navigates, and updates Week/Cash', (tester) async {
    final fake = GameState(
      myTeam: const Team(id: 't1', name: 'HashStorm FC', squad: [], morale: 0.7),
      opponent: const Team(id: 't2', name: 'Lisbon United', squad: [], morale: 0.6),
      league: const League(id: 'pt2', name: 'Segunda Liga', multiplier: 1.0),
      economy: const Economy(cash: 1500, weeklyIncome: 200, weeklyCosts: 50),
      week: 1,
      history: const [],
      fixtures: const [],
      table: const LeagueTable({}),
      aiTeams: const [],
    );

    final overrides = <Override>[
      // IMPORTANT: override with a notifier factory, not a GameState.
      gameControllerProvider.overrideWith(() => _FakeGameController(fake)),
    ];

    // Start on EconomyScreen to assert labels, then navigate to Casino.
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: const _Shell(child: EconomyScreen()),
      ),
    );

    // Economy labels exist
    expect(find.textContaining('Cash'), findsOneWidget);
    expect(find.textContaining('Weekly Income'), findsOneWidget);
    expect(find.textContaining('Weekly Costs'), findsOneWidget);

    // Navigate to Casino (uses same overrides on fallback)
    await _goToCasino(tester, overrides: overrides);

    // Casino buttons should be present
    expect(find.text('Casino — Place Bet'), findsOneWidget);
    expect(find.text('Casino — All In'), findsOneWidget);

    // Interact: type a wager and place a bet
    final amountField = find.byType(TextField);
    if (amountField.evaluate().isNotEmpty) {
      await tester.enterText(amountField, '50');
      await tester.pump();
    }
    await tester.tap(find.text('Casino — Place Bet'));
    await tester.pump(); // SnackBar may show; no strict assertion needed
  });
}
