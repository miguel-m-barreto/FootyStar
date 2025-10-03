import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../achievements/ui/achievements_screen.dart';
import '../../profile/ui/profile_screen.dart';
import '../../squad/ui/squad_screen.dart';
import '../../standings/ui/national_standings_screen.dart';
import '../../standings/ui/player_standings_screen.dart';
import '../../standings/ui/standings_screen.dart';
import '../../stats/ui/stats_screen.dart';
import '../../transfers/ui/transfers_screen.dart';

class GeneralHubScreen extends ConsumerWidget {
  const GeneralHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('General')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HubCard(
            title: 'Profile',
            subtitle: 'Contract, wages & agent',
            icon: Icons.person,
            onTap: () => _navigateTo(context, const ProfileScreen()),
          ),
          _HubCard(
            title: 'Squad',
            subtitle: 'Team overview',
            icon: Icons.group,
            onTap: () => _navigateTo(context, const SquadScreen()),
          ),
          _HubCard(
            title: 'Standings',
            subtitle: 'League table',
            icon: Icons.emoji_events,
            onTap: () => _navigateTo(context, const StandingsScreen()),
          ),
          _HubCard(
            title: 'Inbound Transfers',
            subtitle: 'Transfer offers & negotiations',
            icon: Icons.swap_horiz,
            onTap: () => _navigateTo(context, const TransfersScreen()),
          ),
          _HubCard(
            title: 'National Standings',
            subtitle: 'Country rankings',
            icon: Icons.flag,
            onTap: () => _navigateTo(context, const NationalStandingsScreen()),
          ),
          _HubCard(
            title: 'Players Standings',
            subtitle: 'Top scorers & assists',
            icon: Icons.sports_soccer,
            onTap: () => _navigateTo(context, const PlayersStandingsScreen()),
          ),
          _HubCard(
            title: 'Achievements',
            subtitle: 'Trophies & milestones',
            icon: Icons.military_tech,
            onTap: () => _navigateTo(context, const AchievementsScreen()),
          ),
          _HubCard(
            title: 'Stats',
            subtitle: 'Career statistics',
            icon: Icons.bar_chart,
            onTap: () => _navigateTo(context, const StatsScreen()),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class _HubCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _HubCard({
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