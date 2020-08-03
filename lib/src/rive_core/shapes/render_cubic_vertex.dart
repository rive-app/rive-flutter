import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/shapes/cubic_vertex.dart';

class RenderCubicVertex extends CubicVertex {
  @override
  Vec2D inPoint;
  @override
  Vec2D outPoint;
  @override
  void onAddedDirty() {}
}
