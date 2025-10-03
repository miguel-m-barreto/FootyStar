import 'package:flutter/material.dart';

class PlayersStandingsScreen extends StatelessWidget {
  const PlayersStandingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Players Standings')),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: const [
            TabBar(
              tabs: [
                Tab(text: 'Goals'),
                Tab(text: 'Assists'),
                Tab(text: 'Ratings'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text('Top Scorers')),
                  Center(child: Text('Top Assists')),
                  Center(child: Text('Best Ratings')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}