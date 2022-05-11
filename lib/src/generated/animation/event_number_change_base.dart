/// Core automatically generated
/// lib/src/generated/animation/event_number_change_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/animation/event_input_change.dart';

abstract class EventNumberChangeBase extends EventInputChange {
  static const int typeKey = 118;
  @override
  int get coreType => EventNumberChangeBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {EventNumberChangeBase.typeKey, EventInputChangeBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Value field with key 229.
  static const double valueInitialValue = 0;
  double _value = valueInitialValue;
  static const int valuePropertyKey = 229;

  /// Value to set the input to when the event occurs.
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
  void copy(covariant EventNumberChangeBase source) {
    super.copy(source);
    _value = source._value;
  }
}
