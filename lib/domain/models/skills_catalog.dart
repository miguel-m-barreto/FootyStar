import 'skill.dart';

class SkillsCatalog {
  static const Map<String, Skill> all28Skills = {
    // Physical (9)
    'acceleration': Skill(
      id: 'acceleration',
      category: SkillCategory.physical,
    ),
    'sprint_speed': Skill(
      id: 'sprint_speed',
      category: SkillCategory.physical,
    ),
    'agility': Skill(
      id: 'agility',
      category: SkillCategory.physical,
    ),
    'body_strength': Skill(
      id: 'body_strength',
      category: SkillCategory.physical,
    ),
    'jumping': Skill(
      id: 'jumping',
      category: SkillCategory.physical,
    ),
    'stamina': Skill(
      id: 'stamina',
      category: SkillCategory.physical,
    ),
    'power': Skill(
      id: 'power',
      category: SkillCategory.physical,
    ),
    'flexibility': Skill(
      id: 'flexibility',
      category: SkillCategory.physical,
    ),
    'recovery': Skill(
      id: 'recovery',
      category: SkillCategory.physical,
    ),

    // Technical (10)
    'first_touch': Skill(
      id: 'first_touch',
      category: SkillCategory.technical,
    ),
    'dribbling': Skill(
      id: 'dribbling',
      category: SkillCategory.technical,
    ),
    'technique': Skill(
      id: 'technique',
      category: SkillCategory.technical,
    ),
    'short_passing': Skill(
      id: 'short_passing',
      category: SkillCategory.technical,
    ),
    'long_passing': Skill(
      id: 'long_passing',
      category: SkillCategory.technical,
    ),
    'vision': Skill(
      id: 'vision',
      category: SkillCategory.technical,
    ),
    'finishing': Skill(
      id: 'finishing',
      category: SkillCategory.technical,
    ),
    'short_shots': Skill(
      id: 'short_shots',
      category: SkillCategory.technical,
    ),
    'long_shots': Skill(
      id: 'long_shots',
      category: SkillCategory.technical,
    ),
    'heading': Skill(
      id: 'heading',
      category: SkillCategory.technical,
    ),

    // Mental/Defensive (9)
    'anticipation': Skill(
      id: 'anticipation',
      category: SkillCategory.mental,
    ),
    'positioning': Skill(
      id: 'positioning',
      category: SkillCategory.mental,
    ),
    'marking': Skill(
      id: 'marking',
      category: SkillCategory.mental,
    ),
    'tackling': Skill(
      id: 'tackling',
      category: SkillCategory.mental,
    ),
    'composure': Skill(
      id: 'composure',
      category: SkillCategory.mental,
    ),
    'consistency': Skill(
      id: 'consistency',
      category: SkillCategory.mental,
    ),
    'leadership': Skill(
      id: 'leadership',
      category: SkillCategory.mental,
    ),
    'determination': Skill(
      id: 'determination',
      category: SkillCategory.mental,
    ),
    'bravery': Skill(
      id: 'bravery',
      category: SkillCategory.mental,
    ),
  };

  // Role-based OVR weights (sum to 100)
  static const Map<PlayerRole, Map<String, double>> roleWeights = {
    PlayerRole.striker: {
      'finishing': 15.0,
      'short_shots': 6.0,
      'composure': 7.0,
      'positioning': 5.0,
      'dribbling': 9.0,
      'first_touch': 7.0,
      'acceleration': 7.0,
      'sprint_speed': 5.0,
      'agility': 5.0,
      'long_shots': 5.0,
      'power': 6.0,
      'heading': 6.0,
      'jumping': 3.0,
      'body_strength': 3.0,
      'short_passing': 3.0,
      'long_passing': 1.0,
      'vision': 1.0,
      'anticipation': 1.0,
      'tackling': 1.0,
      'stamina': 1.0,
    },
    PlayerRole.midfielder: {
      'short_passing': 11.0,
      'long_passing': 10.0,
      'vision': 10.0,
      'anticipation': 7.0,
      'positioning': 7.0,
      'composure': 6.0,
      'determination': 6.0,
      'dribbling': 6.0,
      'first_touch': 6.0,
      'stamina': 6.0,
      'acceleration': 4.0,
      'agility': 3.0,
      'sprint_speed': 3.0,
      'long_shots': 5.0,
      'finishing': 3.0,
      'body_strength': 2.0,
      'tackling': 2.0,
      'heading': 2.0,
      'jumping': 1.0,
      'technique': 2.0,
    },
    PlayerRole.defender: {
      'tackling': 15.0,
      'marking': 12.0,
      'positioning': 9.0,
      'anticipation': 8.0,
      'body_strength': 7.0,
      'heading': 7.0,
      'jumping': 5.0,
      'stamina': 5.0,
      'acceleration': 3.0,
      'agility': 3.0,
      'sprint_speed': 3.0,
      'determination': 4.0,
      'leadership': 3.0,
      'bravery': 4.0,
      'short_passing': 2.0,
      'first_touch': 1.0,
      'long_passing': 1.0,
      'composure': 1.0,
    },
  };
}

enum PlayerRole { striker, midfielder, defender }