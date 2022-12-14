abstract class Interpolator {
  int get id;

  /// Convert a linear interpolation factor to an eased one. Returns a factor
  double transform(double f);

  /// Convert a linear interpolation factor to an eased one for from->to values.
  /// Returns a value instead of a factor.
  double transformValue(double from, double to, double f);

  bool equalParameters(Interpolator other);
}
