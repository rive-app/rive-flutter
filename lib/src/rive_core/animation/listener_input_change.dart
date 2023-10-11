import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/listener_input_change_base.dart';
import 'package:rive/src/rive_core/animation/nested_input.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_input.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';

export 'package:rive/src/generated/animation/listener_input_change_base.dart';

abstract class ListenerInputChange extends ListenerInputChangeBase {
  StateMachineInput _input = StateMachineInput.unknown;
  StateMachineInput get input => _input;
  set input(StateMachineInput value) {
    if (value == _input) {
      return;
    }

    _input = value;

    inputId = _input.id;
  }

  NestedInput? nestedInputForController(StateMachineController controller) {
    return controller.artboard?.context.resolve(nestedInputId);
  }

  @override
  void inputIdChanged(int from, int to) {
    input = context.resolveWithDefault(to, StateMachineInput.unknown);
  }

  @override
  void nestedInputIdChanged(int from, int to) {}

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    input = context.resolveWithDefault(inputId, StateMachineInput.unknown);
  }

  @override
  bool import(ImportStack importStack) {
    if (!super.import(importStack)) {
      return false;
    }

    var stateMachineImporter =
        importStack.latest<StateMachineImporter>(StateMachineBase.typeKey);
    if (stateMachineImporter == null) {
      return false;
    }
    if (inputId >= 0 && inputId < stateMachineImporter.machine.inputs.length) {
      var found = stateMachineImporter.machine.inputs[inputId];
      _input = found as StateMachineInput;
      inputId = found.id;
    }

    return super.import(importStack);
  }
}
