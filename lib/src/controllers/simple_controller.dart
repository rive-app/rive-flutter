import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/linear_animation_instance.dart';
import 'package:rive/src/rive_core/rive_animation_controller.dart';
import 'package:rive/src/runtime_artboard.dart';

/// A simple [RiveAnimationController] that plays back a LinearAnimation defined
/// by an artist. All playback parameters (looping, speed, keyframes) are artist
/// defined in the Rive editor.
class SimpleAnimation extends RiveAnimationController<RuntimeArtboard> {
  SimpleAnimation(this.animationName, {double mix})
      : _mix = mix?.clamp(0, 1)?.toDouble() ?? 1.0;

  LinearAnimationInstance _instance;
  final String animationName;
  bool _stopOnNextApply = false;

  // Controls the level of mix for the animation, clamped between 0 and 1
  double _mix;
  double get mix => _mix;
  set mix(double value) => _mix = value?.clamp(0, 1)?.toDouble() ?? 1;

  LinearAnimationInstance get instance => _instance;

  @override
  bool init(RuntimeArtboard artboard) {
    var animation = artboard.animations.firstWhere(
      (animation) =>
          animation is LinearAnimation && animation.name == animationName,
      orElse: () => null,
    );
    if (animation != null) {
      _instance = LinearAnimationInstance(animation as LinearAnimation);
    }
    isActive = true;
    return _instance != null;
  }

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    if (_stopOnNextApply) {
      isActive = false;
    }

    // We apply before advancing. So we want to stop rendering only once the
    // last advanced frame has been applied. This means tracking when the last
    // frame is advanced, ensuring the next apply happens, and then finally
    // stopping playback. We do this by tracking _stopOnNextApply making sure to
    // reset it when the controller is re-activated. Fixes #28 and should help
    // with issues #51 and #56.
    _instance.animation.apply(_instance.time, coreContext: artboard, mix: mix);
    if (!_instance.advance(elapsedSeconds)) {
      _stopOnNextApply = true;
    }
  }

  @override
  void onActivate() {
    // We override onActivate to reset stopOnNextApply. This ensures that when
    // the controller is re-activated after stopping, it doesn't prematurely
    // stop itself.
    _stopOnNextApply = false;
  }
}
