import '../../domain/models/player.dart';
import '../../domain/models/skill.dart';
import '../../domain/models/skills_catalog.dart';

class TrainingService {
  // Add XP to a skill with banked progress system
  Player trainSkill(Player p, String skillId, {int baseXp = 30}) {
    final skill = p.skills[skillId];
    if (skill == null) return p;

    // Calculate XP gain with modifiers
    final determinationBoost = 1 + 0.004 * (p.determination - 50); // ±20% at extremes
    final fatiguePenalty = (1 - 0.5 * p.fatigue).clamp(0.5, 1.0);
    final consistencyFactor = 1 + 0.002 * (p.consistency - 50); // ±10% at extremes

    final xpGain = (baseXp * determinationBoost * fatiguePenalty * consistencyFactor).round();

    // Add XP with banking system
    final updatedSkill = _addXpToSkill(skill, xpGain, p.sp);

    // Convert excess XP to SP if skill is maxed
    int spGained = 0;
    if (skill.level + skill.queuedLevels >= 100 && xpGain > 0) {
      spGained = (xpGain * 0.5).round(); // Convert 50% to SP
    }

    // Update player
    final newSkills = Map<String, Skill>.from(p.skills);
    newSkills[skillId] = updatedSkill;

    final newFatigue = (p.fatigue + 0.1).clamp(0.0, 1.0);
    final newForm = (p.form * 0.98 + 0.02).clamp(0.0, 1.0);

    return p.copyWith(
      skills: newSkills,
      fatigue: newFatigue,
      form: newForm,
      sp: p.sp + spGained,
    );
  }

  // Add XP to skill with banked progress
  Skill _addXpToSkill(Skill skill, int xpAmount, int playerSp) {
    if (xpAmount <= 0) return skill;

    // If skill is at max level, don't add XP (convert to SP in caller)
    if (skill.level + skill.queuedLevels >= 100) {
      return skill;
    }

    int remaining = xpAmount;
    int currentXp = skill.currentXp;
    int queuedLevels = skill.queuedLevels;
    int queuedXp = skill.queuedXp;

    // Add to current level first if no queued levels
    if (queuedLevels == 0) {
      final cap = skill.xpCapForLevel(skill.level);
      final space = cap - currentXp;

      if (remaining <= space) {
        // Fits in current level
        return skill.copyWith(currentXp: currentXp + remaining);
      } else {
        // Overflows to queued
        remaining -= space;
        queuedLevels = 1;
        currentXp = 0;
      }
    }

    // Add remaining XP to queued levels
    while (remaining > 0 && skill.level + queuedLevels < 100) {
      final virtualLevel = skill.level + queuedLevels;
      final cap = skill.xpCapForLevel(virtualLevel);
      final currentQueuedXp = queuedLevels == 1 && currentXp == 0 ? 0 : queuedXp;
      final space = cap - currentQueuedXp;

      if (remaining <= space) {
        queuedXp = currentQueuedXp + remaining;
        remaining = 0;
      } else {
        remaining -= space;
        queuedLevels++;
        queuedXp = 0;
      }
    }

    return skill.copyWith(
      currentXp: queuedLevels == 0 ? currentXp : 0,
      queuedLevels: queuedLevels,
      queuedXp: queuedXp,
    );
  }

  // Weekly passive training (coach-driven)
  Player passiveWeeklyTraining(Player p) {
    // Coach decides which skills to train based on role and weaknesses
    final weakSkills = _identifyWeakSkills(p);
    final roleSkills = _getRolePrioritySkills(p);

    // Apply small XP to 3-5 skills
    var updatedPlayer = p;
    int skillsTrained = 0;

    // Train weak skills first
    for (final skillId in weakSkills) {
      if (skillsTrained >= 2) break;
      updatedPlayer = trainSkill(updatedPlayer, skillId, baseXp: 15);
      skillsTrained++;
    }

    // Then role-important skills
    for (final skillId in roleSkills) {
      if (skillsTrained >= 5) break;
      if (!weakSkills.contains(skillId)) {
        updatedPlayer = trainSkill(updatedPlayer, skillId, baseXp: 10);
        skillsTrained++;
      }
    }

    return updatedPlayer;
  }

  // Identify weakest skills for the player's role
  List<String> _identifyWeakSkills(Player p) {
    final roleWeights = SkillsCatalog.roleWeights[p.role] ?? {};
    final weakSkills = <String>[];

    // Find skills that are below average for their importance
    roleWeights.forEach((skillId, weight) {
      final skill = p.skills[skillId];
      if (skill != null && skill.level < 50 && weight > 5.0) {
        weakSkills.add(skillId);
      }
    });

    // Sort by weakness (lowest level first)
    weakSkills.sort((a, b) {
      final skillA = p.skills[a]!;
      final skillB = p.skills[b]!;
      return skillA.level.compareTo(skillB.level);
    });

    return weakSkills.take(3).toList();
  }

  // Get priority skills for player's role
  List<String> _getRolePrioritySkills(Player p) {
    final roleWeights = SkillsCatalog.roleWeights[p.role] ?? {};
    final prioritySkills = <MapEntry<String, double>>[];

    roleWeights.forEach((skillId, weight) {
      if (weight > 8.0) { // High importance skills
        prioritySkills.add(MapEntry(skillId, weight));
      }
    });

    // Sort by importance
    prioritySkills.sort((a, b) => b.value.compareTo(a.value));

    return prioritySkills.map((e) => e.key).take(5).toList();
  }

  // Weekly recovery session
  Player rest(Player p) {
    final recoveryBonus = 0.002 * p.skills['recovery']!.level ?? 50; // Recovery skill helps
    final flexibilityBonus = 0.001 * p.skills['flexibility']!.level ?? 50; // Flexibility helps

    final fatigueReduction = 0.2 + recoveryBonus + flexibilityBonus;
    final newFatigue = (p.fatigue - fatigueReduction).clamp(0.0, 1.0);
    final newForm = (p.form * 0.97 + 0.03).clamp(0.0, 1.0);

    return p.copyWith(fatigue: newFatigue, form: newForm);
  }

  // Convert SP to XP for a specific skill
  Player useSpOnSkill(Player p, String skillId, int spAmount) {
    if (spAmount <= 0 || spAmount > p.sp) return p;

    final skill = p.skills[skillId];
    if (skill == null) return p;

    // 1 SP = 10 XP
    final xpToAdd = spAmount * 10;
    final updatedSkill = _addXpToSkill(skill, xpToAdd, p.sp - spAmount);

    final newSkills = Map<String, Skill>.from(p.skills);
    newSkills[skillId] = updatedSkill;

    return p.copyWith(
      skills: newSkills,
      sp: p.sp - spAmount,
    );
  }

  // Promote a single skill (pay cost and apply level)
  (Player, bool, int) promoteSkill(Player p, String skillId, int availableCash) {
    final skill = p.skills[skillId];
    if (skill == null || skill.queuedLevels <= 0) {
      return (p, false, 0);
    }

    final cost = skill.promotionCost(skill.level);
    if (cost > availableCash) {
      return (p, false, cost); // Can't afford
    }

    // Apply one level
    final promotedSkill = skill.copyWith(
      level: skill.level + 1,
      currentXp: skill.queuedLevels > 1 ? 0 : skill.queuedXp,
      queuedLevels: skill.queuedLevels - 1,
      queuedXp: skill.queuedLevels > 1 ? skill.queuedXp : 0,
    );

    final newSkills = Map<String, Skill>.from(p.skills);
    newSkills[skillId] = promotedSkill;

    return (p.copyWith(skills: newSkills), true, cost);
  }

  // Promote all queued levels for all skills
  (Player, int, List<String>) promoteAllSkills(Player p, int availableCash) {
    var updatedPlayer = p;
    int totalCost = 0;
    final promotedSkills = <String>[];
    var remainingCash = availableCash;

    // Try to promote all skills with queued levels
    for (final entry in p.skills.entries) {
      final skillId = entry.key;
      final skill = entry.value;

      while (skill.queuedLevels > 0 && remainingCash > 0) {
        final (newPlayer, success, cost) = promoteSkill(updatedPlayer, skillId, remainingCash);

        if (success) {
          updatedPlayer = newPlayer;
          totalCost += cost;
          remainingCash -= cost;
          if (!promotedSkills.contains(skillId)) {
            promotedSkills.add(skillId);
          }
        } else {
          break; // Can't afford this skill anymore
        }
      }
    }

    return (updatedPlayer, totalCost, promotedSkills);
  }
}