import 'package:rive/src/generated/animation/state_machine_layer_component_base.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';

abstract class BlendStateBase extends LayerState {
  static const int typeKey = 72;
  @override
  int get coreType => BlendStateBase.typeKey;
  @override
  Set<int> get coreTypes => {
        BlendStateBase.typeKey,
        LayerStateBase.typeKey,
        StateMachineLayerComponentBase.typeKey
      };
}
