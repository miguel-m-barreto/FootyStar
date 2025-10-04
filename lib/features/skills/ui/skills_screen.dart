import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers/providers.dart';
import '../../../domain/models/skill.dart';
import '../../../core/l10n/app_localizations.dart';

class SkillsScreen extends ConsumerWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);

    // Get player skills
    final player = state.myTeam.squad.first;
    final skills = player.skills;

    // Group skills by category
    final physicalSkills = skills.values.where((s) => s.category == SkillCategory.physical).toList();
    final technicalSkills = skills.values.where((s) => s.category == SkillCategory.technical).toList();
    final mentalSkills = skills.values.where((s) => s.category == SkillCategory.mental).toList();

    // Count skills ready to promote
    final readyToPromote = skills.values.where((s) => s.queuedLevels > 0).length;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.skills),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.physical),
              Tab(text: l10n.technical),
              Tab(text: l10n.mental),
            ],
          ),
          actions: [
            if (readyToPromote > 0)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Center(
                  child: FilledButton(
                    onPressed: () => _showPromoteAllDialog(context, ref),
                    child: Text('Promote All ($readyToPromote)'),
                  ),
                ),
              ),
          ],
        ),
        body: Column(
          children: [
            // SP Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Skill Points (SP)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${player.sp} SP',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Skills tabs
            Expanded(
              child: TabBarView(
                children: [
                  _SkillsList(skills: physicalSkills),
                  _SkillsList(skills: technicalSkills),
                  _SkillsList(skills: mentalSkills),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPromoteAllDialog(BuildContext context, WidgetRef ref) {
    final state = ref.read(gameControllerProvider);
    final player = state.myTeam.squad.first;

    // Calculate total cost
    int totalCost = 0;
    final skillsToPromote = player.skills.values.where((s) => s.queuedLevels > 0).toList();
    for (final skill in skillsToPromote) {
      totalCost += skill.totalPromotionCost;
    }

    final canAfford = state.economy.cash >= totalCost;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Promote All Skills'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${skillsToPromote.length} skills ready to promote'),
            const SizedBox(height: 8),
            Text(
              'Total Cost: \$$totalCost',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Current Cash: \$${state.economy.cash}',
              style: TextStyle(
                color: canAfford ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            onPressed: canAfford
                ? () {
              // TODO: Implement promote all in controller
              Navigator.pop(context);
            }
                : null,
            child: const Text('Promote'),
          ),
        ],
      ),
    );
  }
}

class _SkillsList extends ConsumerWidget {
  final List<Skill> skills;
  const _SkillsList({required this.skills});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: skills.length,
      itemBuilder: (context, index) {
        final skill = skills[index];
        return _SkillCard(skill: skill);
      },
    );
  }
}

class _SkillCard extends ConsumerWidget {
  final Skill skill;
  const _SkillCard({required this.skill});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.read(gameControllerProvider);

    final hasQueuedLevels = skill.queuedLevels > 0;
    final promotionCost = skill.promotionCost(skill.level);
    final canAfford = state.economy.cash >= promotionCost;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    skill.getLocalizedName(context),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      l10n.lvLevel(skill.level),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (hasQueuedLevels) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+${skill.queuedLevels}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: skill.progressPercent,
                minHeight: 8,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.xpProgress(skill.currentXp, skill.xpCapForLevel(skill.level)),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (hasQueuedLevels)
                  FilledButton.tonal(
                    onPressed: canAfford
                        ? () {
                      // TODO: Implement promote single skill
                    }
                        : null,
                    child: Text('Promote (\$$promotionCost)'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}