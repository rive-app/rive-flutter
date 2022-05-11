import 'package:rive/src/generated/node_base.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';

export 'package:rive/src/generated/node_base.dart';

class _UnknownNode extends Node {}

class Node extends NodeBase {
  static final Node unknown = _UnknownNode();

  /// Sets the position of the Node
  set translation(Vec2D pos) {
    x = pos.x;
    y = pos.y;
  }

  @override
  void xChanged(double from, double to) {
    markTransformDirty();
  }

  @override
  void yChanged(double from, double to) {
    markTransformDirty();
  }
}
