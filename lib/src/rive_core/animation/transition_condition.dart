import 'package:rive/src/rive_core/animation/state_machine_input.dart';
import 'package:rive/src/generated/animation/transition_condition_base.dart';
export 'package:rive/src/generated/animation/transition_condition_base.dart';

enum TransitionConditionOp {
  equal,
  notEqual,
  lessThanOrEqual,
  greaterThanOrEqual,
  lessThan,
  greaterThan
}

abstract class TransitionCondition extends TransitionConditionBase {
  StateMachineInput _input;
  StateMachineInput get input => _input;
  set input(StateMachineInput value) {
    if (_input == value) {
      return;
    }
    _input = value;
    inputId = _input?.id;
  }

  @override
  void inputIdChanged(int from, int to) {
    input = to == null ? null : context?.resolve(to);
  }

  @override
  void onAdded() {}
  @override
  void onAddedDirty() {
    input = inputId == null ? null : context.resolve(inputId);
  }
}
