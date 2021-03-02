import 'package:rive/src/rive_core/animation/state_machine_bool.dart';
import 'package:rive/src/generated/animation/transition_bool_condition_base.dart';
export 'package:rive/src/generated/animation/transition_bool_condition_base.dart';

class TransitionBoolCondition extends TransitionBoolConditionBase {
  @override
  void valueChanged(bool from, bool to) {}
  @override
  bool validate() => input == null || input is StateMachineBool;
}
