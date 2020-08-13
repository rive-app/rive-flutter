import 'dart:math';
import "dart:typed_data";
import 'package:rive/src/rive_core/math/mat2d.dart';
import "vec2d.dart";

class AABB {
  Float32List _buffer;
  Float32List get values {
    return _buffer;
  }

  Vec2D get topLeft => minimum;
  Vec2D get topRight {
    return Vec2D.fromValues(_buffer[2], _buffer[1]);
  }

  Vec2D get bottomRight => maximum;
  Vec2D get bottomLeft {
    return Vec2D.fromValues(_buffer[0], _buffer[3]);
  }

  Vec2D get minimum {
    return Vec2D.fromValues(_buffer[0], _buffer[1]);
  }

  Vec2D get maximum {
    return Vec2D.fromValues(_buffer[2], _buffer[3]);
  }

  AABB() {
    _buffer = Float32List.fromList([0.0, 0.0, 0.0, 0.0]);
  }
  AABB.clone(AABB a) {
    _buffer = Float32List.fromList(a.values);
  }
  AABB.fromValues(double a, double b, double c, double d) {
    _buffer = Float32List.fromList([a, b, c, d]);
  }
  AABB.empty() {
    _buffer = Float32List.fromList([
      double.maxFinite,
      double.maxFinite,
      -double.maxFinite,
      -double.maxFinite
    ]);
  }
  Vec2D includePoint(Vec2D point, Mat2D transform) {
    var transformedPoint = transform == null
        ? point
        : Vec2D.transformMat2D(Vec2D(), point, transform);
    expandToPoint(transformedPoint);
    return transformedPoint;
  }

  void expandToPoint(Vec2D point) {
    var x = point[0];
    var y = point[1];
    if (x < _buffer[0]) {
      _buffer[0] = x;
    }
    if (x > _buffer[2]) {
      _buffer[2] = x;
    }
    if (y < _buffer[1]) {
      _buffer[1] = y;
    }
    if (y > _buffer[3]) {
      _buffer[3] = y;
    }
  }

  AABB.fromMinMax(Vec2D min, Vec2D max) {
    _buffer = Float32List.fromList([min[0], min[1], max[0], max[1]]);
  }
  static bool areEqual(AABB a, AABB b) {
    return a[0] == b[0] && a[1] == b[1] && a[2] == b[2] && a[3] == b[3];
  }

  double get width => _buffer[2] - _buffer[0];
  double get height => _buffer[3] - _buffer[1];
  double operator [](int idx) {
    return _buffer[idx];
  }

  void operator []=(int idx, double v) {
    _buffer[idx] = v;
  }

  static AABB copy(AABB out, AABB a) {
    out[0] = a[0];
    out[1] = a[1];
    out[2] = a[2];
    out[3] = a[3];
    return out;
  }

  static Vec2D center(Vec2D out, AABB a) {
    out[0] = (a[0] + a[2]) * 0.5;
    out[1] = (a[1] + a[3]) * 0.5;
    return out;
  }

  static Vec2D size(Vec2D out, AABB a) {
    out[0] = a[2] - a[0];
    out[1] = a[3] - a[1];
    return out;
  }

  static Vec2D extents(Vec2D out, AABB a) {
    out[0] = (a[2] - a[0]) * 0.5;
    out[1] = (a[3] - a[1]) * 0.5;
    return out;
  }

  static double perimeter(AABB a) {
    double wx = a[2] - a[0];
    double wy = a[3] - a[1];
    return 2.0 * (wx + wy);
  }

  static AABB combine(AABB out, AABB a, AABB b) {
    out[0] = min(a[0], b[0]);
    out[1] = min(a[1], b[1]);
    out[2] = max(a[2], b[2]);
    out[3] = max(a[3], b[3]);
    return out;
  }

  static bool contains(AABB a, AABB b) {
    return a[0] <= b[0] && a[1] <= b[1] && b[2] <= a[2] && b[3] <= a[3];
  }

  static bool isValid(AABB a) {
    double dx = a[2] - a[0];
    double dy = a[3] - a[1];
    return dx >= 0 &&
        dy >= 0 &&
        a[0] <= double.maxFinite &&
        a[1] <= double.maxFinite &&
        a[2] <= double.maxFinite &&
        a[3] <= double.maxFinite;
  }

  static bool testOverlap(AABB a, AABB b) {
    double d1x = b[0] - a[2];
    double d1y = b[1] - a[3];
    double d2x = a[0] - b[2];
    double d2y = a[1] - b[3];
    if (d1x > 0.0 || d1y > 0.0) {
      return false;
    }
    if (d2x > 0.0 || d2y > 0.0) {
      return false;
    }
    return true;
  }

  AABB translate(Vec2D vec) => AABB.fromValues(_buffer[0] + vec[0],
      _buffer[1] + vec[1], _buffer[2] + vec[0], _buffer[3] + vec[1]);
  @override
  String toString() {
    return _buffer.toString();
  }

  AABB transform(Mat2D matrix) {
    return AABB.fromPoints([
      minimum,
      Vec2D.fromValues(maximum[0], minimum[1]),
      maximum,
      Vec2D.fromValues(minimum[0], maximum[1])
    ], transform: matrix);
  }

  AABB.fromPoints(Iterable<Vec2D> points,
      {Mat2D transform, double expand = 0}) {
    double minX = double.maxFinite;
    double minY = double.maxFinite;
    double maxX = -double.maxFinite;
    double maxY = -double.maxFinite;
    for (final point in points) {
      var p = transform == null
          ? point
          : Vec2D.transformMat2D(Vec2D(), point, transform);
      double x = p[0];
      double y = p[1];
      if (x < minX) {
        minX = x;
      }
      if (y < minY) {
        minY = y;
      }
      if (x > maxX) {
        maxX = x;
      }
      if (y > maxY) {
        maxY = y;
      }
    }
    if (expand != 0) {
      double width = maxX - minX;
      double diff = expand - width;
      if (diff > 0) {
        diff /= 2;
        minX -= diff;
        maxX += diff;
      }
      double height = maxY - minY;
      diff = expand - height;
      if (diff > 0) {
        diff /= 2;
        minY -= diff;
        maxY += diff;
      }
    }
    _buffer = Float32List.fromList([minX, minY, maxX, maxY]);
  }
}
