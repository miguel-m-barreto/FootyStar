import '../../../domain/models/player.dart';

enum MomentType {
  kickOff, halfTime, fullTime,
  buildUp, chance, shotOnTarget, shotOffTarget,
  save, goal, foul, yellow, red, injury,
}

class MatchMoment {
  final int minute;               // 1..90
  final String teamId;            // who the moment belongs to (can be "")
  final MomentType type;
  final String key;               // i18n key (debug-friendly)
  final Map<String, dynamic> args;// extra data (att, assist, xg, etc.)

  const MatchMoment({
    required this.minute,
    required this.teamId,
    required this.type,
    required this.key,
    this.args = const {},
  });
}

class MatchScore {
  final int home, away;
  const MatchScore(this.home, this.away);
}

class PlayerStats {
  int goals = 0, assists = 0, shots = 0, shotsOnTarget = 0, yellow = 0, red = 0;
  int spEarned = 0; // SP earnt on game
}

class MatchSim {
  final List<MatchMoment> moments;
  final MatchScore score;
  final Map<String, PlayerStats> playerStats;
  const MatchSim({required this.moments, required this.score, required this.playerStats});
}
