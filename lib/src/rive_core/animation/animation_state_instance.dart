import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/animation_state.dart';
import 'package:rive/src/rive_core/animation/linear_animation_instance.dart';
import 'package:rive/src/rive_core/animation/state_instance.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';

/// Simple wrapper around [LinearAnimationInstance] making it compatible with
/// the [StateMachine]'s [StateInstance] interface.
class AnimationStateInstance extends StateInstance<AnimationState> {
  final LinearAnimationInstance animationInstance;

  @override
  String get ticker {
    var animation = state.animation;
    if (animation == null) {
      return 'AnimationStateInstance[]';
    }

    return '${animation.name}['
      '${animation.loop.name},'
      '${animation.keyedObjects.length},'
      '${animation.enableWorkArea ? '${animation.workStart}:${animation.workEnd}' : '${animation.duration}'}'
      ']';
  }

  AnimationStateInstance(AnimationState state)
      : assert(state.animation != null),
        animationInstance = LinearAnimationInstance(
          state.animation!,
          speedMultiplier: state.speed,
        ),
        super(state);

  @override
  bool advance(double seconds, StateMachineController controller) {

    final double secs;
    if (state.speed == 1) {
      secs = seconds;
    } else {
      secs = seconds * state.speed;
    }

    return animationInstance.advance(
      secs,
      callbackReporter: controller,
    );
  }

  @override
  void apply(CoreContext core, double mix) => animationInstance.animation
      .apply(animationInstance.time, coreContext: core, mix: mix);

  @override
  bool get keepGoing => animationInstance.shouldKeepGoing(state.speed);

  @override
  void clearSpilledTime() => animationInstance.clearSpilledTime();
}
