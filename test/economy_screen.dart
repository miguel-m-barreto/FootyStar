// test/economy_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:footy_star/controllers/game_controller.dart';

import 'package:footy_star/ui/screens/economy_screen.dart';
import 'package:footy_star/providers/providers.dart';
import 'package:footy_star/state/game_state.dart';
import 'package:footy_star/domain/economy.dart';
import 'package:footy_star/domain/team.dart';
import 'package:footy_star/domain/league.dart';
import 'package:footy_star/models/league_table.dart';

// Fake notifier that returns a fixed GameState
class _FakeGameController extends GameController {
  final GameState _initial;
  _FakeGameController(this._initial);

  @override
  GameState build() => _initial;
}

void main() {
  testWidgets('EconomyScreen shows correct fields', (tester) async {
    final fakeState = GameState(
      myTeam: Team(id: "t1", name: "X", squad: const [], morale: 0.5),
      opponent: Team(id: "t2", name: "Y", squad: const [], morale: 0.5),
      league: const League(id: "l1", name: "Test League", multiplier: 1.0),
      economy: const Economy(cash: 1234, weeklyIncome: 100, weeklyCosts: 50),
      week: 1,
      history: const [],
      fixtures: const [],
      table: const LeagueTable({}),
      aiTeams: const [],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override the NotifierProvider with our fake notifier
          gameControllerProvider.overrideWith(() => _FakeGameController(fakeState)),
        ],
        child: const MaterialApp(home: EconomyScreen()),
      ),
    );

    expect(find.textContaining('Cash'), findsOneWidget);
    expect(find.textContaining('1234'), findsOneWidget);
    expect(find.textContaining('Weekly Income'), findsOneWidget);
    expect(find.textContaining('100'), findsOneWidget);
    expect(find.textContaining('Weekly Costs'), findsOneWidget);
    expect(find.textContaining('50'), findsOneWidget);
  });
}
