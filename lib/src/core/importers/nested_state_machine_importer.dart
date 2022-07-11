import 'package:rive/src/core/importers/artboard_import_stack_object.dart';
import 'package:rive/src/rive_core/animation/nested_input.dart';
import 'package:rive/src/rive_core/animation/nested_state_machine.dart';

class NestedStateMachineImporter extends ArtboardImportStackObject {
  final NestedStateMachine stateMachine;
  NestedStateMachineImporter(this.stateMachine);

  final List<NestedInput> _inputs = [];
  void addNestedInput(NestedInput nestedInput) {
    _inputs.add(nestedInput);
  }

  @override
  bool resolve() {
    for (final input in _inputs) {
      input.parent = stateMachine;
    }
    return super.resolve();
  }
}
