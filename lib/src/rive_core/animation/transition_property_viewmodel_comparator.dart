import 'package:rive/src/generated/animation/transition_property_viewmodel_comparator_base.dart';
import 'package:rive/src/rive_core/animation/transition_comparator.dart';
import 'package:rive/src/rive_core/animation/transition_condition.dart';

export 'package:rive/src/generated/animation/transition_property_viewmodel_comparator_base.dart';

class TransitionPropertyViewModelComparator
    extends TransitionPropertyViewModelComparatorBase {
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
