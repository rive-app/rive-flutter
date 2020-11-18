import 'dart:typed_data';
import 'package:rive/src/rive_core/bones/weight.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/shapes/path.dart';
import 'package:rive/src/generated/shapes/path_vertex_base.dart';
export 'package:rive/src/generated/shapes/path_vertex_base.dart';

abstract class PathVertex<T extends Weight> extends PathVertexBase {
  T _weight;
  T get weight => _weight;
  Path get path => parent is Path ? parent as Path : null;
  @override
  void update(int dirt) {}
  final Vec2D _renderTranslation = Vec2D();
  Vec2D get translation => Vec2D.fromValues(x, y);
  Vec2D get renderTranslation => _renderTranslation;
  set translation(Vec2D value) {
    x = value[0];
    y = value[1];
  }

  @override
  void xChanged(double from, double to) {
    _renderTranslation[0] = to;
    path?.markPathDirty();
  }

  @override
  void yChanged(double from, double to) {
    _renderTranslation[1] = to;
    path?.markPathDirty();
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

  void deform(Mat2D world, Float32List boneTransforms) {
    Weight.deform(x, y, weight.indices, weight.values, world, boneTransforms,
        _weight.translation);
  }
}
