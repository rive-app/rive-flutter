import 'dart:math';
import 'dart:ui' as ui;

import 'package:rive/src/generated/shapes/path_base.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/component_flags.dart';
import 'package:rive/src/rive_core/math/aabb.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/shapes/cubic_vertex.dart';
import 'package:rive/src/rive_core/shapes/path_vertex.dart';
import 'package:rive/src/rive_core/shapes/shape.dart';
import 'package:rive/src/rive_core/shapes/straight_vertex.dart';

export 'package:rive/src/generated/shapes/path_base.dart';

/// An abstract low level path that gets implemented by parametric and point
/// based paths.
abstract class Path extends PathBase {
  final Mat2D _inverseWorldTransform = Mat2D();

  final RenderPath _renderPath = RenderPath();
  ui.Path get uiPath {
    if (!_isValid) {
      _buildPath();
    }
    return _renderPath.uiPath;
  }

  bool _isValid = false;

  bool get isClosed;

  Shape? _shape;

  Shape? get shape => _shape;

  Mat2D get pathTransform;
  Mat2D get inversePathTransform;
  Mat2D get inverseWorldTransform => _inverseWorldTransform;

  @override
  bool resolveArtboard() {
    _changeShape(null);
    return super.resolveArtboard();
  }

  @override
  void visitAncestor(Component ancestor) {
    super.visitAncestor(ancestor);
    if (_shape == null && ancestor is Shape) {
      _changeShape(ancestor);
    }
  }

  void _changeShape(Shape? value) {
    if (_shape == value) {
      return;
    }
    _shape?.removePath(this);
    value?.addPath(this);
    _shape = value;
  }

  @override
  void onRemoved() {
    // We're no longer a child of the shape we may have been under, make sure to
    // let it know we're gone.
    _changeShape(null);

    super.onRemoved();
  }

  @override
  void updateWorldTransform() {
    super.updateWorldTransform();
    _shape?.pathChanged(this);

    // Paths store their inverse world so that it's available for skinning and
    // other operations that occur at runtime.
    if (!Mat2D.invert(_inverseWorldTransform, pathTransform)) {
      // If for some reason the inversion fails (like we have a 0 scale) just
      // store the identity.
      Mat2D.setIdentity(_inverseWorldTransform);
    }
  }

  @override
  void update(int dirt) {
    super.update(dirt);

    if (dirt & ComponentDirt.path != 0) {
      _buildPath();
    }
  }

  /// Subclasses should call this whenever a parameter that affects the topology
  /// of the path changes in order to allow the system to rebuild the parametric
  /// path.
  /// should @internal when supported
  void markPathDirty() {
    addDirt(ComponentDirt.path);
    _isValid = false;
    _shape?.pathChanged(this);
  }

  List<PathVertex> get vertices;

  bool _buildPath() {
    _isValid = true;
    _renderPath.reset();
    return buildPath(_renderPath);
  }

  /// Pour the path commands into a PathInterface [path].
  bool buildPath(PathInterface path) {
    List<PathVertex> vertices = this.vertices;
    var length = vertices.length;
    if (length < 2) {
      return false;
    }

    var firstPoint = vertices.first;
    double outX, outY;
    bool prevIsCubic;

    double startX, startY;
    double startInX, startInY;
    bool startIsCubic;

    if (firstPoint is CubicVertex) {
      startIsCubic = prevIsCubic = true;
      var inPoint = firstPoint.renderIn;
      startInX = inPoint.x;
      startInY = inPoint.y;
      var outPoint = firstPoint.renderOut;
      outX = outPoint.x;
      outY = outPoint.y;
      var translation = firstPoint.renderTranslation;
      startX = translation.x;
      startY = translation.y;
      path.moveTo(startX, startY);
    } else {
      startIsCubic = prevIsCubic = false;
      var point = firstPoint as StraightVertex;

      var radius = point.radius;
      if (radius > 0) {
        var prev = vertices[length - 1];

        var pos = point.renderTranslation;

        var toPrev =
            (prev is CubicVertex ? prev.renderOut : prev.renderTranslation) -
                pos;
        var toPrevLength = toPrev.length();
        toPrev.x /= toPrevLength;
        toPrev.y /= toPrevLength;

        var next = vertices[1];

        var toNext =
            (next is CubicVertex ? next.renderIn : next.renderTranslation) -
                pos;
        var toNextLength = toNext.length();
        toNext.x /= toNextLength;
        toNext.y /= toNextLength;

        var renderRadius = min(toPrevLength / 2, min(toNextLength / 2, radius));
        var idealDistance =
            _computeIdealControlPointDistance(toPrev, toNext, renderRadius);

        var translation = Vec2D.scaleAndAdd(Vec2D(), pos, toPrev, renderRadius);
        path.moveTo(startInX = startX = translation.x,
            startInY = startY = translation.y);

        var outPoint = Vec2D.scaleAndAdd(
            Vec2D(), pos, toPrev, renderRadius - idealDistance);

        var inPoint = Vec2D.scaleAndAdd(
            Vec2D(), pos, toNext, renderRadius - idealDistance);

        var posNext = Vec2D.scaleAndAdd(Vec2D(), pos, toNext, renderRadius);
        path.cubicTo(outPoint.x, outPoint.y, inPoint.x, inPoint.y,
            outX = posNext.x, outY = posNext.y);
        prevIsCubic = false;
      } else {
        var translation = point.renderTranslation;
        outX = translation.x;
        outY = translation.y;
        path.moveTo(startInX = startX = outX, startInY = startY = outY);
      }
    }

    for (int i = 1; i < length; i++) {
      var vertex = vertices[i];

      if (vertex is CubicVertex) {
        var inPoint = vertex.renderIn;
        var translation = vertex.renderTranslation;
        path.cubicTo(
            outX, outY, inPoint.x, inPoint.y, translation.x, translation.y);

        prevIsCubic = true;
        var outPoint = vertex.renderOut;
        outX = outPoint.x;
        outY = outPoint.y;
      } else {
        var point = vertex as StraightVertex;

        var radius = point.radius;
        if (radius > 0) {
          var prev = vertices[i - 1];

          var pos = point.renderTranslation;
          var toPrev =
              (prev is CubicVertex ? prev.renderOut : prev.renderTranslation) -
                  pos;

          var toPrevLength = toPrev.length();
          toPrev.x /= toPrevLength;
          toPrev.y /= toPrevLength;

          var next = vertices[(i + 1) % length];

          var toNext =
              (next is CubicVertex ? next.renderIn : next.renderTranslation) -
                  pos;
          var toNextLength = toNext.length();
          toNext.x /= toNextLength;
          toNext.y /= toNextLength;

          var renderRadius =
              min(toPrevLength / 2, min(toNextLength / 2, radius));

          var idealDistance =
              _computeIdealControlPointDistance(toPrev, toNext, renderRadius);

          var translation =
              Vec2D.scaleAndAdd(Vec2D(), pos, toPrev, renderRadius);
          if (prevIsCubic) {
            path.cubicTo(outX, outY, translation.x, translation.y,
                translation.x, translation.y);
          } else {
            path.lineTo(translation.x, translation.y);
          }

          var outPoint = Vec2D.scaleAndAdd(
              Vec2D(), pos, toPrev, renderRadius - idealDistance);

          var inPoint = Vec2D.scaleAndAdd(
              Vec2D(), pos, toNext, renderRadius - idealDistance);

          var posNext = Vec2D.scaleAndAdd(Vec2D(), pos, toNext, renderRadius);
          path.cubicTo(outPoint.x, outPoint.y, inPoint.x, inPoint.y,
              outX = posNext.x, outY = posNext.y);
          prevIsCubic = false;
        } else if (prevIsCubic) {
          var translation = point.renderTranslation;
          var x = translation.x;
          var y = translation.y;
          path.cubicTo(outX, outY, x, y, x, y);

          prevIsCubic = false;
          outX = x;
          outY = y;
        } else {
          var translation = point.renderTranslation;
          outX = translation.x;
          outY = translation.y;
          path.lineTo(outX, outY);
        }
      }
    }
    if (isClosed) {
      if (prevIsCubic || startIsCubic) {
        path.cubicTo(outX, outY, startInX, startInY, startX, startY);
      }
      path.close();
    }
    return true;
  }

  AABB get localBounds => _renderPath.preciseComputeBounds();
  AABB computeBounds(Mat2D relativeTo) => preciseComputeBounds(
        transform: Mat2D.multiply(
          Mat2D(),
          relativeTo,
          pathTransform,
        ),
      );
  AABB preciseComputeBounds({
    Mat2D? transform,
  }) =>
      _renderPath.preciseComputeBounds(
        transform: transform,
      );
  bool get hasBounds => _renderPath.hasBounds;

  @override
  void pathFlagsChanged(int from, int to) => markPathDirty();

  bool get isHidden => (pathFlags & ComponentFlags.hidden) != 0;
}

enum _PathCommand { moveTo, lineTo, cubicTo, close }

abstract class PathInterface {
  void moveTo(double x, double y);
  void lineTo(double x, double y);
  void cubicTo(double ox, double oy, double ix, double iy, double x, double y);
  void close();
}

class RenderPath implements PathInterface {
  final ui.Path _uiPath = ui.Path();
  ui.Path get uiPath => _uiPath;
  final List<_PathCommand> _commands = [];
  final List<double> _positions = [];

  void reset() {
    _commands.clear();
    _positions.clear();
    _uiPath.reset();
  }

  @override
  void lineTo(double x, double y) {
    _commands.add(_PathCommand.lineTo);
    _positions.add(x);
    _positions.add(y);
    _uiPath.lineTo(x, y);
  }

  @override
  void moveTo(double x, double y) {
    _commands.add(_PathCommand.moveTo);
    _positions.add(x);
    _positions.add(y);
    _uiPath.moveTo(x, y);
  }

  @override
  void cubicTo(double ox, double oy, double ix, double iy, double x, double y) {
    _commands.add(_PathCommand.cubicTo);
    _positions.add(ox);
    _positions.add(oy);
    _positions.add(ix);
    _positions.add(iy);
    _positions.add(x);
    _positions.add(y);
    _uiPath.cubicTo(ox, oy, ix, iy, x, y);
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

  @override
  void close() {
    _commands.add(_PathCommand.close);
    _uiPath.close();
  }

  bool get isClosed =>
      _commands.isNotEmpty && _commands.last == _PathCommand.close;

  bool get hasBounds {
    return _commands.length > 1;
  }

  AABB preciseComputeBounds({
    Mat2D? transform,
  }) {
    if (_commands.isEmpty) {
      return AABB.empty();
    }
    // Compute the extremas and use them to expand the bounds as detailed here:
    // https://pomax.github.io/bezierinfo/#extremities

    AABB bounds = AABB.empty();
    var idx = 0;
    var penPosition = Vec2D();
    for (final command in _commands) {
      switch (command) {
        case _PathCommand.lineTo:
          // Pen position already transformed...
          bounds.includePoint(penPosition, null);

          var to = Vec2D.fromValues(_positions[idx++], _positions[idx++]);
          if (transform != null) {
            to.apply(transform);
          }
          penPosition = bounds.includePoint(to, null);

          break;
        // We only do moveTo at the start, effectively always the start of the
        // first line segment (so always include it).
        case _PathCommand.moveTo:
          penPosition.x = _positions[idx++];
          penPosition.y = _positions[idx++];
          if (transform != null) {
            penPosition.apply(transform);
          }

          break;
        case _PathCommand.cubicTo:
          var outPoint = Vec2D.fromValues(_positions[idx++], _positions[idx++]);
          var inPoint = Vec2D.fromValues(_positions[idx++], _positions[idx++]);
          var point = Vec2D.fromValues(_positions[idx++], _positions[idx++]);
          if (transform != null) {
            outPoint.apply(transform);
            inPoint.apply(transform);
            point.apply(transform);
          }
          _expandBoundsForAxis(
              bounds, 0, penPosition.x, outPoint.x, inPoint.x, point.x);
          _expandBoundsForAxis(
              bounds, 1, penPosition.y, outPoint.y, inPoint.y, point.y);
          penPosition = point;

          break;
        case _PathCommand.close:
          break;
      }
    }
    return bounds;
  }
}

/// Expand our bounds to a point (in normalized T space) on the Cubic.
void _expandBoundsToCubicPoint(AABB bounds, int component, double t, double a,
    double b, double c, double d) {
  if (t >= 0 && t <= 1) {
    var ti = 1 - t;
    double extremaY = ((ti * ti * ti) * a) +
        ((3 * ti * ti * t) * b) +
        ((3 * ti * t * t) * c) +
        (t * t * t * d);
    if (extremaY < bounds[component]) {
      bounds[component] = extremaY;
    }
    if (extremaY > bounds[component + 2]) {
      bounds[component + 2] = extremaY;
    }
  }
}

void _expandBoundsForAxis(AABB bounds, int component, double start, double cp1,
    double cp2, double end) {
  // Check start/end as cubic goes through those.
  if (start < bounds[component]) {
    bounds[component] = start;
  }
  if (start > bounds[component + 2]) {
    bounds[component + 2] = start;
  }
  if (end < bounds[component]) {
    bounds[component] = end;
  }
  if (end > bounds[component + 2]) {
    bounds[component + 2] = end;
  }
  // Now check extremas.

  // Find the first derivative
  var a = 3 * (cp1 - start);
  var b = 3 * (cp2 - cp1);
  var c = 3 * (end - cp2);
  var d = a - 2 * b + c;

  // Solve roots for first derivative.
  if (d != 0) {
    var m1 = -sqrt(b * b - a * c);
    var m2 = -a + b;

    // First root.
    _expandBoundsToCubicPoint(
        bounds, component, -(m1 + m2) / d, start, cp1, cp2, end);
    _expandBoundsToCubicPoint(
        bounds, component, -(-m1 + m2) / d, start, cp1, cp2, end);
  } else if (b != c && d == 0) {
    _expandBoundsToCubicPoint(
        bounds, component, (2 * b - c) / (2 * (b - c)), start, cp1, cp2, end);
  }

  // Derive the first derivative to get the 2nd and use the root of
  // that (linear).
  var d2a = 2 * (b - a);
  var d2b = 2 * (c - b);
  if (d2a != b) {
    _expandBoundsToCubicPoint(
        bounds, component, d2a / (d2a - d2b), start, cp1, cp2, end);
  }
}

/// Compute an ideal control point distance to create a curve of the given
/// radius.
double _computeIdealControlPointDistance(
    Vec2D toPrev, Vec2D toNext, double radius) {
  // Get the angle between next and prev
  var angle = atan2(toPrev.x * toNext.y - toPrev.y * toNext.x,
          toPrev.x * toNext.x + toPrev.y * toNext.y)
      .abs();

  return min(
      radius,
      (4 / 3) *
          tan(pi / (2 * ((2 * pi) / angle))) *
          radius *
          (angle < pi / 2 ? 1 + cos(angle) : 2 - sin(angle)));
}
