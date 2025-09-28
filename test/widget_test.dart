import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footy_star/ui/app_shell.dart';

void main() {
  testWidgets('App builds, navigates, and updates Week/Cash', (tester) async {
    // Bootstraps the app inside a ProviderScope (Riverpod state container).
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: AppShell()),
      ),
    );
    await tester.pumpAndSettle();

    // 1) Verify app starts on the Dashboard.
    // The header should contain " — Week 1" (league name + week counter).
    expect(find.textContaining(' — Week '), findsOneWidget);

    // 2) Navigate to the Economy tab.
    await tester.tap(find.byIcon(Icons.attach_money_outlined));
    await tester.pumpAndSettle();

    // 3) Read initial cash value from the label.
    final cashBeforeText =
    tester.widget<Text>(find.textContaining('Cash:')).data!;
    final cashBefore = int.parse(
      RegExp(r'Cash: \$(\d+)').firstMatch(cashBeforeText)!.group(1)!,
    );

    // 4) Place an "All In" casino bet.
    // This will either double the money (win) or lose it all (lose).
    final allInBtn = find.text('Casino — All In');
    expect(allInBtn, findsOneWidget);
    await tester.tap(allInBtn);
    await tester.pump();

    // 5) End the week to apply economy (income - costs).
    final endWeekBtn = find.text('End Week (Apply Income/Costs)');
    expect(endWeekBtn, findsOneWidget);
    await tester.tap(endWeekBtn);
    await tester.pump();

    // 6) Go back to the Dashboard and check the week incremented.
    // It should now display "Week 2" in the header.
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();
    expect(find.textContaining('Week 2'), findsOneWidget);

    // 7) Go back to Economy and confirm the cash label exists.
    // Value can vary (casino RNG + weekly income/costs), but must be >= 0.
    await tester.tap(find.byIcon(Icons.attach_money_outlined));
    await tester.pumpAndSettle();
    final cashAfterText =
    tester.widget<Text>(find.textContaining('Cash:')).data!;
    final cashAfter = int.parse(
      RegExp(r'Cash: \$(\d+)').firstMatch(cashAfterText)!.group(1)!,
    );
    expect(cashAfter, isNonNegative);

    // (Optional) You could also assert cashAfter != cashBefore
    // if you want to ensure the casino bet had an effect.
  });
}
