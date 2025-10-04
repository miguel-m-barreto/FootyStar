import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/controllers/game_controller.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../app/providers/providers.dart';
import '../../../domain/models/player.dart';
import '../../../domain/models/skill.dart';

class TrainingScreen extends ConsumerWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);

    // Assuming first player is "me"
    final me = state.myTeam.squad.first;

    // Group skills by category for display
    final physicalSkills = me.skills.values
        .where((s) => s.category == SkillCategory.physical)
        .toList();
    final technicalSkills = me.skills.values
        .where((s) => s.category == SkillCategory.technical)
        .toList();
    final mentalSkills = me.skills.values
        .where((s) => s.category == SkillCategory.mental)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myTraining),
        actions: [
          // SP indicator
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${me.sp} SP',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ProfileCard(me: me),
          const SizedBox(height: 16),

          // Physical Skills
          _SkillCategorySection(
            title: l10n.physical,
            skills: physicalSkills,
            player: me,
            controller: controller,
          ),
          const SizedBox(height: 16),

          // Technical Skills
          _SkillCategorySection(
            title: l10n.technical,
            skills: technicalSkills,
            player: me,
            controller: controller,
          ),
          const SizedBox(height: 16),

          // Mental Skills
          _SkillCategorySection(
            title: l10n.mental,
            skills: mentalSkills,
            player: me,
            controller: controller,
          ),
          const SizedBox(height: 16),

          // Recovery Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.recovery,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () {
                      controller.recoverSelf();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.recoverySession)),
                      );
                    },
                    icon: const Icon(Icons.health_and_safety),
                    label: Text(l10n.recoverySession),
                  ),
                ],
              ),
            ),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  me.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${l10n.ovr} ${me.ovr}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatBar(
                    label: l10n.form,
                    value: me.form,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatBar(
                    label: l10n.fatigue,
                    value: me.fatigue,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _Badge(
                  text: '${l10n.rep}: ${me.reputation.round()}',
                  icon: Icons.star,
                ),
                const SizedBox(width: 8),
                _Badge(
                  text: '${l10n.consistency}: ${me.consistency.round()}',
                  icon: Icons.timeline,
                ),
                const SizedBox(width: 8),
                _Badge(
                  text: '${l10n.determination}: ${me.determination.round()}',
                  icon: Icons.military_tech,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillCategorySection extends StatelessWidget {
  final String title;
  final List<Skill> skills;
  final Player player;
  final GameController controller;

  const _SkillCategorySection({
    required this.title,
    required this.skills,
    required this.player,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills
                  .map((skill) => _SkillChip(
                skill: skill,
                player: player,
                onTap: () {
                  controller.selfTrain(skill.id);
                },
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final Skill skill;
  final Player player;
  final VoidCallback onTap;

  const _SkillChip({
    required this.skill,
    required this.player,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasQueuedLevels = skill.queuedLevels > 0;

    return ActionChip(
      backgroundColor: hasQueuedLevels
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(skill.getLocalizedName(context)),
          const SizedBox(width: 4),
          Text(
            '${skill.level}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (hasQueuedLevels) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '+${skill.queuedLevels}',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ],
      ),
      onPressed: onTap,
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _StatBar({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '${(value * 100).round()}%',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final IconData icon;

  const _Badge({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}