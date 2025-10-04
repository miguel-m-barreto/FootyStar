import 'package:flutter/material.dart';
import 'package:footy_star/core/l10n/app_localizations.dart';

class PlayersStandingsScreen extends StatelessWidget {
  const PlayersStandingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.playersStandings)),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: l10n.goals),
                Tab(text: l10n.assists),
                Tab(text: l10n.ratings),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text(l10n.topScorers)),
                  Center(child: Text(l10n.topAssists)),
                  Center(child: Text(l10n.bestRatings)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
