import 'dart:collection';

import 'package:rive/src/generated/animation/transition_bool_condition_base.dart';
import 'package:rive/src/rive_core/animation/state_machine_bool.dart';
import 'package:rive/src/rive_core/animation/transition_condition.dart';

export 'package:rive/src/generated/animation/transition_bool_condition_base.dart';

class TransitionBoolCondition extends TransitionBoolConditionBase {
  @override
  bool validate() => super.validate() && (input is StateMachineBool);

  @override
  bool evaluate(HashMap<int, dynamic> values) {
    if (input is! StateMachineBool) {
      return true;
    }
    var boolInput = input as StateMachineBool;
    dynamic providedValue = values[input.id];
    bool value = providedValue is bool ? providedValue : boolInput.value;
    return (value && op == TransitionConditionOp.equal) ||
        (!value && op == TransitionConditionOp.notEqual);
  }
}
