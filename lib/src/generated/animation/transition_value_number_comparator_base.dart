// Core automatically generated
// lib/src/generated/animation/transition_value_number_comparator_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/transition_comparator_base.dart';
import 'package:rive/src/rive_core/animation/transition_value_comparator.dart';

abstract class TransitionValueNumberComparatorBase
    extends TransitionValueComparator {
  static const int typeKey = 484;
  @override
  int get coreType => TransitionValueNumberComparatorBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TransitionValueNumberComparatorBase.typeKey,
        TransitionValueComparatorBase.typeKey,
        TransitionComparatorBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Value field with key 652.
  static const int valuePropertyKey = 652;
  static const double valueInitialValue = 0;
  double _value = valueInitialValue;
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
  void copy(Core source) {
    super.copy(source);
    if (source is TransitionValueNumberComparatorBase) {
      _value = source._value;
    }
  }
}
