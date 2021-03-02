import 'package:rive/src/rive_core/animation/state_machine_trigger.dart';
import 'package:rive/src/generated/animation/transition_trigger_condition_base.dart';
export 'package:rive/src/generated/animation/transition_trigger_condition_base.dart';

class TransitionTriggerCondition extends TransitionTriggerConditionBase {
  @override
  bool validate() => input == null || input is StateMachineTrigger;
}
