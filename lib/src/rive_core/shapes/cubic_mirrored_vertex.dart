import 'dart:math';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/generated/shapes/cubic_mirrored_vertex_base.dart';
export 'package:rive/src/generated/shapes/cubic_mirrored_vertex_base.dart';

class CubicMirroredVertex extends CubicMirroredVertexBase {
  Vec2D? _inPoint;
  Vec2D? _outPoint;
  @override
  Vec2D get outPoint {
    return _outPoint ??= Vec2D.add(Vec2D(), translation,
        Vec2D.fromValues(cos(rotation) * distance, sin(rotation) * distance));
  }

  @override
  set outPoint(Vec2D value) {
    _outPoint = Vec2D.clone(value);
  }

  @override
  Vec2D get inPoint {
    return _inPoint ??= Vec2D.add(Vec2D(), translation,
        Vec2D.fromValues(cos(rotation) * -distance, sin(rotation) * -distance));
  }

  @override
  set inPoint(Vec2D value) {
    var diffIn = Vec2D.fromValues(value[0] - x, value[1] - y);
    outPoint = Vec2D.subtract(Vec2D(), translation, diffIn);
  }

  @override
  String toString() {
    return 'in ${inPoint[0]}, ${inPoint[1]} | ${translation.toString()} '
        '| out ${outPoint[0]}, ${outPoint[1]}';
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
  void distanceChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
    _inPoint = _outPoint = null;
    path.markPathDirty();
  }

  @override
  void rotationChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
    _inPoint = _outPoint = null;
    path.markPathDirty();
  }
}
