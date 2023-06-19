import 'package:rive/src/rive_core/animation/state_machine_layer_component.dart';

abstract class LayerStateBase extends StateMachineLayerComponent {
  static const int typeKey = 60;
  @override
  int get coreType => LayerStateBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {LayerStateBase.typeKey, StateMachineLayerComponentBase.typeKey};
}
