import 'package:rive/src/generated/animation/cubic_ease_interpolator_base.dart';
import 'package:rive/src/rive_core/animation/cubic_interpolator.dart';

class Cubic extends CubicEase {
  final InterpolatorCubicFactor _x;
  final double y1, y2;
  Cubic(double x1, this.y1, double x2, this.y2)
      : _x = InterpolatorCubicFactor(x1, x2);

  @override
  double transform(double f) {
    return InterpolatorCubicFactor.calcBezier(_x.getT(f), y1, y2);
  }
}

abstract class CubicEase {
  double transform(double t);

  static CubicEase make(double x1, double y1, double x2, double y2) {
    if (x1 == y1 && x2 == y2) {
      return LinearCubicEase();
    } else {
      return Cubic(x1, y1, x2, y2);
    }
  }
}

class LinearCubicEase extends CubicEase {
  @override
  double transform(double f) {
    return f;
  }
}

class CubicEaseInterpolator extends CubicEaseInterpolatorBase {
  CubicEase _ease = CubicEase.make(0.42, 0, 0.58, 1);

  @override
  double transform(double value) => _ease.transform(value);

  @override
  double transformValue(double from, double to, double value) =>
      from + (to - from) * _ease.transform(value);

  @override
  void updateInterpolator() {
    _ease = CubicEase.make(x1, y1, x2, y2);
    super.updateInterpolator();
  }
}
