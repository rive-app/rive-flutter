import 'package:rive/src/rive_core/bones/weight.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/generated/shapes/straight_vertex_base.dart';
export 'package:rive/src/generated/shapes/straight_vertex_base.dart';

class StraightVertex extends StraightVertexBase {
  Weight? _weight;
  @override
  String toString() => 'x[$x], y[$y], r[$radius]';
  @override
  void radiusChanged(double from, double to) {
    path?.markPathDirty();
  }

  @override
  void childAdded(Component component) {
    super.childAdded(component);
    if (component is Weight) {
      _weight = component;
    }
  }

  @override
  void childRemoved(Component component) {
    super.childRemoved(component);
    if (_weight == component) {
      _weight = null;
    }
  }

  @override
  Vec2D get renderTranslation =>
      _weight?.translation ?? super.renderTranslation;
}
