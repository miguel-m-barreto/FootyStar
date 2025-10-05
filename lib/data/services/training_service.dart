import '../../domain/models/player.dart';
import '../../domain/models/skill.dart';
import '../../domain/models/skills_catalog.dart';

class TrainingService {
  // Add XP to a skill with banked progress system
  Player trainSkill(Player p, String skillId, {int baseXp = 30}) {
    final skill = p.skills[skillId];
    if (skill == null) return p;

    // Reduz ganho para que SP seja a via principal
    final determinationBoost = 1 + 0.004 * (p.determination - 50); // ±20%
    final fatiguePenalty = (1 - 0.5 * p.fatigue).clamp(0.5, 1.0);
    final consistencyFactor = 1 + 0.002 * (p.consistency - 50); // ±10%

    // 40% do baseXp → treino é útil mas lento
    final xpGain = (baseXp * 0.4 * determinationBoost * fatiguePenalty * consistencyFactor).round();

    final updatedSkill = _addXpToSkill(skill, xpGain, p.sp);

    final newSkills = Map<String, Skill>.from(p.skills);
    newSkills[skillId] = updatedSkill;

    final newFatigue = (p.fatigue + 0.1).clamp(0.0, 1.0);
    final newForm = (p.form * 0.98 + 0.02).clamp(0.0, 1.0);

    return p.copyWith(
      skills: newSkills,
      fatigue: newFatigue,
      form: newForm,
    );
  }


  // Add XP to skill with banked progress
  Skill _addXpToSkill(Skill skill, int xpAmount, int playerSp) {
    if (xpAmount <= 0) return skill;

    // Se já atingiu o teto (nível real + bancados >= 100), ignora XP
    if (skill.level + skill.queuedLevels >= 100) {
      return skill;
    }

    var lvl = skill.level;
    var cur = skill.currentXp;
    var qLvls = skill.queuedLevels;
    var qXp = skill.queuedXp;
    var remaining = xpAmount;

    // 1) Preenche o nível atual primeiro (se ainda estamos nele)
    if (qLvls == 0) {
      final cap = skill.xpCapForLevel(lvl);
      final space = cap - cur;

      if (remaining < space) {
        return skill.copyWith(currentXp: cur + remaining);
      }

      // enche e transborda para fila
      remaining -= space;
      cur = 0;
      qLvls = 1;
      qXp = 0;
    }

    // 2) Enche níveis bancados consecutivos
    while (remaining > 0 && (lvl + qLvls) < 100) {
      final virtualLevel = lvl + qLvls;         // próximo nível “futuro”
      final cap = skill.xpCapForLevel(virtualLevel);
      final space = cap - qXp;

      if (remaining < space) {
        qXp += remaining;
        remaining = 0;
      } else {
        // enche este nível futuro e cria mais um slot
        remaining -= space;
        qLvls += 1;
        qXp = 0;
        // se acabámos de encher o 100, sai
        if (lvl + qLvls >= 100) break;
      }
    }

    return skill.copyWith(
      currentXp: qLvls == 0 ? (skill.currentXp + xpAmount) : 0,
      queuedLevels: qLvls,
      queuedXp: qXp,
    );
  }
  // Weekly passive training (coach-driven)
  Player passiveWeeklyTraining(Player p) {
    final weakSkills = _identifyWeakSkills(p);
    final roleSkills = _getRolePrioritySkills(p);

    var updatedPlayer = p;
    int skillsTrained = 0;

    // Muito pouco XP por semana para endurecer progressão
    for (final skillId in weakSkills) {
      if (skillsTrained >= 2) break;
      updatedPlayer = trainSkill(updatedPlayer, skillId, baseXp: 10); // 10 * 0.4 = 4 XP aprox
      skillsTrained++;
    }

    for (final skillId in roleSkills) {
      if (skillsTrained >= 4) break;
      if (!weakSkills.contains(skillId)) {
        updatedPlayer = trainSkill(updatedPlayer, skillId, baseXp: 8); // ~3 XP
        skillsTrained++;
      }
    }

    // SP semanal mínimo
    final spGain = 1;
    return updatedPlayer.copyWith(sp: updatedPlayer.sp + spGain);
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
    final recoverySkill = p.skills['recovery'];
    final flexibilitySkill = p.skills['flexibility'];

    final recoveryBonus = recoverySkill != null ? 0.002 * recoverySkill.level : 0;
    final flexibilityBonus = flexibilitySkill != null ? 0.001 * flexibilitySkill.level : 0;

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

    const xpPerSp = 10;

    // Quanto falta para completar o nível atual
    final xpCap = skill.xpCapForLevel(skill.level);
    final missingXp = (xpCap - skill.currentXp).clamp(0, xpCap);

    final maxXpFromSp = spAmount * xpPerSp;
    final xpToAdd = maxXpFromSp.clamp(0, missingXp);
    final spUsed = (xpToAdd / xpPerSp).ceil();

    if (xpToAdd <= 0) return p;

    final updatedSkill = _addXpToSkill(skill, xpToAdd, p.sp - spUsed);

    final newSkills = Map<String, Skill>.from(p.skills);
    newSkills[skillId] = updatedSkill;

    return p.copyWith(
      skills: newSkills,
      sp: p.sp - spUsed,
    );
  }

  Player applyMinimalMatchXp(Player p, {int perSkill = 2}) {
    if (perSkill <= 0) return p;
    final newSkills = <String, Skill>{};
    p.skills.forEach((id, s) {
      newSkills[id] = _addXpToSkill(s, perSkill, p.sp);
    });
    return p.copyWith(skills: newSkills);
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