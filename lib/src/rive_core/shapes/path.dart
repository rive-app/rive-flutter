import 'dart:math';
import 'dart:ui' as ui;
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/aabb.dart';
import 'package:rive/src/rive_core/math/circle_constant.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/shapes/cubic_vertex.dart';
import 'package:rive/src/rive_core/shapes/path_vertex.dart';
import 'package:rive/src/rive_core/shapes/render_cubic_vertex.dart';
import 'package:rive/src/rive_core/shapes/shape.dart';
import 'package:rive/src/rive_core/shapes/straight_vertex.dart';
import 'package:rive/src/generated/shapes/path_base.dart';
export 'package:rive/src/generated/shapes/path_base.dart';

abstract class Path extends PathBase {
  final Mat2D _inverseWorldTransform = Mat2D();
  final ui.Path _uiPath = ui.Path();
  ui.Path get uiPath {
    if (!_isValid) {
      _buildPath();
    }
    return _uiPath;
  }

  bool _isValid = false;
  bool get isClosed;
  Shape _shape;
  Shape get shape => _shape;
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
    if (_shape == null && ancestor is Shape) {
      _changeShape(ancestor);
    }
  }

  void _changeShape(Shape value) {
    if (_shape == value) {
      return;
    }
    _shape?.removePath(this);
    value?.addPath(this);
    _shape = value;
  }

  @override
  void onRemoved() {
    _changeShape(null);
    super.onRemoved();
  }

  @override
  void updateWorldTransform() {
    super.updateWorldTransform();
    _shape?.pathChanged(this);
    if (!Mat2D.invert(_inverseWorldTransform, worldTransform)) {
      Mat2D.identity(_inverseWorldTransform);
    }
  }

  @override
  void update(int dirt) {
    super.update(dirt);
    if (dirt & ComponentDirt.path != 0) {
      _buildPath();
    }
  }

  void markPathDirty() {
    addDirt(ComponentDirt.path);
    _isValid = false;
    _cachedRenderVertices = null;
    _shape?.pathChanged(this);
  }

  List<PathVertex> get vertices;
  List<PathVertex> _cachedRenderVertices;
  List<PathVertex> get renderVertices {
    if (_cachedRenderVertices != null) {
      return _cachedRenderVertices;
    }
    return _cachedRenderVertices = makeRenderVertices(vertices, isClosed);
  }

  static List<PathVertex> makeRenderVertices(
      List<PathVertex> pts, bool isClosed) {
    if (pts == null || pts.isEmpty) {
      return [];
    }
    List<PathVertex> renderPoints = [];
    int pl = pts.length;
    const arcConstant = circleConstant;
    const double iarcConstant = 1.0 - arcConstant;
    PathVertex previous = isClosed ? pts[pl - 1] : null;
    for (int i = 0; i < pl; i++) {
      PathVertex point = pts[i];
      switch (point.coreType) {
        case StraightVertexBase.typeKey:
          {
            StraightVertex straightPoint = point as StraightVertex;
            double radius = straightPoint.radius;
            if (radius != null && radius > 0) {
              if (!isClosed && (i == 0 || i == pl - 1)) {
                renderPoints.add(point);
                previous = point;
              } else {
                PathVertex next = pts[(i + 1) % pl];
                Vec2D prevPoint = previous is CubicVertex
                    ? previous.outPoint
                    : previous.translation;
                Vec2D nextPoint =
                    next is CubicVertex ? next.inPoint : next.translation;
                Vec2D pos = point.translation;
                Vec2D toPrev = Vec2D.subtract(Vec2D(), prevPoint, pos);
                double toPrevLength = Vec2D.length(toPrev);
                toPrev[0] /= toPrevLength;
                toPrev[1] /= toPrevLength;
                Vec2D toNext = Vec2D.subtract(Vec2D(), nextPoint, pos);
                double toNextLength = Vec2D.length(toNext);
                toNext[0] /= toNextLength;
                toNext[1] /= toNextLength;
                double renderRadius =
                    min(toPrevLength, min(toNextLength, radius));
                Vec2D translation =
                    Vec2D.scaleAndAdd(Vec2D(), pos, toPrev, renderRadius);
                renderPoints.add(RenderCubicVertex()
                  ..translation = translation
                  ..inPoint = translation
                  ..outPoint = Vec2D.scaleAndAdd(
                      Vec2D(), pos, toPrev, iarcConstant * renderRadius));
                translation =
                    Vec2D.scaleAndAdd(Vec2D(), pos, toNext, renderRadius);
                previous = RenderCubicVertex()
                  ..translation = translation
                  ..inPoint = Vec2D.scaleAndAdd(
                      Vec2D(), pos, toNext, iarcConstant * renderRadius)
                  ..outPoint = translation;
                renderPoints.add(previous);
              }
            } else {
              renderPoints.add(point);
              previous = point;
            }
            break;
          }
        default:
          renderPoints.add(point);
          previous = point;
          break;
      }
    }
    return renderPoints;
  }

  bool _buildPath() {
    _isValid = true;
    _uiPath.reset();
    List<PathVertex> pts = vertices;
    if (pts == null || pts.isEmpty) {
      return false;
    }
    var renderPoints = makeRenderVertices(pts, isClosed);
    PathVertex firstPoint = renderPoints[0];
    _uiPath.moveTo(firstPoint.translation[0], firstPoint.translation[1]);
    for (int i = 0,
            l = isClosed ? renderPoints.length : renderPoints.length - 1,
            pl = renderPoints.length;
        i < l;
        i++) {
      PathVertex point = renderPoints[i];
      PathVertex nextPoint = renderPoints[(i + 1) % pl];
      Vec2D cin = nextPoint is CubicVertex ? nextPoint.inPoint : null;
      Vec2D cout = point is CubicVertex ? point.outPoint : null;
      if (cin == null && cout == null) {
        _uiPath.lineTo(nextPoint.translation[0], nextPoint.translation[1]);
      } else {
        cout ??= point.translation;
        cin ??= nextPoint.translation;
        _uiPath.cubicTo(cout[0], cout[1], cin[0], cin[1],
            nextPoint.translation[0], nextPoint.translation[1]);
      }
    }
    if (isClosed) {
      _uiPath.close();
    }
    return true;
  }

  @override
  AABB get localBounds => preciseComputeBounds(renderVertices, Mat2D());
  AABB preciseComputeBounds(List<PathVertex> renderPoints, Mat2D transform,
      {bool debug = false}) {
    if (renderPoints.isEmpty) {
      return AABB();
    }
    AABB bounds = AABB.empty();
    PathVertex firstPoint = renderPoints[0];
    Vec2D lastPoint = bounds.includePoint(firstPoint.translation, transform);
    for (int i = 0,
            l = isClosed ? renderPoints.length : renderPoints.length - 1,
            pl = renderPoints.length;
        i < l;
        i++) {
      PathVertex point = renderPoints[i];
      PathVertex nextPoint = renderPoints[(i + 1) % pl];
      Vec2D cin = nextPoint is CubicVertex ? nextPoint.inPoint : null;
      Vec2D cout = point is CubicVertex ? point.outPoint : null;
      if (cin == null && cout == null) {
        lastPoint = bounds.includePoint(nextPoint.translation, transform);
      } else {
        cout ??= point.translation;
        cin ??= nextPoint.translation;
        var next = bounds.includePoint(nextPoint.translation, transform);
        if (transform != null) {
          cin = Vec2D.transformMat2D(Vec2D(), cin, transform);
          cout = Vec2D.transformMat2D(Vec2D(), cout, transform);
        }
        final double startX = lastPoint[0];
        final double startY = lastPoint[1];
        final double cpX1 = cout[0];
        final double cpY1 = cout[1];
        final double cpX2 = cin[0];
        final double cpY2 = cin[1];
        final double endX = next[0];
        final double endY = next[1];
        lastPoint = next;
        _expandBoundsForAxis(bounds, 0, startX, cpX1, cpX2, endX);
        _expandBoundsForAxis(bounds, 1, startY, cpY1, cpY2, endY);
      }
    }
    return bounds;
  }
}

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
  if (!(((start < cp1) && (cp1 < cp2) && (cp2 < end)) ||
      ((start > cp1) && (cp1 > cp2) && (cp2 > end)))) {
    var a = 3 * (cp1 - start);
    var b = 3 * (cp2 - cp1);
    var c = 3 * (end - cp2);
    var d = a - 2 * b + c;
    if (d != 0) {
      var m1 = -sqrt(b * b - a * c);
      var m2 = -a + b;
      _expandBoundsToCubicPoint(
          bounds, component, -(m1 + m2) / d, start, cp1, cp2, end);
      _expandBoundsToCubicPoint(
          bounds, component, -(-m1 + m2) / d, start, cp1, cp2, end);
    } else if (b != c && d == 0) {
      _expandBoundsToCubicPoint(
          bounds, component, (2 * b - c) / (2 * (b - c)), start, cp1, cp2, end);
    }
    var d2a = 2 * (b - a);
    var d2b = 2 * (c - b);
    if (d2a != b) {
      _expandBoundsToCubicPoint(
          bounds, component, d2a / (d2a - d2b), start, cp1, cp2, end);
    }
  }
}
