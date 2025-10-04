import 'package:footy_star/core/l10n/l10n_singleton.dart';

class CasinoMessages {
  static String win(int delta, int cash) =>
      L10n.i.casinoWin(delta.toDouble(), cash.toDouble());

  static String loss(int loss, int cash) =>
      L10n.i.casinoLoss(loss.toDouble(), cash.toDouble());
}
