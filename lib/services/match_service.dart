import '../domain/team.dart';
import 'rng.dart';

class MatchResult {
  final int homeGoals;
  final int awayGoals;
  final double homeRepDelta;
  final double awayRepDelta;
  const MatchResult(this.homeGoals, this.awayGoals, this.homeRepDelta, this.awayRepDelta);
}

class MatchService {
  // Simple simulation with OVR, reputation and some RNG/momentum
  MatchResult play(Team home, Team away, {double repWeight = 0.2}) {
    final homeStrength = home.ovr.toDouble();
    final awayStrength = away.ovr.toDouble();

    final base = 1.2;
    final homeBias = 0.15; // casa
    final strengthDelta = (homeStrength - awayStrength) / 25.0; // escala
    final repDelta = repWeight * (avgReputation(home) - avgReputation(away)) / 100.0;

    final homeExpected = base + homeBias + strengthDelta + repDelta;
    final awayExpected = base - homeBias - strengthDelta - repDelta;

    final h = poissonSample(homeExpected.clamp(0.2, 4.5));
    final a = poissonSample(awayExpected.clamp(0.2, 4.5));

    // small but noticeable reputation deltas
    final homeRep = h > a ? 0.5 : (h < a ? -0.5 : 0.1);
    final awayRep = -homeRep;

    return MatchResult(h, a, homeRep, awayRep);
  }

  int poissonSample(double lambda) {
    // https://en.wikipedia.org/wiki/Poisson_distribution#Generating_Poisson-distributed_random_variables
    // using Knuth's algorithm
    final L = mathExp(-lambda);
    int k = 0;
    double p = 1.0;
    do {
      k++;
      p *= rand();
    } while (p > L);
    return k - 1;
  }

  double avgReputation(Team t) {
    if (t.squad.isEmpty) return 0;
    final sum = t.squad.map((p)=>p.reputation).reduce((a,b)=>a+b);
    return sum / t.squad.length;
  }
}
