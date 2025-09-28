import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';

class EconomyScreen extends ConsumerStatefulWidget {
  const EconomyScreen({super.key});
  @override
  ConsumerState<EconomyScreen> createState() => _EconomyScreenState();
}

class _EconomyScreenState extends ConsumerState<EconomyScreen> {
  final _ctrl = TextEditingController(text: '100');

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(gameControllerProvider);
    final g = ref.read(gameControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Economy')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cash: \$${s.economy.cash}'),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Wager amount',
                hintText: 'Enter any amount (up to your cash)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                final amount = int.tryParse(_ctrl.text.trim()) ?? 0;
                g.casinoWager(amount);
              },
              child: const Text('Casino — Place Bet'),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () {
                final allIn = s.economy.cash;
                g.casinoWager(allIn);
              },
              child: const Text('Casino — All In'),
            ),
            const Spacer(),
            FilledButton(
              onPressed: ()=> g.endOfWeekEconomy(),
              child: const Text('End Week (Apply Income/Costs)'),
            ),
          ],
        ),
      ),
    );
  }
}
