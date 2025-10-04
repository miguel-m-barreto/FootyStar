import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footy_star/core/l10n/app_localizations.dart';
import '../../../app/providers/providers.dart';

class SquadScreen extends ConsumerWidget {
  const SquadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final s = ref.watch(gameControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.squad)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: s.myTeam.squad.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, i) {
          final p = s.myTeam.squad[i];
          return ListTile(
            title: Text('${p.name} — ${l10n.ovr} ${p.ovr}'),
            subtitle: Text(
              '${l10n.form} ${(p.form * 100).round()}% • '
                  '${l10n.fatigue} ${(p.fatigue * 100).round()}% • '
                  '${l10n.rep} ${p.reputation.toStringAsFixed(1)}',
            ),
            trailing: const Icon(Icons.chevron_right),
          );
        },
      ),
    );
  }
}
