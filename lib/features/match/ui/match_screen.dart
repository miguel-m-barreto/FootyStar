import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/providers.dart';
import '../../../domain/models/fixture.dart';

class MatchScreen extends ConsumerWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);

    final fixtures = s.fixtures;
    if (fixtures.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Matches')),
        body: const Center(child: Text('No fixtures scheduled')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Matches')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: fixtures.length,
        separatorBuilder: (_, __) => const SizedBox(height: 6),
        itemBuilder: (context, i) {
          final f = fixtures[i];
          final isCurrent = f.week == s.week;
          final played = f.played;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: ListTile(
              leading: _WeekBadge(week: f.week, highlight: isCurrent && !played),
              title: Text('${f.homeTeam} vs ${f.awayTeam}'),
              subtitle: played
                  ? _ResultTag(hg: f.homeGoals, ag: f.awayGoals)
                  : isCurrent
                  ? const Text('This week’s match')
                  : null,
              trailing: (!played && isCurrent)
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Só joga o match, mantém a mesma semana
                  OutlinedButton(
                    onPressed: () {
                      ref.read(gameControllerProvider.notifier).playMatch();
                    },
                    child: const Text('Play'),
                  ),
                  const SizedBox(width: 8),
                  // Joga e avança a semana (economia + treino passivo + week++)
                  ElevatedButton(
                    onPressed: () async {
                      await ref.read(gameControllerProvider.notifier).advanceWeek();
                    },
                    child: const Text('Play & Advance'),
                  ),
                ],
              )
                  : null,
            ),
          );
        },
      ),
    );
  }
}

class _WeekBadge extends StatelessWidget {
  final int week;
  final bool highlight;
  const _WeekBadge({required this.week, required this.highlight});

  @override
  Widget build(BuildContext context) {
    final bg = highlight
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.surfaceVariant;
    final fg = highlight
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'W$week',
        style: TextStyle(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ResultTag extends StatelessWidget {
  final int? hg;
  final int? ag;
  const _ResultTag({required this.hg, required this.ag});

  @override
  Widget build(BuildContext context) {
    final has = (hg != null && ag != null);
    final text = has ? 'Result: $hg - $ag' : 'Result pending';
    return Text(text);
  }
}
