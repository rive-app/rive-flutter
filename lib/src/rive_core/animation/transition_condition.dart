import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/transition_condition_base.dart';
import 'package:rive/src/rive_core/animation/state_transition.dart';

export 'package:rive/src/generated/animation/transition_condition_base.dart';

enum TransitionConditionOp {
  equal,
  notEqual,
  lessThanOrEqual,
  greaterThanOrEqual,
  lessThan,
  greaterThan,
}

abstract class TransitionCondition extends TransitionConditionBase {
  @override
  void onAdded() {}

  @override
  void onAddedDirty() {}

  @override
  bool import(ImportStack importStack) {
    var importer = importStack
        .latest<StateTransitionImporter>(StateTransitionBase.typeKey);
    if (importer == null) {
      return false;
    }
    importer.addCondition(this);

    return super.import(importStack);
  }
}
