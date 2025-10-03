import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/icons.dart';
import '../features/home/ui/home_screen.dart';
import '../features/skills/ui/skills_screen.dart';
import '../features/finance/ui/finance_hub_screen.dart';
import '../features/general/ui/general_hub_screen.dart';
import '../features/finance/ui/economy_screen.dart';
import '../features/store/ui/store_hub_screen.dart';
import '../features/settings/ui/settings_screen.dart';
import '../core/l10n/app_localizations.dart';

class ShellTabs extends ConsumerStatefulWidget {
  const ShellTabs({super.key});
  @override
  ConsumerState<ShellTabs> createState() => _ShellTabsState();
}

class _ShellTabsState extends ConsumerState<ShellTabs> {
  int _idx = 0;

  static const _pages = <Widget>[
    HomeScreen(),
    SkillsScreen(),
    FinanceHubScreen(),
    GeneralHubScreen(),
    EconomyScreen(),
    StoreHubScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final destinations = <NavigationDestination>[
      NavigationDestination(icon: const Icon(AppIcons.home), label: l10n.home),
      NavigationDestination(icon: const Icon(AppIcons.skills), label: l10n.skills),
      NavigationDestination(icon: const Icon(AppIcons.finance), label: l10n.finance),
      NavigationDestination(icon: const Icon(AppIcons.general), label: l10n.general),
      NavigationDestination(icon: const Icon(AppIcons.economy), label: l10n.economy),
      NavigationDestination(icon: const Icon(AppIcons.store), label: l10n.store),
      NavigationDestination(icon: const Icon(AppIcons.settings), label: l10n.settings),
    ];

    return Scaffold(
      body: _pages[_idx],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        destinations: destinations,
      ),
    );
  }
}
