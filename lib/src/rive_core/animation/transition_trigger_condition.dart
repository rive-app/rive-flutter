import 'dart:collection';
import 'package:rive/src/rive_core/animation/state_machine_trigger.dart';
import 'package:rive/src/generated/animation/transition_trigger_condition_base.dart';
export 'package:rive/src/generated/animation/transition_trigger_condition_base.dart';

class TransitionTriggerCondition extends TransitionTriggerConditionBase {
  @override
  bool validate() => super.validate() && (input is StateMachineTrigger);
  @override
  bool evaluate(HashMap<int, dynamic> values) {
    if (input is! StateMachineTrigger) {
      return true;
    }
    dynamic providedValue = values[input.id];
    if (providedValue is bool && providedValue) {
      values[input.id] = false;
      return true;
    }
    var triggerInput = input as StateMachineTrigger;
    if (triggerInput.triggered) {
      return true;
    }
    return false;
  }
}
