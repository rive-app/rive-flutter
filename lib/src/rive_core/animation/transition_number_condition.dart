import 'dart:collection';

import 'package:rive/src/generated/animation/transition_number_condition_base.dart';
import 'package:rive/src/rive_core/animation/state_machine_number.dart';
import 'package:rive/src/rive_core/animation/transition_condition.dart';

export 'package:rive/src/generated/animation/transition_number_condition_base.dart';

class TransitionNumberCondition extends TransitionNumberConditionBase {
  @override
  void valueChanged(double from, double to) {}

  @override
  bool validate() => super.validate() && (input is StateMachineNumber);

  @override
  bool evaluate(HashMap<int, dynamic> values) {
    if (input is! StateMachineNumber) {
      return true;
    }
    var doubleInput = input as StateMachineNumber;
    dynamic providedValue = values[input.id];
    double inputValue =
        providedValue is double ? providedValue : doubleInput.value;
    switch (op) {
      case TransitionConditionOp.equal:
        return inputValue == value;
      case TransitionConditionOp.notEqual:
        return inputValue != value;
      case TransitionConditionOp.lessThanOrEqual:
        return inputValue <= value;
      case TransitionConditionOp.lessThan:
        return inputValue < value;
      case TransitionConditionOp.greaterThanOrEqual:
        return inputValue >= value;
      case TransitionConditionOp.greaterThan:
        return inputValue > value;
    }
  }
}
