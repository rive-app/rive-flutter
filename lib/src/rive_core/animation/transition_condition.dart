import 'dart:collection';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/transition_condition_base.dart';
import 'package:rive/src/rive_core/animation/state_machine_input.dart';
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
  StateMachineInput _input = StateMachineInput.unknown;
  StateMachineInput get input => _input;
  set input(StateMachineInput value) {
    if (_input == value) {
      return;
    }

    _input = value;

    inputId = _input.id;
  }

  @override
  void inputIdChanged(int from, int to) {
    input = context.resolveWithDefault(to, StateMachineInput.unknown);
  }

  @override
  void onAdded() {}

  @override
  void onAddedDirty() {
    input = context.resolveWithDefault(inputId, StateMachineInput.unknown);
  }

  bool evaluate(HashMap<int, dynamic> values);

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
