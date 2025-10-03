import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:footy_star/app/providers/providers.dart';
import 'package:footy_star/core/l10n/app_localizations.dart';

class CasinoScreen extends ConsumerStatefulWidget {
  const CasinoScreen({super.key});
  @override
  ConsumerState<CasinoScreen> createState() => _CasinoScreenState();
}

class _CasinoScreenState extends ConsumerState<CasinoScreen> {
  final _ctrl = TextEditingController(text: '100');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(gameControllerProvider);
    final game = ref.read(gameControllerProvider.notifier);
    final canBet = state.economy.cash > 0;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.casino)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.cash}: \$${state.economy.cash}'),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.wagerAmount,
                hintText: l10n.enterAnyAmount,
                border: const OutlineInputBorder(),
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
                    ? l10n.casinoWin(res.delta.abs().toDouble(), state.economy.cash.toDouble())
                    : l10n.casinoLoss(res.delta.abs().toDouble(), state.economy.cash.toDouble());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(txt)),
                );
              },
              child: Text(l10n.casinoPlaceBet),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: !canBet
                  ? null
                  : () {
                final res = game.casinoWagerWithResult(state.economy.cash);
                final txt = res.win
                    ? l10n.casinoWin(res.delta.abs().toDouble(), state.economy.cash.toDouble())
                    : l10n.casinoLoss(res.delta.abs().toDouble(), state.economy.cash.toDouble());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(txt)),
                );
              },
              child: Text(l10n.casinoAllIn),
            ),
          ],
        ),
      ),
    );
  }
}
