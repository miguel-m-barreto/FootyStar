import '../../domain/models/player.dart';
import '../../domain/models/skill.dart';

class SkillsService {
  // Add XP to a skill with banked progress
  Skill addXpToSkill(Skill skill, int xpAmount) {
    if (xpAmount <= 0) return skill;

    int remaining = xpAmount;
    int currentLevel = skill.level;
    int currentXp = skill.currentXp;
    int queuedLevels = skill.queuedLevels;
    int queuedXp = skill.queuedXp;

    // If skill is at max level, convert 50% to SP
    if (currentLevel + queuedLevels >= 100) {
      // Return skill unchanged, controller handles SP conversion
      return skill;
    }

    // Add to current level first
    if (queuedLevels == 0) {
      final cap = skill.xpCapForLevel(currentLevel);
      final space = cap - currentXp;

      if (remaining <= space) {
        // Fits in current level
        return skill.copyWith(currentXp: currentXp + remaining);
      } else {
        // Overflows to queued
        remaining -= space;
        queuedLevels = 1;
        queuedXp = 0;
        currentLevel = skill.level; // Don't actually level up yet
      }
    }

    // Add remaining XP to queued levels
    while (remaining > 0 && currentLevel + queuedLevels < 100) {
      final virtualLevel = currentLevel + queuedLevels;
      final cap = skill.xpCapForLevel(virtualLevel);
      final space = cap - queuedXp;

      if (remaining <= space) {
        queuedXp += remaining;
        remaining = 0;
      } else {
        remaining -= space;
        queuedLevels++;
        queuedXp = 0;
      }
    }

    return skill.copyWith(
      currentXp: queuedLevels == 0 ? currentXp + xpAmount : 0,
      queuedLevels: queuedLevels,
      queuedXp: queuedXp,
    );
  }

  // Promote a skill (pay cost, apply level)
  (Skill skill, bool success) promoteSkill(Skill skill, int availableCash) {
    if (skill.queuedLevels <= 0) {
      return (skill, false); // Nothing to promote
    }

    final cost = skill.promotionCost(skill.level);
    if (cost > availableCash) {
      return (skill, false); // Can't afford
    }

    // Apply one level
    final promoted = skill.copyWith(
      level: skill.level + 1,
      currentXp: skill.queuedLevels > 1 ? 0 : skill.queuedXp,
      queuedLevels: skill.queuedLevels - 1,
      queuedXp: skill.queuedLevels > 1 ? skill.queuedXp : 0,
    );

    return (promoted, true);
  }

  // Convert SP to XP (1 SP = 10 XP)
  int spToXp(int sp) => sp * 10;
}