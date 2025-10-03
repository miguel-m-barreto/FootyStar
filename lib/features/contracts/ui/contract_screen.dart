import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers/providers.dart';

class ContractScreen extends ConsumerWidget {
  const ContractScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final economy = state.economy;

    final weekly = economy.weeklyIncome;
    final annual = weekly * 52;

    // Contract details (placeholder for now)
    const duration = 2; // years
    const startDate = '01/07/2024';
    const endDate = '30/06/2026';
    const role = 'Rotation';

    // Bonuses
    const bonusGoal = 500;
    const bonusAssist = 250;
    const bonusCleanSheet = 300;
    const bonusMotm = 400;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contract Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share contract
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Contract Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.verified,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Active Contract',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _ContractRow(label: 'Club', value: state.myTeam.name),
                  _ContractRow(label: 'Duration', value: '$duration years'),
                  _ContractRow(label: 'Start Date', value: startDate),
                  _ContractRow(label: 'End Date', value: endDate),
                  _ContractRow(label: 'Role', value: role),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Salary Section
          Text('Salary', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Weekly'),
                      Text(
                        '\$$weekly',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Annual'),
                      Text(
                        '\$$annual',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Bonuses Section
          Text('Performance Bonuses', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),

          Card(
            child: Column(
              children: [
                _BonusTile(label: 'Per Goal', amount: bonusGoal, icon: Icons.sports_soccer),
                const Divider(height: 1),
                _BonusTile(label: 'Per Assist', amount: bonusAssist, icon: Icons.assistant),
                const Divider(height: 1),
                _BonusTile(label: 'Clean Sheet', amount: bonusCleanSheet, icon: Icons.shield),
                const Divider(height: 1),
                _BonusTile(label: 'Man of the Match', amount: bonusMotm, icon: Icons.star),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Clauses Section
          Text('Clauses', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ClauseItem(label: 'Release Clause', value: '\$5,000,000'),
                  const SizedBox(height: 8),
                  _ClauseItem(label: 'Wage Rise After 20 Games', value: '+10%'),
                  const SizedBox(height: 8),
                  _ClauseItem(label: 'Loyalty Bonus', value: '\$50,000 after 2 years'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContractRow extends StatelessWidget {
  final String label;
  final String value;

  const _ContractRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _BonusTile extends StatelessWidget {
  final String label;
  final int amount;
  final IconData icon;

  const _BonusTile({
    required this.label,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(label),
      trailing: Text(
        '\$$amount',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _ClauseItem extends StatelessWidget {
  final String label;
  final String value;

  const _ClauseItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}