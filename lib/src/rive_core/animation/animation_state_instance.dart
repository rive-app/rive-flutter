import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/animation_state.dart';
import 'package:rive/src/rive_core/animation/linear_animation_instance.dart';
import 'package:rive/src/rive_core/animation/state_instance.dart';

/// Simple wrapper around [LinearAnimationInstance] making it compatible with
/// the [StateMachine]'s [StateInstance] interface.
class AnimationStateInstance extends StateInstance {
  final LinearAnimationInstance animationInstance;

  AnimationStateInstance(AnimationState state)
      : assert(state.animation != null),
        animationInstance = LinearAnimationInstance(state.animation!),
        super(state);

  @override
  void advance(double seconds, _) => animationInstance.advance(seconds);

  @override
  void apply(CoreContext core, double mix) => animationInstance.animation
      .apply(animationInstance.time, coreContext: core, mix: mix);

  @override
  bool get keepGoing => animationInstance.keepGoing;
}
