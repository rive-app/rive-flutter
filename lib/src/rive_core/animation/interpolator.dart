abstract class Interpolator {
  const Interpolator();
  int get id;

  /// Convert a linear interpolation factor to an eased one. Returns a factor
  double transform(double f);

  /// Convert a linear interpolation factor to an eased one for from->to values.
  /// Returns a value instead of a factor.
  double transformValue(double from, double to, double f);

  bool equalParameters(Interpolator other);

  bool get late;
}

abstract class Interpolators {

  static const initial = LateInterpolator._(-1);
  static LateInterpolator late(int id) => LateInterpolator._(id);
}

class LateInterpolator extends Interpolator {
  @override
  final int id;

  @override
  bool get late => id != 0;

  const LateInterpolator._(this.id);
  @override
  bool equalParameters(Interpolator other) => throw UnimplementedError();

  @override
  double transform(double f) => throw UnimplementedError();

  @override
  double transformValue(double from, double to, double f) => throw UnimplementedError();
}
