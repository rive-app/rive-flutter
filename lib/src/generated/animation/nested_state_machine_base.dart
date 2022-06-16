/// Core automatically generated
/// lib/src/generated/animation/nested_state_machine_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/nested_animation.dart';

abstract class NestedStateMachineBase extends NestedAnimation<StateMachine> {
  static const int typeKey = 95;
  @override
  int get coreType => NestedStateMachineBase.typeKey;
  @override
  Set<int> get coreTypes => {
        NestedStateMachineBase.typeKey,
        NestedAnimationBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };
}
