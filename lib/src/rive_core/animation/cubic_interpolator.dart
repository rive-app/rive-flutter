import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/cubic_interpolator_base.dart';
import 'package:rive/src/rive_core/animation/interpolator.dart';

export 'package:rive/src/generated/animation/cubic_interpolator_base.dart';

const int newtonIterations = 4;

// Implements https://github.com/gre/bezier-easing/blob/master/src/index.js
const double newtonMinSlope = 0.001;
const double sampleStepSize = 1.0 / (splineTableSize - 1.0);
const int splineTableSize = 11;
const int subdivisionMaxIterations = 10;

const double subdivisionPrecision = 0.0000001;

abstract class CubicInterface {
  double get x1;
  set x1(double value);

  double get x2;
  set x2(double value);

  double get y1;
  set y1(double value);

  double get y2;
  set y2(double value);
}

// Returns dx/dt given t, x1, and x2, or dy/dt given t, y1, and y2.
abstract class CubicInterpolator extends CubicInterpolatorBase
    implements CubicInterface {
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
  void onAddedDirty() {}

  @override
  double transform(double value);

  @override
  double transformValue(double from, double to, double value);

  @override
  void x1Changed(double from, double to) => updateInterpolator();

  @override
  void x2Changed(double from, double to) => updateInterpolator();

  @override
  void y1Changed(double from, double to) => updateInterpolator();

  @override
  void y2Changed(double from, double to) => updateInterpolator();
}

// Helper to convert a factor in cubic space to t value. We use this to compute
// the t value to use to evaluate the y cubic for animation values.
class InterpolatorCubicFactor {
  final Float64List _values = Float64List(splineTableSize);
  final double x1, x2;
  InterpolatorCubicFactor(this.x1, this.x2) {
    // Precompute values table
    for (int i = 0; i < splineTableSize; ++i) {
      _values[i] = calcBezier(i * sampleStepSize, x1, x2);
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

    var initialSlope = getSlope(guessForT, x1, x2);
    if (initialSlope >= newtonMinSlope) {
      for (int i = 0; i < newtonIterations; ++i) {
        double currentSlope = getSlope(guessForT, x1, x2);
        if (currentSlope == 0.0) {
          return guessForT;
        }
        double currentX = calcBezier(guessForT, x1, x2) - x;
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
        currentX = calcBezier(currentT, x1, x2) - x;
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

  static double calcBezier(double aT, double aA1, double aA2) {
    return (((1.0 - 3.0 * aA2 + 3.0 * aA1) * aT + (3.0 * aA2 - 6.0 * aA1)) *
                aT +
            (3.0 * aA1)) *
        aT;
  }

// Returns x(t) given t, x1, and x2, or y(t) given t, y1, and y2.
  static double getSlope(double aT, double aA1, double aA2) {
    return 3.0 * (1.0 - 3.0 * aA2 + 3.0 * aA1) * aT * aT +
        2.0 * (3.0 * aA2 - 6.0 * aA1) * aT +
        (3.0 * aA1);
  }
}
