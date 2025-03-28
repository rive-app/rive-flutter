// Core automatically generated
// lib/src/generated/animation/transition_input_condition_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/transition_condition.dart';

const _coreTypes = {TransitionInputConditionBase.typeKey, TransitionConditionBase.typeKey};

abstract class TransitionInputConditionBase extends TransitionCondition {
  static const int typeKey = 67;
  @override
  int get coreType => TransitionInputConditionBase.typeKey;
  @override
  Set<int> get coreTypes => _coreTypes;

  /// --------------------------------------------------------------------------
  /// InputId field with key 155.
  static const int inputIdPropertyKey = 155;
  static const int inputIdInitialValue = -1;

  @nonVirtual
  int inputId_ = inputIdInitialValue;

  /// Id of the StateMachineInput referenced.
  @nonVirtual
  int get inputId => inputId_;

  /// Change the [inputId_] field value.
  /// [inputIdChanged] will be invoked only if the field's value has changed.
  set inputId(int value) {
    if (inputId_ == value) {
      return;
    }
    int from = inputId_;
    inputId_ = value;
    if (hasValidated) {
      inputIdChanged(from, value);
    }
  }

  void inputIdChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is TransitionInputConditionBase) {
      inputId_ = source.inputId_;
    }
  }
}
