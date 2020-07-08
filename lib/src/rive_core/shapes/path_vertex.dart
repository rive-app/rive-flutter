import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/shapes/path.dart';
import 'package:rive/src/generated/shapes/path_vertex_base.dart';
export 'package:rive/src/generated/shapes/path_vertex_base.dart';

abstract class PathVertex extends PathVertexBase {
  Path get path => parent as Path;
  @override
  void update(int dirt) {}
  Vec2D get translation {
    return Vec2D.fromValues(x, y);
  }

  set translation(Vec2D value) {
    x = value[0];
    y = value[1];
  }

  @override
  void xChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
    path?.markPathDirty();
  }

  @override
  void yChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
    path?.markPathDirty();
  }

  @override
  String toString() {
    return translation.toString();
  }
}
