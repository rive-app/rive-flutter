import 'dart:math';
import 'dart:ui' as ui;
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/circle_constant.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/shapes/cubic_vertex.dart';
import 'package:rive/src/rive_core/shapes/path_vertex.dart';
import 'package:rive/src/rive_core/shapes/shape.dart';
import 'package:rive/src/rive_core/shapes/straight_vertex.dart';
import 'package:rive/src/generated/shapes/path_base.dart';
export 'package:rive/src/generated/shapes/path_base.dart';

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
    if (!Mat2D.invert(_inverseWorldTransform, pathTransform)) {
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
    _shape?.pathChanged(this);
  }

  List<PathVertex> get vertices;
  bool _buildPath() {
    _isValid = true;
    _renderPath.reset();
    List<PathVertex> vertices = this.vertices;
    var length = vertices.length;
    if (vertices == null || length < 2) {
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
      startInX = inPoint[0];
      startInY = inPoint[1];
      var outPoint = firstPoint.renderOut;
      outX = outPoint[0];
      outY = outPoint[1];
      var translation = firstPoint.renderTranslation;
      startX = translation[0];
      startY = translation[1];
      _renderPath.moveTo(startX, startY);
    } else {
      startIsCubic = prevIsCubic = false;
      var point = firstPoint as StraightVertex;
      var radius = point.radius;
      if (radius > 0) {
        var prev = vertices[length - 1];
        var pos = point.renderTranslation;
        var toPrev = Vec2D.subtract(Vec2D(),
            prev is CubicVertex ? prev.renderOut : prev.renderTranslation, pos);
        var toPrevLength = Vec2D.length(toPrev);
        toPrev[0] /= toPrevLength;
        toPrev[1] /= toPrevLength;
        var next = vertices[1];
        var toNext = Vec2D.subtract(Vec2D(),
            next is CubicVertex ? next.renderIn : next.renderTranslation, pos);
        var toNextLength = Vec2D.length(toNext);
        toNext[0] /= toNextLength;
        toNext[1] /= toNextLength;
        var renderRadius = min(toPrevLength, min(toNextLength, radius));
        var translation = Vec2D.scaleAndAdd(Vec2D(), pos, toPrev, renderRadius);
        _renderPath.moveTo(startInX = startX = translation[0],
            startInY = startY = translation[1]);
        var outPoint = Vec2D.scaleAndAdd(
            Vec2D(), pos, toPrev, icircleConstant * renderRadius);
        var inPoint = Vec2D.scaleAndAdd(
            Vec2D(), pos, toNext, icircleConstant * renderRadius);
        var posNext = Vec2D.scaleAndAdd(Vec2D(), pos, toNext, renderRadius);
        _renderPath.cubicTo(outPoint[0], outPoint[1], inPoint[0], inPoint[1],
            outX = posNext[0], outY = posNext[1]);
        prevIsCubic = false;
      } else {
        var translation = point.renderTranslation;
        outX = translation[0];
        outY = translation[1];
        _renderPath.moveTo(startInX = startX = outX, startInY = startY = outY);
      }
    }
    for (int i = 1; i < length; i++) {
      var vertex = vertices[i];
      if (vertex is CubicVertex) {
        var inPoint = vertex.renderIn;
        var translation = vertex.renderTranslation;
        _renderPath.cubicTo(
            outX, outY, inPoint[0], inPoint[1], translation[0], translation[1]);
        prevIsCubic = true;
        var outPoint = vertex.renderOut;
        outX = outPoint[0];
        outY = outPoint[1];
      } else {
        var point = vertex as StraightVertex;
        var radius = point.radius;
        if (radius > 0) {
          var pos = point.renderTranslation;
          var toPrev =
              Vec2D.subtract(Vec2D(), Vec2D.fromValues(outX, outY), pos);
          var toPrevLength = Vec2D.length(toPrev);
          toPrev[0] /= toPrevLength;
          toPrev[1] /= toPrevLength;
          var next = vertices[(i + 1) % length];
          var toNext = Vec2D.subtract(
              Vec2D(),
              next is CubicVertex ? next.renderIn : next.renderTranslation,
              pos);
          var toNextLength = Vec2D.length(toNext);
          toNext[0] /= toNextLength;
          toNext[1] /= toNextLength;
          var renderRadius = min(toPrevLength, min(toNextLength, radius));
          var translation =
              Vec2D.scaleAndAdd(Vec2D(), pos, toPrev, renderRadius);
          if (prevIsCubic) {
            _renderPath.cubicTo(outX, outY, translation[0], translation[1],
                translation[0], translation[1]);
          } else {
            _renderPath.lineTo(translation[0], translation[1]);
          }
          var outPoint = Vec2D.scaleAndAdd(
              Vec2D(), pos, toPrev, icircleConstant * renderRadius);
          var inPoint = Vec2D.scaleAndAdd(
              Vec2D(), pos, toNext, icircleConstant * renderRadius);
          var posNext = Vec2D.scaleAndAdd(Vec2D(), pos, toNext, renderRadius);
          _renderPath.cubicTo(outPoint[0], outPoint[1], inPoint[0], inPoint[1],
              outX = posNext[0], outY = posNext[1]);
          prevIsCubic = false;
        } else if (prevIsCubic) {
          var translation = point.renderTranslation;
          var x = translation[0];
          var y = translation[1];
          _renderPath.cubicTo(outX, outY, x, y, x, y);
          prevIsCubic = false;
          outX = x;
          outY = y;
        } else {
          var translation = point.renderTranslation;
          outX = translation[0];
          outY = translation[1];
          _renderPath.lineTo(outX, outY);
        }
      }
    }
    if (isClosed) {
      if (prevIsCubic || startIsCubic) {
        _renderPath.cubicTo(outX, outY, startInX, startInY, startX, startY);
      }
      _renderPath.close();
    }
    return true;
  }
}

class RenderPath {
  final ui.Path _uiPath = ui.Path();
  ui.Path get uiPath => _uiPath;
  void reset() {
    _uiPath.reset();
  }

  void lineTo(double x, double y) {
    _uiPath.lineTo(x, y);
  }

  void moveTo(double x, double y) {
    _uiPath.moveTo(x, y);
  }

  void cubicTo(double ox, double oy, double ix, double iy, double x, double y) {
    _uiPath.cubicTo(ox, oy, ix, iy, x, y);
  }

  void close() {
    _uiPath.close();
  }
}
