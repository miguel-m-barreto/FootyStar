import 'package:footy_star/core/l10n/l10n_singleton.dart';

class MatchMessages {
  static String result(int week, String home, int hg, String away, int ag) =>
      L10n.i.matchResult(week, home, hg, ag, away);

  static String friendly(String home, String away) =>
      L10n.i.matchPlayedFriendly(home, away);
}
