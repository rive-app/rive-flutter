import 'dart:collection';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/shapes/cubic_vertex.dart';
import 'package:rive/src/utilities/binary_buffer/binary_writer.dart';

class RenderCubicVertex extends CubicVertex {
  @override
  void changeNonNull() {}
  @override
  Vec2D inPoint;
  @override
  Vec2D outPoint;
  @override
  void onAddedDirty() {}
  @override
  void writeRuntimeProperties(
      BinaryWriter writer, HashMap<int, int> idLookup) {}
}
