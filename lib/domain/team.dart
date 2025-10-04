import 'models/player.dart';

class Team {
  final String id;
  final String name;
  final List<Player> squad;
  final double morale; // 0..1
  const Team({required this.id, required this.name, required this.squad, required this.morale});

  int get ovr {
    if (squad.isEmpty) return 0;
    final top11 = (squad..sort((a,b)=>b.ovr.compareTo(a.ovr))).take(11).toList();
    final avg = top11.map((p)=>p.ovr).reduce((a,b)=>a+b) / top11.length;
    final moraleAdj = 0.9 + 0.2 * morale; // 0.9..1.1
    return (avg * moraleAdj).round();
  }

  Team copyWith({List<Player>? squad, double? morale}) =>
      Team(id: id, name: name, squad: squad ?? this.squad, morale: morale ?? this.morale);
}
