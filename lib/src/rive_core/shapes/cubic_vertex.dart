import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/generated/shapes/cubic_vertex_base.dart';

abstract class CubicVertex extends CubicVertexBase {
  Vec2D get outPoint;
  Vec2D get inPoint;
}
