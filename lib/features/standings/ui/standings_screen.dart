import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers/providers.dart';

class StandingsScreen extends ConsumerWidget {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);
    final rows = s.table.sorted();

    return Scaffold(
      appBar: AppBar(title: const Text('Standings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: rows.isEmpty
            ? const Center(child: Text('No standings yet. Play a match to populate the table.'))
            : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('#')),
              DataColumn(label: Text('Team')),
              DataColumn(label: Text('P')),
              DataColumn(label: Text('W')),
              DataColumn(label: Text('D')),
              DataColumn(label: Text('L')),
              DataColumn(label: Text('GF')),
              DataColumn(label: Text('GA')),
              DataColumn(label: Text('GD')),
              DataColumn(label: Text('Pts')),
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
