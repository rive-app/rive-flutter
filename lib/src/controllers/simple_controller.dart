import 'package:rive/src/rive_core/animation/linear_animation_instance.dart';
import 'package:rive/src/rive_core/rive_animation_controller.dart';
import 'package:rive/src/runtime_artboard.dart';

/// A simple [RiveAnimationController] that plays back a LinearAnimation defined
/// by an artist. All playback parameters (looping, speed, keyframes) are artist
/// defined in the Rive editor.
class SimpleAnimation extends RiveAnimationController<RuntimeArtboard> {
  LinearAnimationInstance _instance;
  final String animationName;
  SimpleAnimation(this.animationName);

  LinearAnimationInstance get instance => _instance;

  @override
  bool init(RuntimeArtboard artboard) {
    _instance = artboard.animationByName(animationName);
    isActive = true;
    return _instance != null;
  }

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    _instance.animation.apply(_instance.time, coreContext: artboard);
    if (!_instance.advance(elapsedSeconds)) {
      isActive = false;
    }
  }
}
