import 'package:rive/src/generated/animation/transition_value_boolean_comparator_base.dart';
import 'package:rive/src/rive_core/animation/transition_comparator.dart';
import 'package:rive/src/rive_core/animation/transition_condition.dart';

export 'package:rive/src/generated/animation/transition_value_boolean_comparator_base.dart';

class TransitionValueBooleanComparator
    extends TransitionValueBooleanComparatorBase {
  @override
  void valueChanged(bool from, bool to) {}

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
