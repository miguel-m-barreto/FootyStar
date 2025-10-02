import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../domain/app_message.dart';
import 'match_screen.dart';
import '../../providers/notifications_provider.dart' as notif;


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);
    final messages = ref.watch(notif.notificationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Player / Team info
          Card(
            child: ListTile(
              title: Text(s.myTeam.name),
              subtitle: Text('${s.league.name} • Week ${s.week}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Cash'),
                  Text('\$${s.economy.cash}', style: Theme.of(context).textTheme.titleMedium),
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
                  label: 'Weekly Income',
                  value: '\$${s.economy.weeklyIncome}',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatChip(
                  label: 'Weekly Costs',
                  value: '\$${s.economy.weeklyCosts}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Notifications header + actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Notifications', style: Theme.of(context).textTheme.titleMedium),
              TextButton(
                onPressed: () {
                  ref.read(notificationsProvider.notifier).clearAll();
                },
                child: const Text('Clear all'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Notifications list
          if (messages.isEmpty)
            const Center(child: Text('No notifications yet'))
          else
            ...messages.map((m) => _MessageTile(msg: m)).toList(),

          const SizedBox(height: 24),

          // Demo actions (now includes a quick shortcut to Matches)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () {
                  ref.read(notificationsProvider.notifier).push(
                    AppMessage(
                      id: DateTime.now().microsecondsSinceEpoch.toString(),
                      title: 'Match scheduled',
                      body: 'Next opponent: ${s.opponent.name}',
                      ts: DateTime.now(),
                    ),
                  );
                },
                child: const Text('Add demo message'),
              ),
              OutlinedButton(
                onPressed: () {
                  // Minimal navigation: push the Matches screen directly.
                  // If you prefer switching a bottom tab, wire a shared index/controller in the shell.
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MatchScreen()),
                  );
                },
                child: const Text('Go to Matches'),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRead = msg.read;
    return Card(
      child: ListTile(
        title: Text(
          msg.title,
          style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.w600),
        ),
        subtitle: Text(msg.body),
        trailing: IconButton(
          icon: Icon(isRead ? Icons.mark_email_read : Icons.mark_email_unread),
          onPressed: () {
            ref.read(notificationsProvider.notifier).markRead(msg.id);
          },
        ),
      ),
    );
  }
}
