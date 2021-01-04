import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/loop.dart';

class LinearAnimationInstance {
  final LinearAnimation animation;
  double _time;
  int _direction = 1;

  LinearAnimationInstance(this.animation)
      : assert(animation != null),
        _time =
            (animation.enableWorkArea ? animation.workStart : 0).toDouble() /
                animation.fps;

  /// Note that when time is set, the direction will be changed to 1
  set time(double value) {
    if (_time == value) {
      return;
    }
    _time = value;
    _direction = 1;
  }

  /// Returns the current time position of the animation in seconds
  double get time => _time;

  /// Direction should only be +1 or -1
  set direction(int value) => _direction = value == -1 ? -1 : 1;

  /// Returns the animation's play direction: 1 for forwards, -1 for backwards
  int get direction => _direction;

  /// Returns the end time of the animation in seconds
  double get endTime =>
      (animation.enableWorkArea ? animation.workEnd : animation.duration)
          .toDouble() /
      animation.fps;

  /// Returns the start time of the animation in seconds
  double get startTime =>
      (animation.enableWorkArea ? animation.workStart : 0).toDouble() /
      animation.fps;

  /// Resets the animation to the starting frame
  void reset() => _time = startTime;

  /// Advances the animation by the time provided
  bool advance(double elapsedSeconds) {
    _time += elapsedSeconds * animation.speed * _direction;
    double frames = _time * animation.fps;
    var start = animation.enableWorkArea ? animation.workStart : 0;
    var end = animation.enableWorkArea ? animation.workEnd : animation.duration;
    var range = end - start;
    bool keepGoing = true;
    switch (animation.loop) {
      case Loop.oneShot:
        if (frames > end) {
          keepGoing = false;
          frames = end.toDouble();
          _time = frames / animation.fps;
        }
        break;
      case Loop.loop:
        if (frames >= end) {
          frames = _time * animation.fps;
          frames = start + (frames - start) % range;
          _time = frames / animation.fps;
        }
        break;
      case Loop.pingPong:
        while (true) {
          if (_direction == 1 && frames >= end) {
            _direction = -1;
            frames = end + (end - frames);
            _time = frames / animation.fps;
          } else if (_direction == -1 && frames < start) {
            _direction = 1;
            frames = start + (start - frames);
            _time = frames / animation.fps;
          } else {
            break;
          }
        }
        break;
    }
    return keepGoing;
  }
}
