import 'dart:collection';

import 'package:rive/src/generated/animation/any_state_base.dart';
import 'package:rive/src/generated/animation/state_machine_layer_base.dart';
import 'package:rive/src/rive_core/animation/any_state.dart';
import 'package:rive/src/rive_core/animation/entry_state.dart';
import 'package:rive/src/rive_core/animation/exit_state.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_component.dart';

export 'package:rive/src/generated/animation/state_machine_layer_base.dart';

class StateMachineLayer extends StateMachineLayerBase {
  LayerState? _entryState;
  LayerState? _anyState;
  LayerState? _exitState;

  LayerState? get entryState => _entryState;
  LayerState? get anyState => _anyState;
  LayerState? get exitState => _exitState;

  @override
  ListBase<StateMachineComponent> machineComponentList(StateMachine machine) =>
      machine.layers;

  /// Called by rive_core to add a LayerState to the StateMachineLayer. This
  /// should be @internal when it's supported.
  bool internalAddState(LayerState state) {
    switch (state.coreType) {
      case AnyStateBase.typeKey:
        _anyState = state;
        break;
      case ExitStateBase.typeKey:
        _exitState = state;
        break;
      case EntryStateBase.typeKey:
        _entryState = state;
        break;
    }

    return true;
  }
}
