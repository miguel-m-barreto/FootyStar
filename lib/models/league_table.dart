class TableEntry {
  final String team;
  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int gf;
  final int ga;

  const TableEntry({
    required this.team,
    required this.played,
    required this.won,
    required this.drawn,
    required this.lost,
    required this.gf,
    required this.ga,
  });

  int get gd => gf - ga;
  int get points => won * 3 + drawn;

  TableEntry applyResult({required int goalsFor, required int goalsAgainst}) {
    final np = played + 1;
    final ngf = gf + goalsFor;
    final nga = ga + goalsAgainst;
    if (goalsFor > goalsAgainst) {
      return TableEntry(team: team, played: np, won: won + 1, drawn: drawn, lost: lost, gf: ngf, ga: nga);
    } else if (goalsFor < goalsAgainst) {
      return TableEntry(team: team, played: np, won: won, drawn: drawn, lost: lost + 1, gf: ngf, ga: nga);
    } else {
      return TableEntry(team: team, played: np, won: won, drawn: drawn + 1, lost: lost, gf: ngf, ga: nga);
    }
  }

  static TableEntry empty(String team) => TableEntry(team: team, played: 0, won: 0, drawn: 0, lost: 0, gf: 0, ga: 0);
}

class LeagueTable {
  final Map<String, TableEntry> rows; // team -> entry

  const LeagueTable(this.rows);

  LeagueTable upsertTeam(String team) {
    if (rows.containsKey(team)) return this;
    final n = Map<String, TableEntry>.from(rows);
    n[team] = TableEntry.empty(team);
    return LeagueTable(n);
  }

  LeagueTable applyMatch({
    required String home,
    required String away,
    required int homeGoals,
    required int awayGoals,
  }) {
    final n = Map<String, TableEntry>.from(rows);
    final h = (n[home] ?? TableEntry.empty(home)).applyResult(goalsFor: homeGoals, goalsAgainst: awayGoals);
    final a = (n[away] ?? TableEntry.empty(away)).applyResult(goalsFor: awayGoals, goalsAgainst: homeGoals);
    n[home] = h;
    n[away] = a;
    return LeagueTable(n);
  }

  List<TableEntry> sorted() {
    final list = rows.values.toList();
    list.sort((a, b) {
      if (b.points != a.points) return b.points.compareTo(a.points);
      if (b.gd != a.gd) return b.gd.compareTo(a.gd);
      if (b.gf != a.gf) return b.gf.compareTo(a.gf);
      return a.team.compareTo(b.team);
    });
    return list;
  }
}
