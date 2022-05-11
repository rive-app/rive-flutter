import 'dart:math';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/shapes/cubic_asymmetric_vertex_base.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';

export 'package:rive/src/generated/shapes/cubic_asymmetric_vertex_base.dart';

class CubicAsymmetricVertex extends CubicAsymmetricVertexBase {
  CubicAsymmetricVertex();
  CubicAsymmetricVertex.procedural() {
    InternalCoreHelper.markValid(this);
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
