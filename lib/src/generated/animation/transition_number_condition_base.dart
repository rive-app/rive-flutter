/// Core automatically generated
/// lib/src/generated/animation/transition_number_condition_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/animation/transition_condition_base.dart';
import 'package:rive/src/rive_core/animation/transition_value_condition.dart';

abstract class TransitionNumberConditionBase extends TransitionValueCondition {
  static const int typeKey = 70;
  @override
  int get coreType => TransitionNumberConditionBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TransitionNumberConditionBase.typeKey,
        TransitionValueConditionBase.typeKey,
        TransitionConditionBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Value field with key 157.
  static const double valueInitialValue = 0;
  double _value = valueInitialValue;
  static const int valuePropertyKey = 157;
  double get value => _value;

  /// Change the [_value] field value.
  /// [valueChanged] will be invoked only if the field's value has changed.
  set value(double value) {
    if (_value == value) {
      return;
    }
    double from = _value;
    _value = value;
    if (hasValidated) {
      valueChanged(from, value);
    }
  }

  void valueChanged(double from, double to);

  @override
  void copy(covariant TransitionNumberConditionBase source) {
    super.copy(source);
    _value = source._value;
  }
}
