import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/shapes/vertex_base.dart';
import 'package:rive/src/rive_core/bones/weight.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';

export 'package:rive/src/generated/shapes/vertex_base.dart';

abstract class Vertex<T extends Weight> extends VertexBase {
  T? _weight;
  T? get weight => _weight;

  Vec2D get translation => Vec2D.fromValues(x, y);
  Vec2D get renderTranslation => weight?.translation ?? translation;

  set translation(Vec2D value) {
    x = value.x;
    y = value.y;
  }

  @override
  void xChanged(double from, double to) {
    markGeometryDirty();
  }

  void markGeometryDirty();

  @override
  void yChanged(double from, double to) {
    markGeometryDirty();
  }

  @override
  String toString() {
    return translation.toString();
  }

  @override
  void childAdded(Component component) {
    super.childAdded(component);
    if (component is T) {
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

  /// Deform only gets called when we are weighted.
  void deform(Mat2D world, Float32List boneTransforms) {
    Weight.deform(x, y, weight!.indices, weight!.values, world, boneTransforms,
        _weight!.translation);
  }

  @override
  void update(int dirt) {}
}
