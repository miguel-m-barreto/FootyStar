class MatchMessages {
  static String result(int week, String home, int hg, String away, int ag) =>
      'Match result — Week $week\n$home $hg - $ag $away';

  static String friendly(String home, String away) =>
      'Match played\n$home vs $away (friendly/unscheduled)';
}
