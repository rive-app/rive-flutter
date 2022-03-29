import 'dart:collection';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/state_machine_component_base.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';

export 'package:rive/src/generated/animation/state_machine_component_base.dart';

/// Implemented by state machine inputs and layers.
abstract class StateMachineComponent
    extends StateMachineComponentBase<RuntimeArtboard> {
  StateMachine? _stateMachine;
  StateMachine? get stateMachine => _stateMachine;
  set stateMachine(StateMachine? machine) {
    if (_stateMachine == machine) {
      return;
    }
    if (_stateMachine != null) {
      machineComponentList(_stateMachine!).remove(this);
    }
    _stateMachine = machine;

    if (_stateMachine != null) {
      machineComponentList(_stateMachine!).add(this);
    }
  }

  // Intentionally using ListBase instead of FractionallyIndexedList here as
  // it's more compatible with runtime.
  ListBase<StateMachineComponent> machineComponentList(StateMachine machine);

  @override
  void nameChanged(String from, String to) {}

  @override
  void onAddedDirty() {}

  @override
  void onRemoved() {
    super.onRemoved();
    stateMachine = null;
  }

  @override
  bool import(ImportStack importStack) {
    var importer =
        importStack.latest<StateMachineImporter>(StateMachineBase.typeKey);
    if (importer == null) {
      return false;
    }
    importer.addMachineComponent(this);

    return super.import(importStack);
  }
}
