/// Core automatically generated
/// lib/src/generated/animation/blend_state_1d_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/animation/layer_state_base.dart';
import 'package:rive/src/generated/animation/state_machine_layer_component_base.dart';
import 'package:rive/src/rive_core/animation/blend_animation_1d.dart';
import 'package:rive/src/rive_core/animation/blend_state.dart';

abstract class BlendState1DBase extends BlendState<BlendAnimation1D> {
  static const int typeKey = 76;
  @override
  int get coreType => BlendState1DBase.typeKey;
  @override
  Set<int> get coreTypes => {
        BlendState1DBase.typeKey,
        BlendStateBase.typeKey,
        LayerStateBase.typeKey,
        StateMachineLayerComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// InputId field with key 167.
  static const int inputIdInitialValue = -1;
  int _inputId = inputIdInitialValue;
  static const int inputIdPropertyKey = 167;

  /// Id of the input that drives the mix value for this blend state.
  int get inputId => _inputId;

  /// Change the [_inputId] field value.
  /// [inputIdChanged] will be invoked only if the field's value has changed.
  set inputId(int value) {
    if (_inputId == value) {
      return;
    }
    int from = _inputId;
    _inputId = value;
    if (hasValidated) {
      inputIdChanged(from, value);
    }
  }

  void inputIdChanged(int from, int to);

  @override
  void copy(covariant BlendState1DBase source) {
    super.copy(source);
    _inputId = source._inputId;
  }
}
