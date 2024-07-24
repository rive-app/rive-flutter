import 'package:rive/src/generated/animation/transition_viewmodel_condition_base.dart';
import 'package:rive/src/rive_core/animation/transition_comparator.dart';
import 'package:rive/src/rive_core/animation/transition_condition.dart';

export 'package:rive/src/generated/animation/transition_viewmodel_condition_base.dart';

class TransitionViewModelCondition extends TransitionViewModelConditionBase {
  TransitionConditionOp get op => TransitionConditionOp.values[opValue];

  @override
  void opValueChanged(int from, int to) {}

  TransitionComparator? get leftComparator =>
      context.resolve<TransitionComparator>(leftComparatorId);

  TransitionComparator? get rightComparator =>
      context.resolve<TransitionComparator>(rightComparatorId);

  @override
  void rightComparatorIdChanged(int from, int to) {}

  @override
  void leftComparatorIdChanged(int from, int to) {}

  @override
  void onAddedDirty() {}
}
