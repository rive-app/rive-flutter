/// Core automatically generated
/// lib/src/generated/animation/state_machine_bool_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/animation/state_machine_component_base.dart';
import 'package:rive/src/generated/animation/state_machine_input_base.dart';
import 'package:rive/src/rive_core/animation/state_machine_input.dart';

abstract class StateMachineBoolBase extends StateMachineInput {
  static const int typeKey = 59;
  @override
  int get coreType => StateMachineBoolBase.typeKey;
  @override
  Set<int> get coreTypes => {
        StateMachineBoolBase.typeKey,
        StateMachineInputBase.typeKey,
        StateMachineComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Value field with key 141.
  bool _value = false;
  static const int valuePropertyKey = 141;
  bool get value => _value;

  /// Change the [_value] field value.
  /// [valueChanged] will be invoked only if the field's value has changed.
  set value(bool value) {
    if (_value == value) {
      return;
    }
    bool from = _value;
    _value = value;
    valueChanged(from, value);
  }

  void valueChanged(bool from, bool to);
}
