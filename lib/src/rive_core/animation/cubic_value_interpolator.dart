import 'package:rive/src/generated/animation/cubic_value_interpolator_base.dart';
import 'package:rive/src/rive_core/animation/cubic_interpolator.dart';
import 'package:rive/src/rive_core/animation/interpolator.dart';

export 'package:rive/src/generated/animation/cubic_value_interpolator_base.dart';

class _CubicValue {
  final InterpolatorCubicFactor _x;

  // at^3 + bt^2 + ct + d
  final double a;
  final double b;
  final double c;
  final double d;

  _CubicValue(double x1, double x2, double y1, double y2, double y3, double y4)
      : _x = InterpolatorCubicFactor(x1, x2),
        a = y4 + 3 * (y2 - y3) - y1,
        b = 3 * (y3 - y2 * 2 + y1),
        c = 3 * (y2 - y1),
        d = y1;

  double transform(double f) {
    var t = _x.getT(f);
    return ((a * t + b) * t + c) * t + d;
  }
}

class CubicValueInterpolator extends CubicValueInterpolatorBase {
  _CubicValue _cubic = _CubicValue(0, 1, 0.42, 0, 0.58, 1);

  @override
  bool equalParameters(Interpolator other) {
    if (other is CubicValueInterpolator) {
      return x1 == other.x1 &&
          x2 == other.x2 &&
          y1 == other.y1 &&
          y2 == other.y2;
    }
    return false;
  }

  @override
  double transform(double value) => throw UnsupportedError(
      'Transform not supported on Cubic Value Interpolator.');

  double _from = 0, _to = 0;
  @override
  double transformValue(double from, double to, double value) {
    if (_from != from || _to != to) {
      _from = from;
      _to = to;
      updateInterpolator();
    }
    return _cubic.transform(value);
  }

  @override
  void updateInterpolator() {
    _cubic = _CubicValue(x1, x2, _from, y1, y2, _to);
    super.updateInterpolator();
  }
}
