/// Core automatically generated
/// lib/src/generated/animation/transition_value_condition_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/animation/transition_condition.dart';

abstract class TransitionValueConditionBase extends TransitionCondition {
  static const int typeKey = 69;
  @override
  int get coreType => TransitionValueConditionBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {TransitionValueConditionBase.typeKey, TransitionConditionBase.typeKey};

  /// --------------------------------------------------------------------------
  /// OpValue field with key 156.
  static const int opValueInitialValue = 0;
  int _opValue = opValueInitialValue;
  static const int opValuePropertyKey = 156;

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
  void copy(covariant TransitionValueConditionBase source) {
    super.copy(source);
    _opValue = source._opValue;
  }
}
