import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footy_star/providers/providers.dart';

class EconomyScreen extends ConsumerStatefulWidget {
  const EconomyScreen({super.key});
  @override
  ConsumerState<EconomyScreen> createState() => _EconomyScreenState();
}

class _EconomyScreenState extends ConsumerState<EconomyScreen> {
  @override
  Widget build(BuildContext context) {
    final s = ref.watch(gameControllerProvider);
    final g = ref.read(gameControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Economy')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cash: \$${s.economy.cash}'),
            const SizedBox(height: 8),
            Text('Weekly Income: \$${s.economy.weeklyIncome}'),
            Text('Weekly Costs:  \$${s.economy.weeklyCosts}'),
            const Divider(height: 24),
            Text('Spent — This Week:   \$${s.economy.spentWeek}'),
            Text('Spent — This Season: \$${s.economy.spentSeason}'),
            Text('Spent — All Time:    \$${s.economy.spentAllTime}'),
            const SizedBox(height: 12),
            Text('Earned — This Season: \$${s.economy.earnedSeason}'),
            Text('Earned — All Time:    \$${s.economy.earnedAllTime}'),
            const Spacer(),
            FilledButton(
              onPressed: () => g.endOfWeekEconomy(),
              child: const Text('End Week (Apply Income/Costs)'),
            ),
          ],
        ),
      ),
    );
  }
}
