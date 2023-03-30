import 'dart:math';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/shapes/cubic_asymmetric_vertex_base.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive_common/math.dart';

export 'package:rive/src/generated/shapes/cubic_asymmetric_vertex_base.dart';

class CubicAsymmetricVertex extends CubicAsymmetricVertexBase {
  CubicAsymmetricVertex();
  CubicAsymmetricVertex.procedural() {
    InternalCoreHelper.markValid(this);
  }

  CubicAsymmetricVertex.fromValues({
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

  Vec2D? _inPoint;
  Vec2D? _outPoint;

  @override
  Vec2D get outPoint {
    return _outPoint ??= Vec2D.fromValues(
        translation.x + cos(rotation) * outDistance,
        translation.y + sin(rotation) * outDistance);
  }

  @override
  set outPoint(Vec2D value) {
    _outPoint = Vec2D.clone(value);
  }

  @override
  Vec2D get inPoint {
    return _inPoint ??= Vec2D.fromValues(
        translation.x + cos(rotation) * -inDistance,
        translation.y + sin(rotation) * -inDistance);
  }

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
    _inPoint = _outPoint = null;
    path?.markPathDirty();
  }

  @override
  void outDistanceChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
    _inPoint = _outPoint = null;
    path?.markPathDirty();
  }

  @override
  void rotationChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
    _inPoint = _outPoint = null;
    path?.markPathDirty();
  }
}
