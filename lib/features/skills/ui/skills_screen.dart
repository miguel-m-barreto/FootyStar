import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footy_star/core/l10n/app_localizations.dart';

class SkillsScreen extends ConsumerWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

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
        ),
        body: const TabBarView(
          children: [
            _PhysicalSkillsTab(),
            _TechnicalSkillsTab(),
            _MentalSkillsTab(),
          ],
        ),
      ),
    );
  }
}

class _PhysicalSkillsTab extends StatelessWidget {
  const _PhysicalSkillsTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final skills = <String>[
      l10n.acceleration,
      l10n.sprintSpeed,
      l10n.agility,
      l10n.bodyStrength,
      l10n.jumping,
      l10n.stamina,
      l10n.power,
      l10n.flexibility,
      l10n.recovery,
    ];

    return _SkillsList(skills: skills);
  }
}

class _TechnicalSkillsTab extends StatelessWidget {
  const _TechnicalSkillsTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final skills = <String>[
      l10n.firstTouch,
      l10n.dribbling,
      l10n.technique,
      l10n.shortPassing,
      l10n.longPassing,
      l10n.vision,
      l10n.finishing,
      l10n.shortShots,
      l10n.longShots,
      l10n.heading,
    ];

    return _SkillsList(skills: skills);
  }
}

class _MentalSkillsTab extends StatelessWidget {
  const _MentalSkillsTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final skills = <String>[
      l10n.anticipation,
      l10n.positioning,
      l10n.marking,
      l10n.tackling,
      l10n.composure,
      l10n.consistency,
      l10n.leadership,
      l10n.determination,
      l10n.bravery,
    ];

    return _SkillsList(skills: skills);
  }
}

class _SkillsList extends StatelessWidget {
  final List<String> skills;
  const _SkillsList({required this.skills});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: skills.length,
      itemBuilder: (context, index) {
        return _SkillCard(
          name: skills[index],
          level: 50 + index * 3, // placeholder
          xp: 45, // placeholder
          xpMax: 100,
        );
      },
    );
  }
}

class _SkillCard extends StatelessWidget {
  final String name;
  final int level;
  final int xp;
  final int xpMax;

  const _SkillCard({
    required this.name,
    required this.level,
    required this.xp,
    required this.xpMax,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  l10n.lvLevel(level),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: xp / xpMax,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.xpProgress(xp, xpMax),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
