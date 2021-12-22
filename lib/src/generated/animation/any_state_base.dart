/// Core automatically generated
/// lib/src/generated/animation/any_state_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/animation/state_machine_layer_component_base.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';

abstract class AnyStateBase extends LayerState {
  static const int typeKey = 62;
  @override
  int get coreType => AnyStateBase.typeKey;
  @override
  Set<int> get coreTypes => {
        AnyStateBase.typeKey,
        LayerStateBase.typeKey,
        StateMachineLayerComponentBase.typeKey
      };
}
