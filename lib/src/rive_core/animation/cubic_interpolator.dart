import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/cubic_interpolator_base.dart';
import 'package:rive/src/rive_core/animation/interpolator.dart';
import 'package:rive/src/rive_core/artboard.dart';

const int newtonIterations = 4;

// Implements https://github.com/gre/bezier-easing/blob/master/src/index.js
const double newtonMinSlope = 0.001;
const double sampleStepSize = 1.0 / (splineTableSize - 1.0);
const int splineTableSize = 11;
const int subdivisionMaxIterations = 10;

const double subdivisionPrecision = 0.0000001;
double _calcBezier(double aT, double aA1, double aA2) {
  return (((1.0 - 3.0 * aA2 + 3.0 * aA1) * aT + (3.0 * aA2 - 6.0 * aA1)) * aT +
          (3.0 * aA1)) *
      aT;
}

// Returns x(t) given t, x1, and x2, or y(t) given t, y1, and y2.
double _getSlope(double aT, double aA1, double aA2) {
  return 3.0 * (1.0 - 3.0 * aA2 + 3.0 * aA1) * aT * aT +
      2.0 * (3.0 * aA2 - 6.0 * aA1) * aT +
      (3.0 * aA1);
}

// Returns dx/dt given t, x1, and x2, or dy/dt given t, y1, and y2.
class CubicInterpolator extends CubicInterpolatorBase implements Interpolator {
  _CubicEase _ease = _CubicEase.make(0.42, 0, 0.58, 1);

  @override
  bool equalParameters(Interpolator other) {
    if (other is CubicInterpolator) {
      return x1 == other.x1 &&
          x2 == other.x2 &&
          y1 == other.y1 &&
          y2 == other.y2;
    }
    return false;
  }

  @override
  void onAdded() => _updateStoredCubic();

  @override
  void onAddedDirty() {}

  @override
  double transform(double value) => _ease.transform(value);

  @override
  void x1Changed(double from, double to) => _updateStoredCubic();

  @override
  void x2Changed(double from, double to) => _updateStoredCubic();

  @override
  void y1Changed(double from, double to) => _updateStoredCubic();

  @override
  void y2Changed(double from, double to) => _updateStoredCubic();
  void _updateStoredCubic() {
    _ease = _CubicEase.make(x1, y1, x2, y2);
  }

  @override
  bool import(ImportStack stack) {
    var artboardHelper = stack.latest<ArtboardImporter>(ArtboardBase.typeKey);
    if (artboardHelper == null) {
      return false;
    }
    artboardHelper.addComponent(this);

    return super.import(stack);
  }
}

class _Cubic extends _CubicEase {
  final Float64List _values = Float64List(splineTableSize);
  final double x1, y1, x2, y2;
  _Cubic(this.x1, this.y1, this.x2, this.y2) {
    // Precompute values table
    for (int i = 0; i < splineTableSize; ++i) {
      _values[i] = _calcBezier(i * sampleStepSize, x1, x2);
    }
  }

  double getT(double x) {
    double intervalStart = 0.0;
    int currentSample = 1;
    int lastSample = splineTableSize - 1;

    for (;
        currentSample != lastSample && _values[currentSample] <= x;
        ++currentSample) {
      intervalStart += sampleStepSize;
    }
    --currentSample;

    // Interpolate to provide an initial guess for t
    var dist = (x - _values[currentSample]) /
        (_values[currentSample + 1] - _values[currentSample]);
    var guessForT = intervalStart + dist * sampleStepSize;

    var initialSlope = _getSlope(guessForT, x1, x2);
    if (initialSlope >= newtonMinSlope) {
      for (int i = 0; i < newtonIterations; ++i) {
        double currentSlope = _getSlope(guessForT, x1, x2);
        if (currentSlope == 0.0) {
          return guessForT;
        }
        double currentX = _calcBezier(guessForT, x1, x2) - x;
        guessForT -= currentX / currentSlope;
      }
      return guessForT;
    } else if (initialSlope == 0.0) {
      return guessForT;
    } else {
      double aB = intervalStart + sampleStepSize;
      double currentX, currentT;
      int i = 0;
      do {
        currentT = intervalStart + (aB - intervalStart) / 2.0;
        currentX = _calcBezier(currentT, x1, x2) - x;
        if (currentX > 0.0) {
          aB = currentT;
        } else {
          intervalStart = currentT;
        }
      } while (currentX.abs() > subdivisionPrecision &&
          ++i < subdivisionMaxIterations);
      return currentT;
    }
  }

  @override
  double transform(double mix) {
    return _calcBezier(getT(mix), y1, y2);
  }
}

abstract class _CubicEase {
  double transform(double t);

  static _CubicEase make(double x1, double y1, double x2, double y2) {
    if (x1 == y1 && x2 == y2) {
      return _LinearCubicEase();
    } else {
      return _Cubic(x1, y1, x2, y2);
    }
  }
}

class _LinearCubicEase extends _CubicEase {
  @override
  double transform(double t) {
    return t;
  }
}
