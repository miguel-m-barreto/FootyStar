import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footy_star/core/l10n/app_localizations.dart';
import '../../../app/providers/providers.dart';

class StandingsScreen extends ConsumerWidget {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final s = ref.watch(gameControllerProvider);
    final rows = s.table.sorted();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.standings)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: rows.isEmpty
            ? Center(child: Text(l10n.noStandingsYet))
            : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text(l10n.positionShort)), // "#"
              DataColumn(label: Text(l10n.team)),
              DataColumn(label: Text(l10n.playedShort)), // "P"
              DataColumn(label: Text(l10n.winsShort)),   // "W"
              DataColumn(label: Text(l10n.drawsShort)),  // "D"
              DataColumn(label: Text(l10n.lossesShort)), // "L"
              DataColumn(label: Text(l10n.goalsForShort)), // "GF"
              DataColumn(label: Text(l10n.goalsAgainstShort)), // "GA"
              DataColumn(label: Text(l10n.goalDifferenceShort)), // "GD"
              DataColumn(label: Text(l10n.pointsShort)), // "Pts"
            ],
            rows: [
              for (int i = 0; i < rows.length; i++)
                DataRow(
                  cells: [
                    DataCell(Text('${i + 1}')),
                    DataCell(Text(rows[i].team)),
                    DataCell(Text('${rows[i].played}')),
                    DataCell(Text('${rows[i].won}')),
                    DataCell(Text('${rows[i].drawn}')),
                    DataCell(Text('${rows[i].lost}')),
                    DataCell(Text('${rows[i].gf}')),
                    DataCell(Text('${rows[i].ga}')),
                    DataCell(Text('${rows[i].gd}')),
                    DataCell(Text('${rows[i].points}')),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
