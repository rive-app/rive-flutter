/// Core automatically generated
/// lib/src/generated/shapes/cubic_vertex_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/bones/cubic_weight.dart';
import 'package:rive/src/rive_core/shapes/path_vertex.dart';

abstract class CubicVertexBase extends PathVertex<CubicWeight> {
  static const int typeKey = 36;
  @override
  int get coreType => CubicVertexBase.typeKey;
  @override
  Set<int> get coreTypes => {
        CubicVertexBase.typeKey,
        PathVertexBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };
}
