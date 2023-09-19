import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/blend_animation.dart';
import 'package:rive/src/rive_core/animation/blend_state.dart';
import 'package:rive/src/rive_core/animation/linear_animation_instance.dart';
import 'package:rive/src/rive_core/animation/state_instance.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';

/// Individual animation in a blend state instance.
class BlendStateAnimationInstance<T extends BlendAnimation> {
  final T blendAnimation;
  final LinearAnimationInstance animationInstance;
  double mix = 0;

  BlendStateAnimationInstance(this.blendAnimation)
      : animationInstance = LinearAnimationInstance(blendAnimation.animation!);
}

/// Generic blend state instance which works for [BlendState<BlendAnimation>]s
/// where T represents the BlendState and K the BlendAnimation.
abstract class BlendStateInstance<T extends BlendState<K>,
    K extends BlendAnimation> extends StateInstance {
  final List<BlendStateAnimationInstance<K>> animationInstances;
  BlendStateInstance(T state)
      : animationInstances = state.animations
            .where((animation) => animation.animation != null)
            .map((animation) => BlendStateAnimationInstance(animation))
            .toList(growable: false),
        super(state);

  @override
  bool get keepGoing => true;

  @mustCallSuper
  @override
  void advance(double seconds, StateMachineController controller) {
    // Advance all the animations in the blend state
    // NOTE: we are intentionally ignoring the animationInstances' keepGoing
    // return value.
    // Blend states need to keep blending forever, as even if the animation
    // does not change the mix values may
    for (final animation in animationInstances) {
      if (animation.animationInstance.keepGoing) {
        // Should animations with m_Mix == 0.0 advance? They will trigger events
        // and the event properties (if any) will not be updated by
        // animationInstance.apply.
        animation.animationInstance.advance(
          seconds,
          callbackReporter: controller,
        );
      }
    }
  }

  @override
  void apply(CoreContext core, double mix) {
    for (final animation in animationInstances) {
      double m = mix * animation.mix;
      if (m == 0) {
        continue;
      }
      animation.animationInstance.animation
          .apply(animation.animationInstance.time, coreContext: core, mix: m);
    }
  }
}
