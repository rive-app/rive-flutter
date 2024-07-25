// Core automatically generated
// lib/src/generated/animation/transition_value_boolean_comparator_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/transition_comparator_base.dart';
import 'package:rive/src/rive_core/animation/transition_value_comparator.dart';

abstract class TransitionValueBooleanComparatorBase
    extends TransitionValueComparator {
  static const int typeKey = 481;
  @override
  int get coreType => TransitionValueBooleanComparatorBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TransitionValueBooleanComparatorBase.typeKey,
        TransitionValueComparatorBase.typeKey,
        TransitionComparatorBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Value field with key 647.
  static const int valuePropertyKey = 647;
  static const bool valueInitialValue = false;
  bool _value = valueInitialValue;
  bool get value => _value;

  /// Change the [_value] field value.
  /// [valueChanged] will be invoked only if the field's value has changed.
  set value(bool value) {
    if (_value == value) {
      return;
    }
    bool from = _value;
    _value = value;
    if (hasValidated) {
      valueChanged(from, value);
    }
  }

  void valueChanged(bool from, bool to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is TransitionValueBooleanComparatorBase) {
      _value = source._value;
    }
  }
}
