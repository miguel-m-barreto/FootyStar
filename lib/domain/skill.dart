class Skill {
  final String id;            // ex: "finishing"
  final String name;          // "Finishing"
  final int level;            // 0..100
  final int stars;            // 0..3 (boost de XP semanal)
  const Skill({
    required this.id,
    required this.name,
    required this.level,
    required this.stars,
  });

  Skill copyWith({int? level, int? stars}) =>
      Skill(id: id, name: name, level: level ?? this.level, stars: stars ?? this.stars);
}
