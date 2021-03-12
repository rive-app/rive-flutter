import 'dart:collection';
import 'package:rive/src/rive_core/animation/state_machine_double.dart';
import 'package:rive/src/rive_core/animation/transition_condition.dart';
import 'package:rive/src/generated/animation/transition_double_condition_base.dart';
export 'package:rive/src/generated/animation/transition_double_condition_base.dart';

class TransitionDoubleCondition extends TransitionDoubleConditionBase {
  @override
  void valueChanged(double from, double to) {}
  @override
  bool validate() => input == null || input is StateMachineDouble;
  @override
  bool evaluate(HashMap<int, dynamic> values) {
    var doubleInput = input as StateMachineDouble;
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
    return false;
  }
}
