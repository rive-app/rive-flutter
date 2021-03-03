import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_component.dart';

class StateMachineImporter extends ImportStackObject {
  final StateMachine machine;
  StateMachineImporter(this.machine);

  void addMachineComponent(StateMachineComponent object) {
    machine.context.addObject(object);
    object.stateMachine = machine;
  }

  @override
  void resolve() {
  }
}
