import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footy_star/core/l10n/app_localizations.dart';
import '../../../app/providers/providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final s = ref.watch(gameControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.footyStar)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${s.league.name} — ${l10n.week} ${s.week}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${l10n.teamOverview}: ${s.myTeam.name}  |  ${l10n.ovr} ${s.myTeam.ovr}  |  ${l10n.morale} ${(s.myTeam.morale * 100).round()}%',
            ),
            const SizedBox(height: 8),
            Text(
              '${l10n.cash}: \$${s.economy.cash}  |  ${l10n.income} ${s.economy.weeklyIncome}  |  ${l10n.costs} ${s.economy.weeklyCosts}',
            ),
            const Spacer(),
            FilledButton(
              onPressed: () =>
                  ref.read(gameControllerProvider.notifier).endOfWeekEconomy(),
              child: Text(l10n.endWeekApplyEconomy),
            ),
          ],
        ),
      ),
    );
  }
}
