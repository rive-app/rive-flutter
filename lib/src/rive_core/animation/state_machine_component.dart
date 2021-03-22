import 'dart:collection';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/generated/animation/state_machine_component_base.dart';
export 'package:rive/src/generated/animation/state_machine_component_base.dart';

abstract class StateMachineComponent extends StateMachineComponentBase {
  late StateMachine stateMachine;
  ListBase<StateMachineComponent> machineComponentList(StateMachine machine);
  @override
  void nameChanged(String from, String to) {}
  @override
  void onAddedDirty() {}
  @override
  void onRemoved() {
    super.onRemoved();
    machineComponentList(stateMachine).remove(this);
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
