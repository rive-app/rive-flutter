// Core automatically generated
// lib/src/generated/animation/transition_input_condition_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/transition_condition.dart';

abstract class TransitionInputConditionBase extends TransitionCondition {
  static const int typeKey = 67;
  @override
  int get coreType => TransitionInputConditionBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {TransitionInputConditionBase.typeKey, TransitionConditionBase.typeKey};

  /// --------------------------------------------------------------------------
  /// InputId field with key 155.
  static const int inputIdPropertyKey = 155;
  static const int inputIdInitialValue = -1;
  int _inputId = inputIdInitialValue;

  /// Id of the StateMachineInput referenced.
  int get inputId => _inputId;

  /// Change the [_inputId] field value.
  /// [inputIdChanged] will be invoked only if the field's value has changed.
  set inputId(int value) {
    if (_inputId == value) {
      return;
    }
    int from = _inputId;
    _inputId = value;
    if (hasValidated) {
      inputIdChanged(from, value);
    }
  }

  void inputIdChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is TransitionInputConditionBase) {
      _inputId = source._inputId;
    }
  }
}
