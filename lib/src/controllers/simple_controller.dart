import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/loop.dart';
import 'package:rive/src/rive_core/rive_animation_controller.dart';
import 'package:rive/src/runtime_artboard.dart';

/// A simple [RiveAnimationController] that plays back a LinearAnimation defined
/// by an artist. All playback parameters (looping, speed, keyframes) are artist
/// defined in the Rive editor.
class SimpleAnimation extends RiveAnimationController<RuntimeArtboard> {
  LinearAnimation _animation;
  double _time = 0;
  int _direction = 1;
  final String animationName;
  SimpleAnimation(this.animationName);

  @override
  bool init(RuntimeArtboard artboard) {
    _animation = artboard.animations.firstWhere(
      (animation) => animation.name == animationName,
      orElse: () => null,
    ) as LinearAnimation;
    isActive = true;
    return _animation != null;
  }

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    _animation.apply(_time, coreContext: artboard);
    _time += elapsedSeconds * _animation.speed * _direction;

    double frames = _time * _animation.fps;

    var start = _animation.enableWorkArea ? _animation.workStart : 0;
    var end =
        _animation.enableWorkArea ? _animation.workEnd : _animation.duration;
    var range = end - start;

    switch (_animation.loop) {
      case Loop.oneShot:
        if (frames > end) {
          isActive = false;
          frames = end.toDouble();
          _time = frames / _animation.fps;
        }
        break;
      case Loop.loop:
        if (frames >= end) {
          frames = _time * _animation.fps;
          frames = start + (frames - start) % range;
          _time = frames / _animation.fps;
        }
        break;
      case Loop.pingPong:
        // ignore: literal_only_boolean_expressions
        while (true) {
          if (_direction == 1 && frames >= end) {
            _direction = -1;
            frames = end + (end - frames);
            _time = frames / _animation.fps;
          } else if (_direction == -1 && frames < start) {
            _direction = 1;
            frames = start + (start - frames);
            _time = frames / _animation.fps;
          } else {
            // we're within the range, we can stop fixing. We do this in a
            // loop to fix conditions when time has advanced so far that we've
            // ping-ponged back and forth a few times in a single frame. We
            // want to accomodate for this in cases where animations are not
            // advanced on regular intervals.
            break;
          }
        }
        break;
    }
  }

  @override
  void dispose() {}

  @override
  void onActivate() {}

  @override
  void onDeactivate() {}
}
