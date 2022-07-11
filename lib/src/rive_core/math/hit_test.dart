import 'dart:math';

import 'package:rive/src/rive_core/math/aabb.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/path_types.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/shapes/path.dart';

class HitTester implements PathInterface {
  final List<int> _windings;
  double _firstX, _firstY;
  double _prevX, _prevY;
  final double _offsetX, _offsetY;
  final int _iwidth;
  final double _height;
  final double _tolerance;
  bool _expectsMove;

  HitTester(IAABB area, [double tolerance = 0.25])
      : _windings =
            List<int>.filled(area.width * area.height, 0, growable: false),
        _firstX = 0,
        _firstY = 0,
        _prevX = 0,
        _prevY = 0,
        _offsetX = area.left.toDouble(),
        _offsetY = area.top.toDouble(),
        _iwidth = area.width,
        _height = area.height.toDouble(),
        _tolerance = tolerance,
        _expectsMove = true;

  void _appendLine(
      double x0, double y0, double x1, double y1, double slope, int winding) {
    assert(winding == 1 || winding == -1);

    // we round to see which pixel centers we cross
    final int top = y0.round();
    final int bottom = y1.round();
    if (top == bottom) {
      return;
    }

    assert(top < bottom);
    assert(top >= 0);
    assert(bottom <= _height);

    // we add 0.5 at the end to pre-round the values
    double x = x0 + slope * (top - y0 + 0.5) + 0.5;
    // start on the correct row
    int index = top * _iwidth;
    for (int y = top; y < bottom; ++y) {
      int ix = max(x, 0.0).floor();
      if (ix < _iwidth) {
        _windings[index + ix] += winding;
      }
      x += slope;
      index += _iwidth; // bump to next row
    }
  }

  void _clipLine(double x0, double y0, double x1, double y1) {
    if (y0 == y1) {
      return;
    }

    int winding = 1;
    if (y0 > y1) {
      winding = -1;

      // Swap our two points (is there a swap utility?)
      double tmp = y0;
      // ignore: parameter_assignments
      y0 = y1;
      // ignore: parameter_assignments
      y1 = tmp;

      tmp = x0;
      // ignore: parameter_assignments
      x0 = x1;
      // ignore: parameter_assignments
      x1 = tmp;
    }
    // now we're monotonic in Y: y0 <= y1
    if (y1 <= 0 || y0 >= _height) {
      return;
    }

    final double m = (x1 - x0) / (y1 - y0);
    if (y0 < 0) {
      // ignore: parameter_assignments
      x0 += m * (0 - y0);
      // ignore: parameter_assignments
      y0 = 0;
    }
    if (y1 > _height) {
      // ignore: parameter_assignments
      x1 += m * (_height - y1);
      // ignore: parameter_assignments
      y1 = _height;
    }

    assert(y0 <= y1);
    assert(y0 >= 0);
    assert(y1 <= _height);

    _appendLine(x0, y0, x1, y1, m, winding);
  }

  @override
  void moveTo(double x, double y) {
    if (!_expectsMove) {
      close();
    }
    _firstX = _prevX = x - _offsetX;
    _firstY = _prevY = y - _offsetY;
    _expectsMove = false;
  }

  @override
  void lineTo(double x, double y) {
    assert(!_expectsMove);
    // ignore: parameter_assignments
    x -= _offsetX;
    // ignore: parameter_assignments
    y -= _offsetY;
    _clipLine(_prevX, _prevY, x, y);
    _prevX = x;
    _prevY = y;
  }

  bool _quickRejectY(double y0, double y1, double y2, double y3) {
    final double h = _height;
    return y0 <= 0 && y1 <= 0 && y2 <= 0 && y3 <= 0 ||
        y0 >= h && y1 >= h && y2 >= h && y3 >= h;
  }

  /*
   * Computes (conservatively) the number of line-segments needed
   * to approximate this cubic and stay within the specified tolerance.
   */
  static int _countCubicSegments(double ax, double ay, double bx, double by,
      double cx, double cy, double dx, double dy, double tolerance) {
    final abcX = ax - bx - bx + cx;
    final abcY = ay - by - by + cy;

    final bcdX = bx - cx - cx + dx;
    final bcdY = by - cy - cy + dy;

    final errX = max(abcX.abs(), bcdX.abs());
    final errY = max(abcY.abs(), bcdY.abs());
    final dist = sqrt(errX * errX + errY * errY);

    const maxCurveSegments = 1 << 8; // just a big but finite value
    final count = sqrt((3 * dist) / (4 * tolerance));
    return max(1, min(count.ceil(), maxCurveSegments));
  }

  @override
  void cubicTo(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    assert(!_expectsMove);

    // ignore: parameter_assignments
    x1 -= _offsetX;
    // ignore: parameter_assignments
    x2 -= _offsetX;
    // ignore: parameter_assignments
    x3 -= _offsetX;

    // ignore: parameter_assignments
    y1 -= _offsetY;
    // ignore: parameter_assignments
    y2 -= _offsetY;
    // ignore: parameter_assignments
    y3 -= _offsetY;

    if (_quickRejectY(_prevY, y1, y2, y3)) {
      _prevX = x3;
      _prevY = y3;
      return;
    }

    final count =
        _countCubicSegments(_prevX, _prevY, x1, y1, x2, y2, x3, y3, _tolerance);

    final dt = 1.0 / count;
    double t = dt;

    // Compute simple coefficients for the cubic polynomial
    // ... much faster to evaluate multiple times
    // ... At^3 + Bt^2 + Ct + D
    //
    final aX = (x3 - _prevX) + 3 * (x1 - x2);
    final bX = 3 * ((x2 - x1) + (_prevX - x1));
    final cX = 3 * (x1 - _prevX);
    final dX = _prevX;

    final aY = (y3 - _prevY) + 3 * (y1 - y2);
    final bY = 3 * ((y2 - y1) + (_prevY - y1));
    final cY = 3 * (y1 - _prevY);
    final dY = _prevY;

    // we don't need the first point eval(0) or the last eval(1)
    double px = _prevX;
    double py = _prevY;
    for (int i = 1; i < count - 1; ++i) {
      // Horner's method for evaluating the simple polynomial
      final nx = ((aX * t + bX) * t + cX) * t + dX;
      final ny = ((aY * t + bY) * t + cY) * t + dY;
      _clipLine(px, py, nx, ny);
      px = nx;
      py = ny;
      t += dt;
    }
    _clipLine(px, py, x3, y3);
    _prevX = x3;
    _prevY = y3;
  }

  @override
  void close() {
    assert(!_expectsMove);

    _clipLine(_prevX, _prevY, _firstX, _firstY);
    _expectsMove = true;
  }

  void move(Vec2D v) {
    moveTo(v.x, v.y);
  }

  void line(Vec2D v) {
    lineTo(v.x, v.y);
  }

  void cubic(Vec2D b, Vec2D c, Vec2D d) {
    cubicTo(b.x, b.y, c.x, c.y, d.x, d.y);
  }

  void addRect(AABB r, Mat2D xform, PathDirection dir) {
    final p0 = xform * Vec2D.fromValues(r.left, r.top);
    final p1 = xform * Vec2D.fromValues(r.right, r.top);
    final p2 = xform * Vec2D.fromValues(r.right, r.bottom);
    final p3 = xform * Vec2D.fromValues(r.left, r.bottom);

    move(p0);
    if (dir == PathDirection.clockwise) {
      line(p1);
      line(p2);
      line(p3);
    } else {
      assert(dir == PathDirection.counterclockwise);
      line(p3);
      line(p2);
      line(p1);
    }
    close();
  }

  bool test([PathFillRule rule = PathFillRule.nonZero]) {
    if (!_expectsMove) {
      close();
    }

    final int mask = (rule == PathFillRule.nonZero) ? -1 : 1;

    int nonzero = 0;

    for (final w in _windings) {
      nonzero |= w & mask;
    }
    return nonzero != 0;
  }
}

/// A HitTester with a settable transform. We can roll this into HitTester if we
/// like it.
class TransformingHitTester extends HitTester {
  TransformingHitTester(
    IAABB area, [
    double tolerance = 0.25,
  ]) : super(area, tolerance = tolerance);

  Mat2D _transform = Mat2D();
  bool _needsTransform = false;

  Mat2D get transform => _transform;
  set transform(Mat2D value) {
    _transform = value;
    _needsTransform = !value.isIdentity;
  }

  @override
  void moveTo(double x, double y) {
    if (!_needsTransform) {
      super.moveTo(x, y);
      return;
    }
    var v = _transform * Vec2D.fromValues(x, y);
    super.moveTo(v.x, v.y);
  }

  @override
  void lineTo(double x, double y) {
    if (!_needsTransform) {
      super.lineTo(x, y);
      return;
    }
    var v = _transform * Vec2D.fromValues(x, y);
    super.lineTo(v.x, v.y);
  }

  @override
  void cubicTo(double ox, double oy, double ix, double iy, double x, double y) {
    if (!_needsTransform) {
      super.cubicTo(ox, oy, ix, iy, x, y);
      return;
    }
    var o = _transform * Vec2D.fromValues(ox, oy);
    var i = _transform * Vec2D.fromValues(ix, iy);
    var p = _transform * Vec2D.fromValues(x, y);
    super.cubicTo(o.x, o.y, i.x, i.y, p.x, p.y);
  }
}
