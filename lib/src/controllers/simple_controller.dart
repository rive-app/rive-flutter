import 'package:rive/src/extensions.dart';
import 'package:rive/src/rive_core/animation/linear_animation_instance.dart';
import 'package:rive/src/rive_core/rive_animation_controller.dart';
import 'package:rive/src/runtime_artboard.dart';

/// A simple [RiveAnimationController] that plays back a LinearAnimation defined
/// by an artist. All playback parameters (looping, speed, keyframes) are artist
/// defined in the Rive editor. This takes a declaritive approach of using an
/// [animationName] as the only requirement for resolving the animation. When
/// the controller is added to an artboard (note that due to widget lifecycles
/// it could get re-initialized on another artboard later) it'll look for the
/// animation. Not finding the animation is a condition this example deals with
/// by simply nulling the [AnimationInstance] _instance which means it won't be
/// applied during advance cycles. Another approach would be let this throw, but
/// this one is a little more forgiving which can be desireable with files
/// dynamically loaded (downloaded even) at runtime.
class SimpleAnimation extends RiveAnimationController<RuntimeArtboard> {
  LinearAnimationInstance? _instance;

  /// Animation name
  final String animationName;

  /// Pauses the animation when it's created
  final bool autoplay;

  /// Mix value for the animation, value between 0 and 1
  double _mix;

  // Controls the level of mix for the animation, clamped between 0 and 1
  SimpleAnimation(this.animationName, {double mix = 1, this.autoplay = true})
      : _mix = mix.clamp(0, 1).toDouble();
  LinearAnimationInstance? get instance => _instance;
  double get mix => _mix;

  set mix(double value) => _mix = value.clamp(0, 1).toDouble();

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    if (_instance == null || !_instance!.keepGoing) {
      isActive = false;
    }

    // We apply before advancing. So we want to stop rendering only once the
    // last advanced frame has been applied. This means knowing when the last
    // frame is advanced, ensuring the next apply happens, and then finally
    // stopping playback. We do this with keepGoing as this will be true of a
    // one-shot has passed its stop time. Fixes #28 and should help with issues
    // #51 and #56.
    _instance!
      ..animation.apply(_instance!.time, coreContext: artboard, mix: mix)
      ..advance(elapsedSeconds);
  }

  @override
  bool init(RuntimeArtboard artboard) {
    _instance = artboard.animationByName(animationName);
    isActive = autoplay;
    return _instance != null;
  }

  /// Resets the animation back to it's starting time position
  void reset() => _instance?.reset();
}
