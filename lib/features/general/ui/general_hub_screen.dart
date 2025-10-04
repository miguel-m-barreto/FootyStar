import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footy_star/core/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.general)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HubCard(
            title: l10n.profile,
            subtitle: l10n.profileSubtitle,
            icon: Icons.person,
            onTap: () => _navigateTo(context, const ProfileScreen()),
          ),
          _HubCard(
            title: l10n.squad,
            subtitle: l10n.teamOverview,
            icon: Icons.group,
            onTap: () => _navigateTo(context, const SquadScreen()),
          ),
          _HubCard(
            title: l10n.standings,
            subtitle: l10n.leagueTable,
            icon: Icons.emoji_events,
            onTap: () => _navigateTo(context, const StandingsScreen()),
          ),
          _HubCard(
            title: l10n.inboundTransfers,
            subtitle: l10n.inboundTransfersSubtitle,
            icon: Icons.swap_horiz,
            onTap: () => _navigateTo(context, const TransfersScreen()),
          ),
          _HubCard(
            title: l10n.nationalStandings,
            subtitle: l10n.nationalStandingsSubtitle,
            icon: Icons.flag,
            onTap: () => _navigateTo(context, const NationalStandingsScreen()),
          ),
          _HubCard(
            title: l10n.playersStandings,
            subtitle: l10n.playersStandingsSubtitle,
            icon: Icons.sports_soccer,
            onTap: () => _navigateTo(context, const PlayersStandingsScreen()),
          ),
          _HubCard(
            title: l10n.achievements,
            subtitle: l10n.trophiesMilestones,
            icon: Icons.military_tech,
            onTap: () => _navigateTo(context, const AchievementsScreen()),
          ),
          _HubCard(
            title: l10n.stats,
            subtitle: l10n.careerStatistics,
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
