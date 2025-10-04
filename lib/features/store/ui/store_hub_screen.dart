import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footy_star/core/l10n/app_localizations.dart';

class StoreHubScreen extends ConsumerWidget {
  const StoreHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.store)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StoreSection(
            title: l10n.realMoneyPurchases,
            subtitle: l10n.cashPacksAndPremium,
            icon: Icons.payment,
            onTap: () {
              // Navigate to IAP screen
            },
          ),
          const SizedBox(height: 8),
          _StoreSection(
            title: l10n.hourlyRewards,
            subtitle: l10n.claimFreeRewards,
            icon: Icons.timer,
            onTap: () {
              // Navigate to rewards screen
            },
          ),
        ],
      ),
    );
  }
}

class _StoreSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _StoreSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
