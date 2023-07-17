// Core automatically generated
// lib/src/generated/animation/advanceable_state_base.dart.
// Do not modify manually.

import 'package:rive/src/generated/animation/state_machine_layer_component_base.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';

abstract class AdvanceableStateBase extends LayerState {
  static const int typeKey = 145;
  @override
  int get coreType => AdvanceableStateBase.typeKey;
  @override
  Set<int> get coreTypes => {
        AdvanceableStateBase.typeKey,
        LayerStateBase.typeKey,
        StateMachineLayerComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Speed field with key 292.
  static const double speedInitialValue = 1;
  double _speed = speedInitialValue;
  static const int speedPropertyKey = 292;
  double get speed => _speed;

  /// Change the [_speed] field value.
  /// [speedChanged] will be invoked only if the field's value has changed.
  set speed(double value) {
    if (_speed == value) {
      return;
    }
    double from = _speed;
    _speed = value;
    if (hasValidated) {
      speedChanged(from, value);
    }
  }

  void speedChanged(double from, double to);

  @override
  void copy(covariant AdvanceableStateBase source) {
    super.copy(source);
    _speed = source._speed;
  }
}
