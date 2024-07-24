// Core automatically generated
// lib/src/generated/animation/transition_value_string_comparator_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/transition_comparator_base.dart';
import 'package:rive/src/rive_core/animation/transition_value_comparator.dart';

abstract class TransitionValueStringComparatorBase
    extends TransitionValueComparator {
  static const int typeKey = 486;
  @override
  int get coreType => TransitionValueStringComparatorBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TransitionValueStringComparatorBase.typeKey,
        TransitionValueComparatorBase.typeKey,
        TransitionComparatorBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Value field with key 647.
  static const int valuePropertyKey = 647;
  static const String valueInitialValue = '';
  String _value = valueInitialValue;
  String get value => _value;

  /// Change the [_value] field value.
  /// [valueChanged] will be invoked only if the field's value has changed.
  set value(String value) {
    if (_value == value) {
      return;
    }
    String from = _value;
    _value = value;
    if (hasValidated) {
      valueChanged(from, value);
    }
  }

  void valueChanged(String from, String to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is TransitionValueStringComparatorBase) {
      _value = source._value;
    }
  }
}
