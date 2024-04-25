// Core automatically generated
// lib/src/generated/animation/layer_state_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/state_machine_layer_component.dart';

abstract class LayerStateBase extends StateMachineLayerComponent {
  static const int typeKey = 60;
  @override
  int get coreType => LayerStateBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {LayerStateBase.typeKey, StateMachineLayerComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Flags field with key 536.
  static const int flagsPropertyKey = 536;
  static const int flagsInitialValue = 0;
  int _flags = flagsInitialValue;
  int get flags => _flags;

  /// Change the [_flags] field value.
  /// [flagsChanged] will be invoked only if the field's value has changed.
  set flags(int value) {
    if (_flags == value) {
      return;
    }
    int from = _flags;
    _flags = value;
    if (hasValidated) {
      flagsChanged(from, value);
    }
  }

  void flagsChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is LayerStateBase) {
      _flags = source._flags;
    }
  }
}
