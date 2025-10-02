class CasinoMessages {
  static String win(int delta, int cash) =>
      'Casino win! You won \$$delta. New cash: \$$cash';

  static String loss(int loss, int cash) =>
      'Casino loss! You lost \$$loss. New cash: \$$cash';
}
