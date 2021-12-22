/// Core automatically generated
/// lib/src/generated/bones/skeletal_component_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/world_transform_component_base.dart';
import 'package:rive/src/rive_core/transform_component.dart';

abstract class SkeletalComponentBase extends TransformComponent {
  static const int typeKey = 39;
  @override
  int get coreType => SkeletalComponentBase.typeKey;
  @override
  Set<int> get coreTypes => {
        SkeletalComponentBase.typeKey,
        TransformComponentBase.typeKey,
        WorldTransformComponentBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };
}
