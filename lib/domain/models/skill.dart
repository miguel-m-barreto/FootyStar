import 'package:flutter/material.dart';
import '../../core/l10n/app_localizations.dart';

class Skill {
  final String id;
  final SkillCategory category;
  final int level; // Current level (5-100)
  final int currentXp; // XP for current level
  final int queuedLevels; // Banked levels ready to promote
  final int queuedXp; // XP for next queued level

  const Skill({
    required this.id,
    required this.category,
    this.level = 5,
    this.currentXp = 0,
    this.queuedLevels = 0,
    this.queuedXp = 0,
  });

  // Get localized name
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (id) {
      case 'acceleration':
        return l10n.acceleration;
      case 'sprint_speed':
        return l10n.sprintSpeed;
      case 'agility':
        return l10n.agility;
      case 'body_strength':
        return l10n.bodyStrength;
      case 'jumping':
        return l10n.jumping;
      case 'stamina':
        return l10n.stamina;
      case 'power':
        return l10n.power;
      case 'flexibility':
        return l10n.flexibility;
      case 'recovery':
        return l10n.recovery;
      case 'first_touch':
        return l10n.firstTouch;
      case 'dribbling':
        return l10n.dribbling;
      case 'technique':
        return l10n.technique;
      case 'short_passing':
        return l10n.shortPassing;
      case 'long_passing':
        return l10n.longPassing;
      case 'vision':
        return l10n.vision;
      case 'finishing':
        return l10n.finishing;
      case 'short_shots':
        return l10n.shortShots;
      case 'long_shots':
        return l10n.longShots;
      case 'heading':
        return l10n.heading;
      case 'anticipation':
        return l10n.anticipation;
      case 'positioning':
        return l10n.positioning;
      case 'marking':
        return l10n.marking;
      case 'tackling':
        return l10n.tackling;
      case 'composure':
        return l10n.composure;
      case 'consistency':
        return l10n.consistency;
      case 'leadership':
        return l10n.leadership;
      case 'determination':
        return l10n.determination;
      case 'bravery':
        return l10n.bravery;
      default:
        return id;
    }
  }

  // Virtual level for display (level + queued)
  int get virtualLevel => (level + queuedLevels).clamp(5, 100);

  // XP needed for current level
  int xpCapForLevel(int lvl) {
    if (lvl <= 5) return 30;
    if (lvl >= 100) return 350;
    // Exponential curve from design
    final t = (lvl - 5) / 95.0;
    return (30 + (350 - 30) * t * t).round();
  }

  // Cost to promote this level
  int promotionCost(int lvl) {
    if (lvl <= 5) return 300;
    if (lvl >= 100) return 13000;
    // Exponential curve from design
    final t = (lvl - 5) / 95.0;
    return (300 + (13000 - 300) * t * t).round();
  }

  // Progress percentage for UI
  double get progressPercent {
    final cap = xpCapForLevel(level);
    return cap > 0 ? currentXp / cap : 0.0;
  }

  // Total cost to promote all queued levels
  int get totalPromotionCost {
    int total = 0;
    for (int i = 0; i < queuedLevels; i++) {
      total += promotionCost(level + i);
    }
    return total;
  }

  Skill copyWith({
    int? level,
    int? currentXp,
    int? queuedLevels,
    int? queuedXp,
  }) {
    return Skill(
      id: id,
      category: category,
      level: level ?? this.level,
      currentXp: currentXp ?? this.currentXp,
      queuedLevels: queuedLevels ?? this.queuedLevels,
      queuedXp: queuedXp ?? this.queuedXp,
    );
  }
}

extension SkillDisplay on Skill {
  /// Nível que a barra deve exibir (o próximo “virtual”, se houver fila)
  int get displayLevel => queuedLevels == 0 ? level : (level + queuedLevels);

  /// XP que a barra deve exibir (o do nível atual se sem fila, senão o do último nível virtual em progresso)
  int get displayXp => queuedLevels == 0 ? currentXp : queuedXp;

  /// Cap do nível exibido (atual ou virtual)
  int get displayXpCap => xpCapForLevel(displayLevel);

  /// Texto útil: "Lv 47 (+3 queued)"
  String get queuedBadge =>
      queuedLevels > 0 ? 'Lv $level (+$queuedLevels queued)' : 'Lv $level';
}

// lib/domain/models/skill.dart
extension SkillUi on Skill {
  /// Há níveis em fila?
  bool get isQueued => queuedLevels > 0;

  /// Progresso para a barra:
  /// - 100% quando há queued (barra cheia)
  /// - proporção normal quando não há queued
  double get progressForBar {
    final cap = xpCapForLevel(level);
    if (isQueued) return 1.0;
    if (cap <= 0) return 0.0;
    final p = currentXp / cap;
    return p.clamp(0.0, 1.0);
  }

  /// Texto do nível para mostrar ao lado da barra
  String get levelLabel =>
      isQueued ? 'Lv $level (+$queuedLevels queued)' : 'Lv $level';

  /// Texto auxiliar do XP (opcional no UI)
  String get xpHelperText {
    if (isQueued) return 'Ready to promote';
    final cap = xpCapForLevel(level);
    return '$currentXp / $cap XP';
  }
}

enum SkillCategory { physical, technical, mental }
