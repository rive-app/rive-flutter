import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/event_input_change_base.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_event.dart';
import 'package:rive/src/rive_core/animation/state_machine_input.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';

export 'package:rive/src/generated/animation/event_input_change_base.dart';

abstract class EventInputChange extends EventInputChangeBase {
  StateMachineInput _input = StateMachineInput.unknown;
  StateMachineInput get input => _input;
  set input(StateMachineInput value) {
    if (value == _input) {
      return;
    }

    _input = value;

    inputId = _input.id;
  }

  @override
  void inputIdChanged(int from, int to) {
    input = context.resolveWithDefault(to, StateMachineInput.unknown);
  }

  @override
  void onAdded() {}

  @override
  void onAddedDirty() {
    input = context.resolveWithDefault(inputId, StateMachineInput.unknown);
  }

  /// Make the change to the input values.
  void perform(StateMachineController controller);

  @override
  bool import(ImportStack importStack) {
    var importer = importStack
        .latest<StateMachineEventImporter>(StateMachineEventBase.typeKey);
    if (importer == null) {
      return false;
    }
    importer.addInputChange(this);

    var stateMachineImporter =
        importStack.latest<StateMachineImporter>(StateMachineBase.typeKey);
    if (stateMachineImporter == null) {
      return false;
    }
    if (inputId >= 0 && inputId < stateMachineImporter.machine.inputs.length) {
      var found = stateMachineImporter.machine.inputs[inputId];
      _input = found;
      inputId = found.id;
    }

    return super.import(importStack);
  }
}
