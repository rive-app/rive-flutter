abstract class Interpolator {
  int get id;
  double transform(double value);
  bool equalParameters(Interpolator other);
}
