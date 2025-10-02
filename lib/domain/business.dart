import 'dart:math';

class Business {
  final String id;
  final String name;

  /// Current level (0 means not owned yet)
  final int level;

  /// Maximum level allowed
  final int maxLevel;

  /// Cost to buy at level 1 (or to upgrade from 0->1)
  final int baseCost;

  /// Multiplier applied per level for upgrade cost (>= 1.0)
  final double costMultiplier;

  /// Weekly income at level 1
  final int baseIncome;

  /// Increment of weekly income per level beyond level 1
  final int incomeStep;

  /// Requirements
  final int reqOvr;
  final double reqReputation; // team average reputation required

  const Business({
    required this.id,
    required this.name,
    required this.level,
    required this.maxLevel,
    required this.baseCost,
    required this.costMultiplier,
    required this.baseIncome,
    required this.incomeStep,
    required this.reqOvr,
    required this.reqReputation,
  });

  int incomeAt(int lvl) {
    if (lvl <= 0) return 0;
    final extra = max(0, lvl - 1);
    return baseIncome + extra * incomeStep;
  }

  int currentIncome() => incomeAt(level);

  int costForNextLevel() {
    if (level >= maxLevel) return 0;
    if (level <= 0) return baseCost;
    final v = baseCost * pow(costMultiplier, level);
    return v.round();
  }

  bool get canUpgrade => level < maxLevel;

  Business copyWith({
    String? id,
    String? name,
    int? level,
    int? maxLevel,
    int? baseCost,
    double? costMultiplier,
    int? baseIncome,
    int? incomeStep,
    int? reqOvr,
    double? reqReputation,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      maxLevel: maxLevel ?? this.maxLevel,
      baseCost: baseCost ?? this.baseCost,
      costMultiplier: costMultiplier ?? this.costMultiplier,
      baseIncome: baseIncome ?? this.baseIncome,
      incomeStep: incomeStep ?? this.incomeStep,
      reqOvr: reqOvr ?? this.reqOvr,
      reqReputation: reqReputation ?? this.reqReputation,
    );
  }
}
