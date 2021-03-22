import 'package:rive/src/rive_core/math/aabb.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/generated/node_base.dart';
export 'package:rive/src/generated/node_base.dart';

class _UnknownNode extends Node {}

class Node extends NodeBase {
  static final Node unknown = _UnknownNode();
  set translation(Vec2D pos) {
    x = pos[0];
    y = pos[1];
  }

  @override
  void xChanged(double from, double to) {
    markTransformDirty();
  }

  @override
  void yChanged(double from, double to) {
    markTransformDirty();
  }

  AABB get localBounds => AABB.fromValues(x, y, x, y);
}
