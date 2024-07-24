import 'package:rive/src/generated/animation/transition_value_number_comparator_base.dart';
import 'package:rive/src/rive_core/animation/transition_comparator.dart';
import 'package:rive/src/rive_core/animation/transition_condition.dart';

export 'package:rive/src/generated/animation/transition_value_number_comparator_base.dart';

class TransitionValueNumberComparator
    extends TransitionValueNumberComparatorBase {
  @override
  void valueChanged(double from, double to) {}

  @override
  void onAdded() {}

  @override
  void onAddedDirty() {}

  @override
  bool compare(
      TransitionComparator comparand, TransitionConditionOp operation) {
    return false;
  }
}
