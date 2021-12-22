/// Core automatically generated
/// lib/src/generated/animation/state_machine_double_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/animation/state_machine_component_base.dart';
import 'package:rive/src/rive_core/animation/state_machine_input.dart';

abstract class StateMachineDoubleBase extends StateMachineInput {
  static const int typeKey = 56;
  @override
  int get coreType => StateMachineDoubleBase.typeKey;
  @override
  Set<int> get coreTypes => {
        StateMachineDoubleBase.typeKey,
        StateMachineInputBase.typeKey,
        StateMachineComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Value field with key 140.
  static const double valueInitialValue = 0;
  double _value = valueInitialValue;
  static const int valuePropertyKey = 140;
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
}
