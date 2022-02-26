import 'package:rive/src/generated/shapes/path_vertex_base.dart';
import 'package:rive/src/rive_core/bones/weight.dart';
import 'package:rive/src/rive_core/shapes/path.dart';

export 'package:rive/src/generated/shapes/path_vertex_base.dart';

abstract class PathVertex<T extends Weight> extends PathVertexBase<T> {
  Path? get path => parent as Path?;

  @override
  void markGeometryDirty() => path?.markPathDirty();
}
