import '../../domain/player.dart';
import '../../domain/skill.dart';

class TrainingService {
  // applies weekly training to a specific skill
  Player trainSkill(Player p, String skillId, {int baseXp = 3}) {
    final s = p.skills[skillId];
    if (s == null) return p;
    final starBoost = 1 + 0.25 * s.stars; // 0, +25%, +50%, +75%
    final fatiguePenalty = (1 - 0.5 * p.fatigue).clamp(0.5, 1.0);
    final gain = (baseXp * starBoost * fatiguePenalty).round();

    final newLevel = (s.level + gain).clamp(0, 100);
    final updated = s.copyWith(level: newLevel);
    final newSkills = Map<String, Skill>.from(p.skills)..[skillId] = updated;

    final newFatigue = (p.fatigue + 0.1).clamp(0.0, 1.0);
    final newForm = (p.form * 0.98 + 0.02).clamp(0.0, 1.0);

    return p.copyWith(skills: newSkills, fatigue: newFatigue, form: newForm);
  }

  // weekly rest
  Player rest(Player p) {
    final newFatigue = (p.fatigue - 0.2).clamp(0.0, 1.0);
    final newForm = (p.form * 0.97 + 0.03).clamp(0.0, 1.0);
    return p.copyWith(fatigue: newFatigue, form: newForm);
  }
}
