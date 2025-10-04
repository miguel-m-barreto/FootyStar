import 'package:flutter/material.dart';
import 'package:footy_star/core/l10n/app_localizations.dart';

class NationalStandingsScreen extends StatelessWidget {
  const NationalStandingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.nationalStandings)),
      body: Center(
        child: Text(l10n.nationalRankingsPlaceholder),
      ),
    );
  }
}
