import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/providers.dart';
import '../../../domain/models/app_message.dart';
import '../../match/ui/match_screen.dart';
import 'package:footy_star/core/l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final s = ref.watch(gameControllerProvider);
    final messages = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          IconButton(
            tooltip: l10n.advanceWeek,
            icon: const Icon(Icons.skip_next),
            onPressed: () async {
              await ref.read(gameControllerProvider.notifier).advanceWeek();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Team info
          Card(
            child: ListTile(
              title: Text(s.myTeam.name),
              subtitle: Text('${s.league.name} • ${l10n.week} ${s.week}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.cash),
                  Text('\$${s.economy.cash}',
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Quick stats
          Row(
            children: [
              Expanded(
                child: _StatChip(
                  label: l10n.weeklyIncome,
                  value: '\$${s.economy.weeklyIncome}',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatChip(
                  label: l10n.weeklyCosts,
                  value: '\$${s.economy.weeklyCosts}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Next match card
          Card(
            child: ListTile(
              leading: const Icon(Icons.sports_soccer),
              title: Text(l10n.nextMatch),
              subtitle: Text(
                '${l10n.week} ${s.week}: ${s.myTeam.name} vs ${s.opponent.name}',
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Notifications header + actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.notifications,
                  style: Theme.of(context).textTheme.titleMedium),
              TextButton(
                onPressed: () {
                  ref.read(notificationsProvider.notifier).clearAll();
                },
                child: Text(l10n.clearAll),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Notifications list
          if (messages.isEmpty)
            Center(child: Text(l10n.noNotifications))
          else
            ...messages.map((m) => _MessageTile(msg: m)).toList(),

          const SizedBox(height: 24),

          // Demo actions
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () {
                  ref.read(notificationsProvider.notifier).push(
                    AppMessage(
                      id: DateTime.now()
                          .microsecondsSinceEpoch
                          .toString(),
                      title: l10n.matchScheduled,
                      body: l10n.nextOpponent(s.opponent.name),
                      ts: DateTime.now(),
                    ),
                  );
                },
                child: Text(l10n.addDemoMessage),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const MatchScreen()),
                  );
                },
                child: Text(l10n.goToMatches),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _MessageTile extends ConsumerWidget {
  final AppMessage msg;
  const _MessageTile({required this.msg});

  String _localizedTitle(AppLocalizations l10n, String raw) {
    switch (raw) {
      case 'Economy':  return l10n.economy;
      case 'General':  return l10n.general;
      case 'Match':    return l10n.matches;   // chave existente é 'matches'
      case 'Skills':   return l10n.skills;
      case 'Training': return l10n.myTraining; // usa a que tens no l10n
      case 'Casino':   return l10n.casino;
      case 'Agent':    return l10n.general;   // fallback até criares 'agent' no .arb
      case 'Coach':    return l10n.general;   // idem (ou cria chave própria)
      default:         return raw;            // caso apareça algo novo
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isRead = msg.read;

    return Card(
      child: ListTile(
        title: Text(
          _localizedTitle(l10n, msg.title),
          style: TextStyle(
            fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
          ),
        ),
        subtitle: Text(msg.body),
        trailing: Icon(isRead ? Icons.mark_email_read : Icons.mark_email_unread),
        // ... resto igual
      ),
    );
  }
}

