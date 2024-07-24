import 'package:rive/src/generated/animation/transition_comparator_base.dart';
import 'package:rive/src/rive_core/animation/transition_condition.dart';

export 'package:rive/src/generated/animation/transition_comparator_base.dart';

abstract class TransitionComparator extends TransitionComparatorBase {
  bool compareNumbers(
      double left, double right, TransitionConditionOp operation) {
    switch (operation) {
      case TransitionConditionOp.equal:
        return left == right;
      case TransitionConditionOp.notEqual:
        return left != right;
      case TransitionConditionOp.lessThanOrEqual:
        return left <= right;
      case TransitionConditionOp.lessThan:
        return left < right;
      case TransitionConditionOp.greaterThanOrEqual:
        return left >= right;
      case TransitionConditionOp.greaterThan:
        return left > right;
    }
  }

  bool compareEnums(int left, int right, TransitionConditionOp operation) {
    switch (operation) {
      case TransitionConditionOp.equal:
        return left == right;
      case TransitionConditionOp.notEqual:
        return left != right;
      default:
        return false;
    }
  }

  bool compare(
      TransitionComparator comparand, TransitionConditionOp operation) {
    return false;
  }
}
