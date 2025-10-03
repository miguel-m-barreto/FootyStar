import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers/providers.dart';
import '../../casino/ui/casino_screen.dart';

class EconomyScreen extends ConsumerWidget {
  const EconomyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final eco = state.economy;

    return Scaffold(
      appBar: AppBar(title: const Text('Economy')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current Balance
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Current Balance',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('\$${eco.cash}',
                      style: Theme.of(context).textTheme.headlineLarge),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Weekly Overview
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  title: 'Weekly Income',
                  value: '\$${eco.weeklyIncome}',
                  icon: Icons.trending_up,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricCard(
                  title: 'Weekly Costs',
                  value: '\$${eco.weeklyCosts}',
                  icon: Icons.trending_down,
                  color: Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Sub-sections
          _SectionCard(
            title: 'Lifestyle',
            subtitle: 'Housing, cars, luxury items',
            icon: Icons.home,
            onTap: () {
              // Navigate to Lifestyle screen
            },
          ),

          _SectionCard(
            title: 'Investments',
            subtitle: 'Business portfolio',
            icon: Icons.business,
            onTap: () {
              // Navigate to Investments screen
            },
          ),

          _SectionCard(
            title: 'Casino',
            subtitle: 'Try your luck',
            icon: Icons.casino,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CasinoScreen()));
            },
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            Text(title, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}