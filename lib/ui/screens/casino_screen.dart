import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footy_star/providers/providers.dart';

class CasinoScreen extends ConsumerStatefulWidget {
  const CasinoScreen({super.key});
  @override
  ConsumerState<CasinoScreen> createState() => _CasinoScreenState();
}

class _CasinoScreenState extends ConsumerState<CasinoScreen> {
  final _ctrl = TextEditingController(text: '100');

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final game = ref.read(gameControllerProvider.notifier);
    final canBet = state.economy.cash > 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Casino')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cash: \$${state.economy.cash}'),
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
              onPressed: !canBet
                  ? null
                  : () {
                final amount = int.tryParse(_ctrl.text.trim()) ?? 0;
                final res = game.casinoWagerWithResult(amount);
                final txt = res.win
                    ? 'You won \$${res.delta.abs()}'
                    : 'You lost \$${res.delta.abs()}';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(txt)),
                );
              },
              child: const Text('Casino — Place Bet'),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: !canBet
                  ? null
                  : () {
                final res = game.casinoWagerWithResult(state.economy.cash);
                final txt = res.win
                    ? 'All-in WIN! +\$${res.delta.abs()}'
                    : 'All-in lost -\$${res.delta.abs()}';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(txt)),
                );
              },
              child: const Text('Casino — All In'),
            ),
          ],
        ),
      ),
    );
  }
}
