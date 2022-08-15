abstract class Interpolator {
  int get id;

  /// Convert a linear interpolation factor to an eased one.
  double transform(double value);

  bool equalParameters(Interpolator other);
}
