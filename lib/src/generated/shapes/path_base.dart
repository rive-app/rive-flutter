/// Core automatically generated lib/src/generated/shapes/path_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/node_base.dart';
import 'package:rive/src/rive_core/node.dart';

abstract class PathBase extends Node {
  static const int typeKey = 12;
  @override
  int get coreType => PathBase.typeKey;
  @override
  Set<int> get coreTypes => {
        PathBase.typeKey,
        NodeBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };
}
