import 'dart:math' as math;
import 'dart:typed_data';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/utilities/utilities.dart';

class Vec2D {
  double x, y;

  Vec2D()
      : x = 0,
        y = 0;

  Vec2D.clone(Vec2D copy)
      : x = copy.x,
        y = copy.y;

  Vec2D.fromValues(double ox, double oy)
      : x = ox,
        y = oy;

  double at(int index) {
    if (index == 0) {
      return x;
    }
    if (index == 1) {
      return y;
    }
    throw RangeError('index out of range');
  }

  void setAt(int index, double value) {
    if (index == 0) {
      x = value;
    } else if (index == 1) {
      y = value;
    } else {
      throw RangeError('index out of range');
    }
  }

  double length() => math.sqrt(x * x + y * y);

  double squaredLength() => x * x + y * y;

  double atan2() => math.atan2(y, x);

  Vec2D operator +(Vec2D v) {
    return Vec2D.fromValues(x + v.x, y + v.y);
  }

  Vec2D operator -(Vec2D v) {
    return Vec2D.fromValues(x - v.x, y - v.y);
  }

  // ignore: avoid_returning_this
  Vec2D apply(Mat2D m) {
    final newX = x * m[0] + y * m[2] + m[4];
    final newY = x * m[1] + y * m[3] + m[5];
    x = newX;
    y = newY;
    return this;
  }

  static void copy(Vec2D o, Vec2D a) {
    o.x = a.x;
    o.y = a.y;
  }

  static void copyFromList(Vec2D o, Float32List a) {
    o.x = a[0];
    o.y = a[1];
  }

  static Vec2D transformMat2D(Vec2D o, Vec2D a, Mat2D m) {
    final x = a.x;
    final y = a.y;
    o.x = m[0] * x + m[2] * y + m[4];
    o.y = m[1] * x + m[3] * y + m[5];
    return o;
  }

  static Vec2D transformMat2(Vec2D o, Vec2D a, Mat2D m) {
    final x = a.x;
    final y = a.y;
    o.x = m[0] * x + m[2] * y;
    o.y = m[1] * x + m[3] * y;
    return o;
  }

  static Vec2D scale(Vec2D o, Vec2D a, double scale) {
    o.x = a.x * scale;
    o.y = a.y * scale;
    return o;
  }

  static Vec2D lerp(Vec2D o, Vec2D a, Vec2D b, double f) {
    double ax = a.x;
    double ay = a.y;
    o.x = ax + f * (b.x - ax);
    o.y = ay + f * (b.y - ay);
    return o;
  }

  static double distance(Vec2D a, Vec2D b) {
    double x = b.x - a.x;
    double y = b.y - a.y;
    return math.sqrt(x * x + y * y);
  }

  static double squaredDistance(Vec2D a, Vec2D b) {
    double x = b.x - a.x;
    double y = b.y - a.y;
    return x * x + y * y;
  }

  static Vec2D negate(Vec2D result, Vec2D a) {
    result.x = -1 * a.x;
    result.y = -1 * a.y;

    return result;
  }

  static void normalize(Vec2D result, Vec2D a) {
    double x = a.x;
    double y = a.y;
    double len = x * x + y * y;
    if (len > 0.0) {
      len = 1.0 / math.sqrt(len);
      result.x = a.x * len;
      result.y = a.y * len;
    }
  }

  static double dot(Vec2D a, Vec2D b) {
    return a.x * b.x + a.y * b.y;
  }

  static Vec2D scaleAndAdd(Vec2D result, Vec2D a, Vec2D b, double scale) {
    result.x = a.x + b.x * scale;
    result.y = a.y + b.y * scale;
    return result;
  }

  static double onSegment(Vec2D segmentPoint1, Vec2D segmentPoint2, Vec2D pt) {
    double l2 = squaredDistance(segmentPoint1, segmentPoint2);
    if (l2 == 0) {
      return 0;
    }
    return ((pt.x - segmentPoint1.x) * (segmentPoint2.x - segmentPoint1.x) +
            (pt.y - segmentPoint1.y) * (segmentPoint2.y - segmentPoint1.y)) /
        l2;
  }

  static double segmentSquaredDistance(
      Vec2D segmentPoint1, Vec2D segmentPoint2, Vec2D pt) {
    double t = onSegment(segmentPoint1, segmentPoint2, pt);
    if (t <= 0) {
      return Vec2D.squaredDistance(segmentPoint1, pt);
    }
    if (t >= 1) {
      return Vec2D.squaredDistance(segmentPoint2, pt);
    }

    Vec2D ptOnSeg = Vec2D.fromValues(
      segmentPoint1.x + t * (segmentPoint2.x - segmentPoint1.x),
      segmentPoint1.y + t * (segmentPoint2.y - segmentPoint1.y),
    );

    return Vec2D.squaredDistance(ptOnSeg, pt);
  }

  static bool approximatelyEqual(Vec2D a, Vec2D b, {double threshold = 0.001}) {
    var a0 = a.x, a1 = a.y;
    var b0 = b.x, b1 = b.y;
    return (a0 - b0).abs() <=
            threshold * math.max(1.0, math.max(a0.abs(), b0.abs())) &&
        (a1 - b1).abs() <=
            threshold * math.max(1.0, math.max(a1.abs(), b1.abs()));
  }

  @override
  String toString() {
    return '$x, $y';
  }

  @override
  bool operator ==(Object o) => o is Vec2D && x == o.x && y == o.y;

  @override
  int get hashCode => szudzik(x.hashCode, y.hashCode);
}
