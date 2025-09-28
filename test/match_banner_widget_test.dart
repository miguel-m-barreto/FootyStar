import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footy_star/ui/app_shell.dart';

void main() {
  testWidgets('last result banner shows after playing a match', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: AppShell())));
    await tester.pumpAndSettle();

    // Navigate to Match tab.
    await tester.tap(find.byIcon(Icons.sports_soccer_outlined));
    await tester.pumpAndSettle();

    // Initially, banner should not exist.
    expect(find.byKey(const Key('last_result_banner')), findsNothing);

    // Play one match.
    await tester.tap(find.text('Play Match'));
    await tester.pumpAndSettle();

    // Now banner should be visible with a scoreline.
    final banner = find.byKey(const Key('last_result_banner'));
    expect(banner, findsOneWidget);

    // It should contain the score glyph "–" between two numbers.
    final bannerText = tester.widgetList<Text>(find.descendant(of: banner, matching: find.byType(Text)))
        .map((t) => t.data ?? '')
        .join(' ');
    expect(RegExp(r'\b\d+–\d+\b').hasMatch(bannerText), isTrue);
  });
}
