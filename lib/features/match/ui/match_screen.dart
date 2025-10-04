import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footy_star/core/l10n/app_localizations.dart';

import '../../../app/providers/providers.dart';
import '../../../domain/models/fixture.dart';

class MatchScreen extends ConsumerWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final s = ref.watch(gameControllerProvider);

    final fixtures = s.fixtures;
    if (fixtures.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.matches)),
        body: Center(child: Text(l10n.noFixturesScheduled)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.matches)),
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
              leading:
              _WeekBadge(week: f.week, highlight: isCurrent && !played),
              title: Text('${f.homeTeam} vs ${f.awayTeam}'),
              subtitle: played
                  ? _ResultTag(hg: f.homeGoals, ag: f.awayGoals)
                  : isCurrent
                  ? Text(l10n.thisWeeksMatch)
                  : null,
              trailing: (!played && isCurrent)
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      ref
                          .read(gameControllerProvider.notifier)
                          .playMatch();
                    },
                    child: Text(l10n.play),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(gameControllerProvider.notifier)
                          .advanceWeek();
                    },
                    child: Text(l10n.playAdvance),
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
    final l10n = AppLocalizations.of(context)!;

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
        l10n.wWeek(week),
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
    final l10n = AppLocalizations.of(context)!;
    final has = (hg != null && ag != null);
    final text = has ? l10n.resultScore(hg!, ag!) : l10n.resultPending;
    return Text(text);
  }
}
