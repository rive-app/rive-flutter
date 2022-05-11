import 'dart:math';
import 'dart:typed_data';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';

class IAABB {
  int left, top, right, bottom;

  IAABB(int l, int t, int r, int b)
      : left = l,
        top = t,
        right = r,
        bottom = b;

  IAABB.zero()
      : left = 0,
        top = 0,
        right = 0,
        bottom = 0;

  int get width => right - left;
  int get height => bottom - top;
  bool get empty => left >= right || top >= bottom;

  IAABB inset(int dx, int dy) =>
      IAABB(left + dx, top + dy, right - dx, bottom - dy);

  IAABB offset(int dx, int dy) =>
      IAABB(left + dx, top + dy, right + dx, bottom + dy);
}

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

  double get minX => _buffer[0];
  double get maxX => _buffer[2];
  double get minY => _buffer[1];
  double get maxY => _buffer[3];

  double get left => _buffer[0];
  double get top => _buffer[1];
  double get right => _buffer[2];
  double get bottom => _buffer[3];

  double get centerX => (_buffer[0] + _buffer[2]) * 0.5;
  double get centerY => (_buffer[1] + _buffer[3]) * 0.5;

  AABB() : _buffer = Float32List.fromList([0.0, 0.0, 0.0, 0.0]);

  AABB.clone(AABB a) : _buffer = Float32List.fromList(a.values);

  AABB.fromValues(double a, double b, double c, double d)
      : _buffer = Float32List.fromList([a, b, c, d]);

  AABB.empty()
      : _buffer = Float32List.fromList([
          double.maxFinite,
          double.maxFinite,
          -double.maxFinite,
          -double.maxFinite
        ]);

  factory AABB.expand(AABB from, double amount) {
    var aabb = AABB.clone(from);
    if (aabb.width < amount) {
      aabb[0] -= amount / 2;
      aabb[2] += amount / 2;
    }
    if (aabb.height < amount) {
      aabb[1] -= amount / 2;
      aabb[3] += amount / 2;
    }
    return aabb;
  }

  factory AABB.pad(AABB from, double amount) {
    var aabb = AABB.clone(from);
    aabb[0] -= amount;
    aabb[2] += amount;
    aabb[1] -= amount;
    aabb[3] += amount;
    return aabb;
  }

  bool get isEmpty => !AABB.isValid(this);

  Vec2D includePoint(Vec2D point, Mat2D? transform) {
    var transformedPoint = transform == null ? point : transform * point;
    expandToPoint(transformedPoint);
    return transformedPoint;
  }

  AABB inset(double dx, double dy) {
    return AABB.fromValues(
        _buffer[0] + dx, _buffer[1] + dy, _buffer[2] - dx, _buffer[3] - dy);
  }

  AABB offset(double dx, double dy) {
    return AABB.fromValues(
        _buffer[0] + dx, _buffer[1] + dy, _buffer[2] + dx, _buffer[3] + dy);
  }

  void expandToPoint(Vec2D point) {
    var x = point.x;
    var y = point.y;
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

  AABB.fromMinMax(Vec2D min, Vec2D max)
      : _buffer = Float32List.fromList([min.x, min.y, max.x, max.y]);

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

  Vec2D center() {
    return Vec2D.fromValues(
        (this[0] + this[2]) * 0.5, (this[1] + this[3]) * 0.5);
  }

  static AABB copy(AABB out, AABB a) {
    out[0] = a[0];
    out[1] = a[1];
    out[2] = a[2];
    out[3] = a[3];
    return out;
  }

  static Vec2D size(Vec2D out, AABB a) {
    out.x = a[2] - a[0];
    out.y = a[3] - a[1];
    return out;
  }

  static Vec2D extents(Vec2D out, AABB a) {
    out.x = (a[2] - a[0]) * 0.5;
    out.y = (a[3] - a[1]) * 0.5;
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

  bool containsBounds(AABB b) {
    return _buffer[0] <= b[0] &&
        _buffer[1] <= b[1] &&
        b[2] <= _buffer[2] &&
        b[3] <= _buffer[3];
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

  bool contains(Vec2D point) {
    return point.x >= _buffer[0] &&
        point.x <= _buffer[2] &&
        point.y >= _buffer[1] &&
        point.y <= _buffer[3];
  }

  AABB translate(Vec2D vec) => AABB.fromValues(_buffer[0] + vec.x,
      _buffer[1] + vec.y, _buffer[2] + vec.x, _buffer[3] + vec.y);

  IAABB round() =>
      IAABB(left.round(), top.round(), right.round(), bottom.round());

  @override
  String toString() {
    return _buffer.toString();
  }

  AABB transform(Mat2D matrix) {
    return AABB.fromPoints([
      minimum,
      Vec2D.fromValues(maximum.x, minimum.y),
      maximum,
      Vec2D.fromValues(minimum.x, maximum.y)
    ], transform: matrix);
  }

  /// Compute an AABB from a set of points with an optional [transform] to apply
  /// before computing.
  factory AABB.fromPoints(
    Iterable<Vec2D> points, {
    Mat2D? transform,
    double expand = 0,
  }) {
    double minX = double.maxFinite;
    double minY = double.maxFinite;
    double maxX = -double.maxFinite;
    double maxY = -double.maxFinite;

    for (final point in points) {
      var p = transform == null ? point : transform * point;

      final x = p.x;
      final y = p.y;
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

    // Make sure the box is at least this wide/high
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
    return AABB.fromValues(minX, minY, maxX, maxY);
  }
}
