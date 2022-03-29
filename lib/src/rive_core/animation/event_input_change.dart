import 'package:rive/src/generated/animation/event_input_change_base.dart';
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
}
