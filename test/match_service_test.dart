import 'package:flutter_test/flutter_test.dart';
import 'package:footy_star/domain/player.dart';
import 'package:footy_star/domain/skill.dart';
import 'package:footy_star/domain/team.dart';
import 'package:footy_star/services/match_service.dart';

Player _mkPlayer(int id, int base) => Player(
  id: 'p$id',
  name: 'P$id',
  age: 22,
  form: 0.8,
  fatigue: 0.2,
  reputation: 20,
  skills: {
    'fin': Skill(id:'fin', name:'Finishing', level: base, stars: 0),
    'pas': Skill(id:'pas', name:'Passing', level: base, stars: 0),
    'spd': Skill(id:'spd', name:'Speed', level: base, stars: 0),
  },
);

void main() {
  group('MatchService', () {
    test('goals are non-negative and not absurd', () {
      final svc = MatchService();
      final strong = Team(id: 'A', name: 'A', squad: List.generate(11, (i)=>_mkPlayer(i, 70)), morale: 0.8);
      final weak   = Team(id: 'B', name: 'B', squad: List.generate(11, (i)=>_mkPlayer(i, 50)), morale: 0.7);

      final res = svc.play(strong, weak);
      expect(res.homeGoals, inInclusiveRange(0, 10));
      expect(res.awayGoals, inInclusiveRange(0, 10));
      expect((res.homeRepDelta + res.awayRepDelta).abs() < 1e-6, isTrue);
    });

    test('stronger team averages more goals over many simulations', () {
      final svc = MatchService();
      final strong = Team(id: 'A', name: 'A', squad: List.generate(11, (i)=>_mkPlayer(i, 75)), morale: 0.9);
      final weak   = Team(id: 'B', name: 'B', squad: List.generate(11, (i)=>_mkPlayer(i, 55)), morale: 0.6);

      double homeSum = 0, awaySum = 0;
      const N = 200;
      for (var i = 0; i < N; i++) {
        final r = svc.play(strong, weak);
        homeSum += r.homeGoals;
        awaySum += r.awayGoals;
      }
      expect(homeSum, greaterThan(awaySum));
    });
  });
}
