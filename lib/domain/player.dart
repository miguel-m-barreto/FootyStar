import 'skill.dart';

class Player {
  final String id;
  final String name;
  final int age;
  final Map<String, Skill> skills; // key=skillId
  final double form;               // 0..1
  final double fatigue;            // 0..1
  final double reputation;         // 0..100
  const Player({
    required this.id,
    required this.name,
    required this.age,
    required this.skills,
    required this.form,
    required this.fatigue,
    required this.reputation,
  });

  int get ovr {
    if (skills.isEmpty) return 0;
    final avg = skills.values.map((s) => s.level).reduce((a,b)=>a+b) / skills.length;
    final formAdj = (0.9 + 0.2 * form);     // 0.9..1.1
    final fatigueAdj = (1.0 - 0.2 * fatigue); // 1.0..0.8
    return (avg * formAdj * fatigueAdj).round();
  }

  Player copyWith({
    Map<String, Skill>? skills,
    double? form,
    double? fatigue,
    double? reputation,
  }) => Player(
    id: id, name: name, age: age,
    skills: skills ?? this.skills,
    form: form ?? this.form,
    fatigue: fatigue ?? this.fatigue,
    reputation: reputation ?? this.reputation,
  );
}
