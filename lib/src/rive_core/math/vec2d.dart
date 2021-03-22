import 'dart:math';
import 'dart:typed_data';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/utilities/utilities.dart';

class Vec2D {
  final Float32List _buffer;
  Float32List get values {
    return _buffer;
  }

  double operator [](int index) {
    return _buffer[index];
  }

  void operator []=(int index, double value) {
    _buffer[index] = value;
  }

  Vec2D() : _buffer = Float32List.fromList([0.0, 0.0]);
  Vec2D.clone(Vec2D copy) : _buffer = Float32List.fromList(copy._buffer);
  Vec2D.fromValues(double x, double y) : _buffer = Float32List.fromList([x, y]);
  static void copy(Vec2D o, Vec2D a) {
    o[0] = a[0];
    o[1] = a[1];
  }

  static void copyFromList(Vec2D o, Float32List a) {
    o[0] = a[0];
    o[1] = a[1];
  }

  static Vec2D transformMat2D(Vec2D o, Vec2D a, Mat2D m) {
    double x = a[0];
    double y = a[1];
    o[0] = m[0] * x + m[2] * y + m[4];
    o[1] = m[1] * x + m[3] * y + m[5];
    return o;
  }

  static Vec2D transformMat2(Vec2D o, Vec2D a, Mat2D m) {
    double x = a[0];
    double y = a[1];
    o[0] = m[0] * x + m[2] * y;
    o[1] = m[1] * x + m[3] * y;
    return o;
  }

  static Vec2D subtract(Vec2D o, Vec2D a, Vec2D b) {
    o[0] = a[0] - b[0];
    o[1] = a[1] - b[1];
    return o;
  }

  static Vec2D add(Vec2D o, Vec2D a, Vec2D b) {
    o[0] = a[0] + b[0];
    o[1] = a[1] + b[1];
    return o;
  }

  static Vec2D scale(Vec2D o, Vec2D a, double scale) {
    o[0] = a[0] * scale;
    o[1] = a[1] * scale;
    return o;
  }

  static Vec2D lerp(Vec2D o, Vec2D a, Vec2D b, double f) {
    double ax = a[0];
    double ay = a[1];
    o[0] = ax + f * (b[0] - ax);
    o[1] = ay + f * (b[1] - ay);
    return o;
  }

  static double length(Vec2D a) {
    double x = a[0];
    double y = a[1];
    return sqrt(x * x + y * y);
  }

  static double squaredLength(Vec2D a) {
    double x = a[0];
    double y = a[1];
    return x * x + y * y;
  }

  static double distance(Vec2D a, Vec2D b) {
    double x = b[0] - a[0];
    double y = b[1] - a[1];
    return sqrt(x * x + y * y);
  }

  static double squaredDistance(Vec2D a, Vec2D b) {
    double x = b[0] - a[0];
    double y = b[1] - a[1];
    return x * x + y * y;
  }

  static Vec2D negate(Vec2D result, Vec2D a) {
    result[0] = -1 * a[0];
    result[1] = -1 * a[1];
    return result;
  }

  static void normalize(Vec2D result, Vec2D a) {
    double x = a[0];
    double y = a[1];
    double len = x * x + y * y;
    if (len > 0.0) {
      len = 1.0 / sqrt(len);
      result[0] = a[0] * len;
      result[1] = a[1] * len;
    }
  }

  static double dot(Vec2D a, Vec2D b) {
    return a[0] * b[0] + a[1] * b[1];
  }

  static Vec2D scaleAndAdd(Vec2D result, Vec2D a, Vec2D b, double scale) {
    result[0] = a[0] + b[0] * scale;
    result[1] = a[1] + b[1] * scale;
    return result;
  }

  static double onSegment(Vec2D segmentPoint1, Vec2D segmentPoint2, Vec2D pt) {
    double l2 = squaredDistance(segmentPoint1, segmentPoint2);
    if (l2 == 0) {
      return 0;
    }
    return ((pt[0] - segmentPoint1[0]) * (segmentPoint2[0] - segmentPoint1[0]) +
            (pt[1] - segmentPoint1[1]) *
                (segmentPoint2[1] - segmentPoint1[1])) /
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
        segmentPoint1[0] + t * (segmentPoint2[0] - segmentPoint1[0]),
        segmentPoint1[1] + t * (segmentPoint2[1] - segmentPoint1[1]));
    return Vec2D.squaredDistance(ptOnSeg, pt);
  }

  static bool approximatelyEqual(Vec2D a, Vec2D b, {double threshold = 0.001}) {
    var a0 = a[0], a1 = a[1];
    var b0 = b[0], b1 = b[1];
    return (a0 - b0).abs() <= threshold * max(1.0, max(a0.abs(), b0.abs())) &&
        (a1 - b1).abs() <= threshold * max(1.0, max(a1.abs(), b1.abs()));
  }

  @override
  String toString() {
    String v = _buffer[0].toString() + ', ';
    return v + _buffer[1].toString();
  }

  @override
  bool operator ==(Object o) =>
      o is Vec2D && _buffer[0] == o[0] && _buffer[1] == o[1];
  @override
  int get hashCode => szudzik(_buffer[0].hashCode, _buffer[1].hashCode);
}
