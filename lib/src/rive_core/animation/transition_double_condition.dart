import 'package:rive/src/rive_core/animation/state_machine_double.dart';
import 'package:rive/src/generated/animation/transition_double_condition_base.dart';
export 'package:rive/src/generated/animation/transition_double_condition_base.dart';

class TransitionDoubleCondition extends TransitionDoubleConditionBase {
  @override
  void valueChanged(double from, double to) {}
  @override
  bool validate() => input == null || input is StateMachineDouble;
}
