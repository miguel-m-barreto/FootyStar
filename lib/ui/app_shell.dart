import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/squad_screen.dart';
import 'screens/training_screen.dart';
import 'screens/economy_screen.dart';
import 'screens/match_screen.dart';
import 'screens/standings_screen.dart'; // NEW

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  final _pages = const [
    DashboardScreen(),
    SquadScreen(),
    TrainingScreen(),
    EconomyScreen(),
    MatchScreen(),
    StandingsScreen(), // NEW
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i)=>setState(()=>_index=i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.groups_2_outlined), label: 'Squad'),
          NavigationDestination(icon: Icon(Icons.fitness_center_outlined), label: 'Training'),
          NavigationDestination(icon: Icon(Icons.attach_money_outlined), label: 'Economy'),
          NavigationDestination(icon: Icon(Icons.sports_soccer_outlined), label: 'Match'),
          NavigationDestination(icon: Icon(Icons.table_chart_outlined), label: 'Standings'), // NEW
        ],
      ),
    );
  }
}
