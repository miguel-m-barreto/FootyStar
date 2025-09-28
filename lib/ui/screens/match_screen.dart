import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../models/played_match.dart';

class MatchScreen extends ConsumerWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);
    final ctrl = ref.read(gameControllerProvider.notifier);

    final last = s.history.isEmpty ? null : s.history.last;

    return Scaffold(
      appBar: AppBar(title: const Text('Match')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${s.myTeam.name} (OVR ${s.myTeam.ovr}) vs ${s.opponent.name} (OVR ${s.opponent.ovr})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            // Last result banner (if any)
            if (last != null) _LastResultBanner(match: last),

            FilledButton(
              onPressed: ctrl.playMatch,
              child: const Text('Play Match'),
            ),

            const SizedBox(height: 16),
            Text('History', style: Theme.of(context).textTheme.titleMedium),

            const SizedBox(height: 8),
            Expanded(
              child: s.history.isEmpty
                  ? const Center(child: Text('No matches played yet.'))
                  : ListView.separated(
                itemCount: s.history.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final m = s.history[s.history.length - 1 - i]; // newest first
                  return ListTile(
                    dense: true,
                    title: Text('${m.homeName} ${m.scoreline} ${m.awayName}'),
                    subtitle: Text('Week ${m.week}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LastResultBanner extends StatelessWidget {
  final PlayedMatch match;
  const _LastResultBanner({required this.match});

  @override
  Widget build(BuildContext context) {
    final text = '${match.homeName} ${match.scoreline} ${match.awayName}';
    ColorScheme cs = Theme.of(context).colorScheme;

    Color bg;
    if (match.homeWin) {
      bg = cs.primaryContainer;
    } else if (match.awayWin) {
      bg = cs.errorContainer;
    } else {
      bg = cs.surfaceContainerHighest;
    }

    return Container(
      key: const Key('last_result_banner'),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.scoreboard_outlined),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.titleSmall)),
          Text('Week ${match.week}'),
        ],
      ),
    );
  }
}
