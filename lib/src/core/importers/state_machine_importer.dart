import 'package:rive/src/core/importers/artboard_import_stack_object.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_component.dart';

class StateMachineImporter extends ArtboardImportStackObject {
  final StateMachine machine;
  StateMachineImporter(this.machine);

  void addMachineComponent(StateMachineComponent object) {
    machine.context.addObject(object);
    object.stateMachine = machine;
  }
}
