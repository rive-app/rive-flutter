// Core automatically generated
// lib/src/generated/animation/state_machine_component_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class StateMachineComponentBase<T extends CoreContext>
    extends Core<T> {
  static const int typeKey = 54;
  @override
  int get coreType => StateMachineComponentBase.typeKey;
  @override
  Set<int> get coreTypes => {StateMachineComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Name field with key 138.
  static const int namePropertyKey = 138;
  static const String nameInitialValue = '';
  String _name = nameInitialValue;

  /// Non-unique identifier, used to give friendly names to state machine
  /// components (like layers or inputs).
  String get name => _name;

  /// Change the [_name] field value.
  /// [nameChanged] will be invoked only if the field's value has changed.
  set name(String value) {
    if (_name == value) {
      return;
    }
    String from = _name;
    _name = value;
    if (hasValidated) {
      nameChanged(from, value);
    }
  }

  void nameChanged(String from, String to);

  @override
  void copy(Core source) {
    if (source is StateMachineComponentBase) {
      _name = source._name;
    }
  }
}
