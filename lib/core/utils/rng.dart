import 'dart:math';

final _rng = Random();

double rand() => _rng.nextDouble();     // 0..1
int randInt(int min, int max) => min + _rng.nextInt(max - min + 1);

// logistic helper for smooth probabilities
double logistic(double x) => 1 / (1 + exp(-x));
double exp(double x) => mathExp(x);
double mathExp(double x) => (x == 0) ? 1 : (x > 0 ? _expPos(x) : 1/_expPos(-x));
double _expPos(double x) {
  // fast approximation
  double sum = 1, term = 1;
  for (int n=1; n<20; n++) { term *= x/n; sum += term; }
  return sum;
}
