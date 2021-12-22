/// Core automatically generated
/// lib/src/generated/animation/blend_state_transition_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/animation/state_machine_layer_component_base.dart';
import 'package:rive/src/rive_core/animation/state_transition.dart';

abstract class BlendStateTransitionBase extends StateTransition {
  static const int typeKey = 78;
  @override
  int get coreType => BlendStateTransitionBase.typeKey;
  @override
  Set<int> get coreTypes => {
        BlendStateTransitionBase.typeKey,
        StateTransitionBase.typeKey,
        StateMachineLayerComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// ExitBlendAnimationId field with key 171.
  static const int exitBlendAnimationIdInitialValue = -1;
  int _exitBlendAnimationId = exitBlendAnimationIdInitialValue;
  static const int exitBlendAnimationIdPropertyKey = 171;

  /// Id of the state the blend state animation used for exit time calculation.
  int get exitBlendAnimationId => _exitBlendAnimationId;

  /// Change the [_exitBlendAnimationId] field value.
  /// [exitBlendAnimationIdChanged] will be invoked only if the field's value
  /// has changed.
  set exitBlendAnimationId(int value) {
    if (_exitBlendAnimationId == value) {
      return;
    }
    int from = _exitBlendAnimationId;
    _exitBlendAnimationId = value;
    if (hasValidated) {
      exitBlendAnimationIdChanged(from, value);
    }
  }

  void exitBlendAnimationIdChanged(int from, int to);

  @override
  void copy(covariant BlendStateTransitionBase source) {
    super.copy(source);
    _exitBlendAnimationId = source._exitBlendAnimationId;
  }
}
