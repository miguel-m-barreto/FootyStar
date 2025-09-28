import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';

class TrainingScreen extends ConsumerWidget {
  const TrainingScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);
    final ctrl = ref.read(gameControllerProvider.notifier);
    final p = s.myTeam.squad.first;
    final skills = p.skills.values.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Training')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Focus player: ${p.name} (OVR ${p.ovr})'),
            const SizedBox(height: 12),
            ...skills.map((sk) => ListTile(
              title: Text('${sk.name} — Lvl ${sk.level}'),
              subtitle: Text('Stars ${sk.stars} (+${(25*sk.stars)}% XP/wk)'),
              trailing: FilledButton(
                onPressed: ()=> ctrl.train(p.id, sk.id),
                child: const Text('Train'),
              ),
            )),
            const Spacer(),
            OutlinedButton(
              onPressed: ctrl.restAll,
              child: const Text('Rest All Squad'),
            ),
          ],
        ),
      ),
    );
  }
}
