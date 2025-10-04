import 'skill.dart';
import 'skills_catalog.dart';

class Player {
  final String id;
  final String name;
  final int age;
  final PlayerRole role;
  final Map<String, Skill> skills; // All 28 skills
  final double form;               // 0..1
  final double fatigue;            // 0..1
  final double reputation;         // 0..100
  final int sp;                    // Skill Points

  // Special attributes
  final double consistency;        // 0..100 (affects rating volatility)
  final double determination;      // 0..100 (affects training/selection)
  final double leadership;         // 0..100 (team bonus when captain)

  const Player({
    required this.id,
    required this.name,
    required this.age,
    required this.role,
    required this.skills,
    required this.form,
    required this.fatigue,
    required this.reputation,
    this.sp = 0,
    this.consistency = 50.0,
    this.determination = 50.0,
    this.leadership = 50.0,
  });

  // Calculate OVR based on role weights
  int get ovr {
    final weights = SkillsCatalog.roleWeights[role] ?? {};
    double weighted = 0.0;
    double totalWeight = 0.0;

    weights.forEach((skillId, weight) {
      final skill = skills[skillId];
      if (skill != null) {
        weighted += skill.level * weight;
        totalWeight += weight;
      }
    });

    if (totalWeight == 0) return 50;

    final base = weighted / totalWeight;
    final formAdjust = 0.9 + 0.2 * form;
    final fatigueAdjust = 1.0 - 0.2 * fatigue;

    return (base * formAdjust * fatigueAdjust).round().clamp(5, 100);
  }

  // Calculate confidence for match moments
  double get confidence {
    // Based on last matches ratings (placeholder)
    return form * 0.7 + (reputation / 100) * 0.3;
  }

  Player copyWith({
    String? name,
    int? age,
    PlayerRole? role,
    Map<String, Skill>? skills,
    double? form,
    double? fatigue,
    double? reputation,
    int? sp,
    double? consistency,
    double? determination,
    double? leadership,
  }) {
    return Player(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      role: role ?? this.role,
      skills: skills ?? this.skills,
      form: form ?? this.form,
      fatigue: fatigue ?? this.fatigue,
      reputation: reputation ?? this.reputation,
      sp: sp ?? this.sp,
      consistency: consistency ?? this.consistency,
      determination: determination ?? this.determination,
      leadership: leadership ?? this.leadership,
    );
  }
}