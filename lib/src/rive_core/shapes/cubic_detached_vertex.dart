import 'dart:math';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/shapes/cubic_detached_vertex_base.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';

export 'package:rive/src/generated/shapes/cubic_detached_vertex_base.dart';

class CubicDetachedVertex extends CubicDetachedVertexBase {
  Vec2D? _inPoint;
  Vec2D? _outPoint;

  CubicDetachedVertex();
  CubicDetachedVertex.fromValues({
    required double x,
    required double y,
    double? inX,
    double? inY,
    double? outX,
    double? outY,
    Vec2D? inPoint,
    Vec2D? outPoint,
  }) {
    InternalCoreHelper.markValid(this);
    this.x = x;
    this.y = y;
    this.inPoint = Vec2D.fromValues(inX ?? inPoint!.x, inY ?? inPoint!.y);
    this.outPoint = Vec2D.fromValues(outX ?? outPoint!.x, outY ?? outPoint!.y);
  }

  @override
  Vec2D get outPoint => _outPoint ??= Vec2D.fromValues(
      translation.x + cos(outRotation) * outDistance,
      translation.y + sin(outRotation) * outDistance);

  @override
  set outPoint(Vec2D value) {
    _outPoint = Vec2D.clone(value);
  }

  @override
  Vec2D get inPoint => _inPoint ??= Vec2D.fromValues(
      translation.x + cos(inRotation) * inDistance,
      translation.y + sin(inRotation) * inDistance);

  @override
  set inPoint(Vec2D value) {
    _inPoint = Vec2D.clone(value);
  }

  @override
  String toString() {
    return 'in $inPoint | $translation | out $outPoint';
  }

  @override
  void xChanged(double from, double to) {
    super.xChanged(from, to);
    _outPoint = _inPoint = null;
  }

  @override
  void yChanged(double from, double to) {
    super.yChanged(from, to);
    _outPoint = _inPoint = null;
  }

  @override
  void inDistanceChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
    _inPoint = null;
    path?.markPathDirty();
  }

  @override
  void inRotationChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
    _inPoint = null;
    path?.markPathDirty();
  }

  @override
  void outDistanceChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
    _outPoint = null;
    path?.markPathDirty();
  }

  @override
  void outRotationChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
    _outPoint = null;
    path?.markPathDirty();
  }
}
