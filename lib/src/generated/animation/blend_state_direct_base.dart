/// Core automatically generated
/// lib/src/generated/animation/blend_state_direct_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/animation/layer_state_base.dart';
import 'package:rive/src/generated/animation/state_machine_layer_component_base.dart';
import 'package:rive/src/rive_core/animation/blend_animation_direct.dart';
import 'package:rive/src/rive_core/animation/blend_state.dart';

abstract class BlendStateDirectBase extends BlendState<BlendAnimationDirect> {
  static const int typeKey = 73;
  @override
  int get coreType => BlendStateDirectBase.typeKey;
  @override
  Set<int> get coreTypes => {
        BlendStateDirectBase.typeKey,
        BlendStateBase.typeKey,
        LayerStateBase.typeKey,
        StateMachineLayerComponentBase.typeKey
      };
}
