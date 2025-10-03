import 'package:flutter_test/flutter_test.dart';
import 'package:footy_star/domain/player.dart';
import 'package:footy_star/domain/skill.dart';
import 'package:footy_star/data/services/training_service.dart';

void main() {
  group('TrainingService', () {
    test('trainSkill increases level with star boost and fatigue penalty', () {
      final svc = TrainingService();
      final p0 = Player(
        id: 'p1',
        name: 'Test',
        age: 21,
        form: 0.8,
        fatigue: 0.2, // penalty = 1 - 0.5*0.2 = 0.9
        reputation: 10,
        skills: {
          'fin': const Skill(id: 'fin', name: 'Finishing', level: 50, stars: 0),
          'pas': const Skill(id: 'pas', name: 'Passing', level: 50, stars: 2), // +50% XP
        },
      );

      final pFin = svc.trainSkill(p0, 'fin', baseXp: 10);
      final pPas = svc.trainSkill(p0, 'pas', baseXp: 10);

      // Expected gains (rounded):
      // fin: 10 * (1 + 0*0.25) * 0.9 = 9
      // pas: 10 * (1 + 2*0.25) * 0.9 = 13.5 -> 14
      expect(pFin.skills['fin']!.level, 59);
      expect(pPas.skills['pas']!.level, 64);

      // Fatigue should increase slightly; form nudges
      expect(pFin.fatigue, greaterThan(p0.fatigue));
      expect(pFin.form, isNotNull);
    });

    test('rest decreases fatigue and slightly improves form', () {
      final svc = TrainingService();
      final p0 = Player(
        id: 'p1',
        name: 'Test',
        age: 21,
        form: 0.5,
        fatigue: 0.8,
        reputation: 10,
        skills: {
          'fin': const Skill(id: 'fin', name: 'Finishing', level: 50, stars: 0),
        },
      );

      final p1 = svc.rest(p0);
      expect(p1.fatigue, lessThan(p0.fatigue));
      expect(p1.form, greaterThan(p0.form));
    });
  });
}
