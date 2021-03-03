import 'dart:collection';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/generated/animation/state_machine_component_base.dart';
export 'package:rive/src/generated/animation/state_machine_component_base.dart';

abstract class StateMachineComponent extends StateMachineComponentBase {
  StateMachine _stateMachine;
  StateMachine get stateMachine => _stateMachine;
  set stateMachine(StateMachine value) {
    if (_stateMachine == value) {
      return;
    }
    var from = _stateMachine;
    _stateMachine = value;
    machineChanged(from, _stateMachine);
  }

  ListBase<StateMachineComponent> machineComponentList(StateMachine machine);
  void machineChanged(StateMachine from, StateMachine to) {
    if (from != null) {
      machineComponentList(from)?.remove(this);
    }
    if (to != null) {
      machineComponentList(to)?.add(this);
    }
  }

  @override
  void nameChanged(String from, String to) {}
  @override
  void onAdded() {}
  @override
  void onAddedDirty() {}
  @override
  void onRemoved() {
    super.onRemoved();
    if (stateMachine != null) {
      machineComponentList(stateMachine).remove(this);
    }
  }
}
