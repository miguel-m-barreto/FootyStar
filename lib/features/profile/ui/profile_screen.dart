import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:footy_star/core/l10n/app_localizations.dart';
import '../../../app/providers/providers.dart';
import '../../contracts/ui/contract_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);

    // Assuming first player is "me"
    final me = state.myTeam.squad.first;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Player Card
          _ProfileCard(
            name: me.name,
            age: me.age,
            ovr: me.ovr,
            reputation: me.reputation,
            form: me.form,
          ),

          const SizedBox(height: 16),

          // Coach Relationship
          _RelationshipCard(
            title: l10n.coachTrust,
            value: controller.coachTrust,
            status: controller.coachStatus,
            icon: Icons.sports,
          ),

          const SizedBox(height: 12),

          // Agent Relationship
          _RelationshipCard(
            title: l10n.agentRelationship,
            value: 0.65, // placeholder
            status: l10n.good,
            icon: Icons.handshake,
          ),

          const SizedBox(height: 16),

          // Actions Section
          Text(l10n.actions, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: () => controller.askForRaise(),
                icon: const Icon(Icons.trending_up),
                label: Text(l10n.requestSalaryRaise),
              ),
              OutlinedButton.icon(
                onPressed: () => controller.requestTransfer(),
                icon: const Icon(Icons.flight_takeoff),
                label: Text(l10n.requestTransfer),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ContractScreen()),
                  );
                },
                icon: const Icon(Icons.description),
                label: Text(l10n.viewContract),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Stats Overview
          Text(l10n.careerStats, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(child: _StatCard(label: l10n.matches, value: '${state.history.length}')),
              const SizedBox(width: 8),
              Expanded(child: _StatCard(label: l10n.goals, value: '0')), // TODO: track
              const SizedBox(width: 8),
              Expanded(child: _StatCard(label: l10n.assists, value: '0')), // TODO: track
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String name;
  final int age;
  final int ovr;
  final double reputation;
  final double form;

  const _ProfileCard({
    required this.name,
    required this.age,
    required this.ovr,
    required this.reputation,
    required this.form,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                ovr.toString(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              l10n.ageAge(age),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Badge(label: l10n.form, value: '${(form * 100).round()}%'),
                _Badge(label: l10n.rep, value: reputation.toStringAsFixed(1)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RelationshipCard extends StatelessWidget {
  final String title;
  final double value;
  final String status;
  final IconData icon;

  const _RelationshipCard({
    required this.title,
    required this.value,
    required this.status,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: value,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.statusPercent(status, (value * 100).round()),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final String value;

  const _Badge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
