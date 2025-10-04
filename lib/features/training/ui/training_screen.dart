import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:footy_star/core/l10n/app_localizations.dart';
import '../../../app/providers/providers.dart';
import '../../../domain/player.dart';
import '../../../domain/skill.dart';

class TrainingScreen extends ConsumerWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final s = ref.watch(gameControllerProvider);
    // assuming first player is "me"
    final me = s.myTeam.squad.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myTraining),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ProfileCard(me: me),
          const SizedBox(height: 12),
          Text(l10n.skills, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: me.skills.values
                .map((sk) => _SkillActionChip(me: me, sk: sk))
                .toList(),
          ),
          const SizedBox(height: 16),
          Text(l10n.recovery, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () {
              ref.read(gameControllerProvider.notifier).recoverSelf();
            },
            icon: const Icon(Icons.health_and_safety),
            label: Text(l10n.recoverySession),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final Player me;
  const _ProfileCard({required this.me});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(me.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Badge(text: '${l10n.form} ${(me.form * 100).round()}%'),
                _Badge(text: '${l10n.fatigue} ${(me.fatigue * 100).round()}%'),
                _Badge(text: '${l10n.rep} ${me.reputation.round()}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillActionChip extends ConsumerWidget {
  final Player me;
  final Skill sk;
  const _SkillActionChip({required this.me, required this.sk});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label =
        '${sk.name} ${sk.level}${sk.stars > 0 ? " ★" * sk.stars : ""}';
    return ActionChip(
      label: Text(label),
      onPressed: () {
        ref.read(gameControllerProvider.notifier).selfTrain(sk.id);
      },
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
