import 'package:rive/src/generated/animation/transition_value_condition_base.dart';
import 'package:rive/src/rive_core/animation/transition_condition.dart';

export 'package:rive/src/generated/animation/transition_value_condition_base.dart';

abstract class TransitionValueCondition extends TransitionValueConditionBase {
  TransitionConditionOp get op => TransitionConditionOp.values[opValue];

  @override
  void opValueChanged(int from, int to) {}
}
