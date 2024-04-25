// Core automatically generated
// lib/src/generated/layout_component_absolute_base.dart.
// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/world_transform_component_base.dart';
import 'package:rive/src/rive_core/layout_component.dart';

abstract class AbsoluteLayoutComponentBase extends LayoutComponent {
  static const int typeKey = 423;
  @override
  int get coreType => AbsoluteLayoutComponentBase.typeKey;
  @override
  Set<int> get coreTypes => {
        AbsoluteLayoutComponentBase.typeKey,
        LayoutComponentBase.typeKey,
        WorldTransformComponentBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };
}
