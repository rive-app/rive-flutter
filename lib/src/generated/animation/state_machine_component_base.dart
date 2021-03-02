/// Core automatically generated
/// lib/src/generated/animation/state_machine_component_base.dart.
/// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class StateMachineComponentBase<T extends CoreContext>
    extends Core<T> {
  static const int typeKey = 54;
  @override
  int get coreType => StateMachineComponentBase.typeKey;
  @override
  Set<int> get coreTypes => {StateMachineComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// MachineId field with key 137.
  int _machineId;
  static const int machineIdPropertyKey = 137;

  /// Id of the state machine this component belongs to.
  int get machineId => _machineId;

  /// Change the [_machineId] field value.
  /// [machineIdChanged] will be invoked only if the field's value has changed.
  set machineId(int value) {
    if (_machineId == value) {
      return;
    }
    int from = _machineId;
    _machineId = value;
    machineIdChanged(from, value);
  }

  void machineIdChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// Name field with key 138.
  String _name;
  static const int namePropertyKey = 138;

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
    nameChanged(from, value);
  }

  void nameChanged(String from, String to);
}
