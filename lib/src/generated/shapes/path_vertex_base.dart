/// Core automatically generated lib/src/generated/shapes/path_vertex_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/bones/weight.dart';
import 'package:rive/src/rive_core/shapes/vertex.dart';

abstract class PathVertexBase<T extends Weight> extends Vertex<T> {
  static const int typeKey = 14;
  @override
  int get coreType => PathVertexBase.typeKey;
  @override
  Set<int> get coreTypes => {
        PathVertexBase.typeKey,
        VertexBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };
}
