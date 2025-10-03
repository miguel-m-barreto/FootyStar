import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers/providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Footy Star')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${s.league.name} — Week ${s.week}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Team: ${s.myTeam.name}  |  OVR ${s.myTeam.ovr}  |  Morale ${(s.myTeam.morale*100).round()}%'),
            const SizedBox(height: 8),
            Text('Cash: \$${s.economy.cash}  |  Income ${s.economy.weeklyIncome}  |  Costs ${s.economy.weeklyCosts}'),
            const Spacer(),
            FilledButton(
              onPressed: () => ref.read(gameControllerProvider.notifier).endOfWeekEconomy(),
              child: const Text('End Week (Apply Economy)'),
            ),
          ],
        ),
      ),
    );
  }
}
