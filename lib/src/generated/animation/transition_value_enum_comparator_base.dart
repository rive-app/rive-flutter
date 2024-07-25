// Core automatically generated
// lib/src/generated/animation/transition_value_enum_comparator_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/transition_comparator_base.dart';
import 'package:rive/src/rive_core/animation/transition_value_comparator.dart';

abstract class TransitionValueEnumComparatorBase
    extends TransitionValueComparator {
  static const int typeKey = 485;
  @override
  int get coreType => TransitionValueEnumComparatorBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TransitionValueEnumComparatorBase.typeKey,
        TransitionValueComparatorBase.typeKey,
        TransitionComparatorBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Value field with key 653.
  static const int valuePropertyKey = 653;
  static const int valueInitialValue = -1;
  int _value = valueInitialValue;

  /// The id of the enum to compare the condition to
  int get value => _value;

  /// Change the [_value] field value.
  /// [valueChanged] will be invoked only if the field's value has changed.
  set value(int value) {
    if (_value == value) {
      return;
    }
    int from = _value;
    _value = value;
    if (hasValidated) {
      valueChanged(from, value);
    }
  }

  void valueChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is TransitionValueEnumComparatorBase) {
      _value = source._value;
    }
  }
}
