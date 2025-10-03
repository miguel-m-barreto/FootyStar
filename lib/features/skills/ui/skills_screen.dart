import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SkillsScreen extends ConsumerWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Skills'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Physical'),
              Tab(text: 'Technical'),
              Tab(text: 'Mental'),
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
    final skills = [
      'Acceleration',
      'Sprint Speed',
      'Agility',
      'Body Strength',
      'Jumping',
      'Stamina',
      'Power',
      'Flexibility',
      'Recovery',
    ];

    return _SkillsList(skills: skills);
  }
}

class _TechnicalSkillsTab extends StatelessWidget {
  const _TechnicalSkillsTab();

  @override
  Widget build(BuildContext context) {
    final skills = [
      'First Touch',
      'Dribbling',
      'Technique',
      'Short Passing',
      'Long Passing',
      'Vision',
      'Finishing',
      'Short Shots',
      'Long Shots',
      'Heading',
    ];

    return _SkillsList(skills: skills);
  }
}

class _MentalSkillsTab extends StatelessWidget {
  const _MentalSkillsTab();

  @override
  Widget build(BuildContext context) {
    final skills = [
      'Anticipation',
      'Positioning',
      'Marking',
      'Tackling',
      'Composure',
      'Consistency',
      'Leadership',
      'Determination',
      'Bravery',
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
                  'Lv $level',
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
              '$xp / $xpMax XP',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}