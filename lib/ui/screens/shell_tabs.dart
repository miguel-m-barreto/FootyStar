import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_screen.dart';
import 'economy_screen.dart';
import 'casino_screen.dart';
import 'match_screen.dart';
import 'squad_screen.dart';
import 'standings_screen.dart';

class ShellTabs extends ConsumerStatefulWidget {
  const ShellTabs({super.key});
  @override
  ConsumerState<ShellTabs> createState() => _ShellTabsState();
}

class _ShellTabsState extends ConsumerState<ShellTabs> {
  int _idx = 0;

  static const _pages = <Widget>[
    HomeScreen(),      // info jogador + notificações
    MatchScreen(),     // JOGOS (voltou!)
    EconomyScreen(),   // finanças
    SquadScreen(),     // plantel
    StandingsScreen(), // classificação
  ];

  static const _destinations = <NavigationDestination>[
    NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.sports_soccer), label: 'Matches'),
    NavigationDestination(icon: Icon(Icons.savings), label: 'Economy'),
    NavigationDestination(icon: Icon(Icons.group), label: 'Squad'),
    NavigationDestination(icon: Icon(Icons.leaderboard), label: 'Standings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_destinations[_idx].label),
        actions: [
          // Casino fica “stand by” mas acessível num ecrã próprio via ação
          IconButton(
            tooltip: 'Casino',
            icon: const Icon(Icons.casino),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CasinoScreen()),
              );
            },
          ),
        ],
      ),
      body: _pages[_idx],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        destinations: _destinations,
      ),
    );
  }
}
