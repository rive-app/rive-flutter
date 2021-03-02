import 'dart:collection';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_component.dart';
import 'package:rive/src/generated/animation/state_machine_layer_base.dart';
export 'package:rive/src/generated/animation/state_machine_layer_base.dart';

class StateMachineLayer extends StateMachineLayerBase {
  LayerState _entryState;
  LayerState _anyState;
  LayerState _exitState;
  LayerState get entryState => _entryState;
  LayerState get anyState => _anyState;
  LayerState get exitState => _exitState;
  @override
  ListBase<StateMachineComponent> machineComponentList(StateMachine machine) =>
      machine?.layers;
  @override
  void onAdded() {}
}
