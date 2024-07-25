// Core automatically generated
// lib/src/generated/animation/transition_viewmodel_condition_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/transition_condition.dart';

abstract class TransitionViewModelConditionBase extends TransitionCondition {
  static const int typeKey = 482;
  @override
  int get coreType => TransitionViewModelConditionBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TransitionViewModelConditionBase.typeKey,
        TransitionConditionBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// LeftComparatorId field with key 648.
  static const int leftComparatorIdPropertyKey = 648;
  static const int leftComparatorIdInitialValue = -1;
  int _leftComparatorId = leftComparatorIdInitialValue;

  /// The id of the left comaprand to use for this condition
  int get leftComparatorId => _leftComparatorId;

  /// Change the [_leftComparatorId] field value.
  /// [leftComparatorIdChanged] will be invoked only if the field's value has
  /// changed.
  set leftComparatorId(int value) {
    if (_leftComparatorId == value) {
      return;
    }
    int from = _leftComparatorId;
    _leftComparatorId = value;
    if (hasValidated) {
      leftComparatorIdChanged(from, value);
    }
  }

  void leftComparatorIdChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// RightComparatorId field with key 649.
  static const int rightComparatorIdPropertyKey = 649;
  static const int rightComparatorIdInitialValue = -1;
  int _rightComparatorId = rightComparatorIdInitialValue;

  /// The id of the right comaprand to use for this condition
  int get rightComparatorId => _rightComparatorId;

  /// Change the [_rightComparatorId] field value.
  /// [rightComparatorIdChanged] will be invoked only if the field's value has
  /// changed.
  set rightComparatorId(int value) {
    if (_rightComparatorId == value) {
      return;
    }
    int from = _rightComparatorId;
    _rightComparatorId = value;
    if (hasValidated) {
      rightComparatorIdChanged(from, value);
    }
  }

  void rightComparatorIdChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// OpValue field with key 650.
  static const int opValuePropertyKey = 650;
  static const int opValueInitialValue = 0;
  int _opValue = opValueInitialValue;

  /// Integer representation of the StateMachineOp enum.
  int get opValue => _opValue;

  /// Change the [_opValue] field value.
  /// [opValueChanged] will be invoked only if the field's value has changed.
  set opValue(int value) {
    if (_opValue == value) {
      return;
    }
    int from = _opValue;
    _opValue = value;
    if (hasValidated) {
      opValueChanged(from, value);
    }
  }

  void opValueChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is TransitionViewModelConditionBase) {
      _leftComparatorId = source._leftComparatorId;
      _rightComparatorId = source._rightComparatorId;
      _opValue = source._opValue;
    }
  }
}
