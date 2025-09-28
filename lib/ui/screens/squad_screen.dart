import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';

class SquadScreen extends ConsumerWidget {
  const SquadScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Squad')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: s.myTeam.squad.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, i) {
          final p = s.myTeam.squad[i];
          return ListTile(
            title: Text('${p.name} — OVR ${p.ovr}'),
            subtitle: Text('Form ${(p.form*100).round()}% • Fatigue ${(p.fatigue*100).round()}% • Rep ${p.reputation.toStringAsFixed(1)}'),
            trailing: const Icon(Icons.chevron_right),
          );
        },
      ),
    );
  }
}
