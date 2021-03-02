/// Core automatically generated
/// lib/src/generated/animation/animation_state_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/animation/layer_state_base.dart';
import 'package:rive/src/generated/animation/state_machine_layer_component_base.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';

abstract class AnimationStateBase extends LayerState {
  static const int typeKey = 61;
  @override
  int get coreType => AnimationStateBase.typeKey;
  @override
  Set<int> get coreTypes => {
        AnimationStateBase.typeKey,
        LayerStateBase.typeKey,
        StateMachineLayerComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// AnimationId field with key 149.
  int _animationId;
  static const int animationIdPropertyKey = 149;

  /// Id of the animation this layer state refers to.
  int get animationId => _animationId;

  /// Change the [_animationId] field value.
  /// [animationIdChanged] will be invoked only if the field's value has
  /// changed.
  set animationId(int value) {
    if (_animationId == value) {
      return;
    }
    int from = _animationId;
    _animationId = value;
    animationIdChanged(from, value);
  }

  void animationIdChanged(int from, int to);
}
