import 'package:rive/src/generated/animation/blend_state_transition_base.dart';
import 'package:rive/src/rive_core/animation/blend_animation.dart';
import 'package:rive/src/rive_core/animation/blend_state_instance.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/linear_animation_instance.dart';
import 'package:rive/src/rive_core/animation/state_instance.dart';

export 'package:rive/src/generated/animation/blend_state_transition_base.dart';

class BlendStateTransition extends BlendStateTransitionBase {
  BlendAnimation? exitBlendAnimation;

  @override
  LinearAnimationInstance? exitTimeAnimationInstance(StateInstance stateFrom) {
    if (stateFrom is BlendStateInstance) {
      for (final blendAnimation in stateFrom.animationInstances) {
        if (blendAnimation.blendAnimation == exitBlendAnimation) {
          return blendAnimation.animationInstance;
        }
      }
    }
    return null;
  }

  @override
  LinearAnimation? exitTimeAnimation(LayerState stateFrom) =>
      exitBlendAnimation?.animation;

  @override
  void exitBlendAnimationIdChanged(int from, int to) {}
}
