import 'package:footy_star/core/l10n/l10n_singleton.dart';

class GeneralMessages {
  static String weekEnded(int week) => L10n.i.weekEnded(week);

  static String newSeason(int season) => L10n.i.newSeason(season);

  static String genericInfo(String text) => text; // livre, não precisa i18n
}
