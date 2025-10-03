import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransfersScreen extends ConsumerWidget {
  const TransfersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inbound Transfers')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _TransferOfferCard(
            club: 'Real Madrid',
            salary: 50000,
            role: 'Starter',
            duration: 3,
          ),
          _TransferOfferCard(
            club: 'Manchester City',
            salary: 45000,
            role: 'Rotation',
            duration: 2,
          ),
        ],
      ),
    );
  }
}

class _TransferOfferCard extends StatelessWidget {
  final String club;
  final int salary;
  final String role;
  final int duration;

  const _TransferOfferCard({
    required this.club,
    required this.salary,
    required this.role,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  club,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('NEW'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _OfferDetail(label: 'Salary', value: '\$$salary/week'),
                const SizedBox(width: 16),
                _OfferDetail(label: 'Role', value: role),
                const SizedBox(width: 16),
                _OfferDetail(label: 'Duration', value: '$duration years'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text('Negotiate'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OfferDetail extends StatelessWidget {
  final String label;
  final String value;

  const _OfferDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}