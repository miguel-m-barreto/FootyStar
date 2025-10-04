import 'package:footy_star/core/l10n/l10n_singleton.dart';

class SkillMessages {
  static String trained(String player, String skill, int level) =>
      L10n.i.skillTrained(player, skill, level);

  static String squadRested() => L10n.i.squadRested;
}
