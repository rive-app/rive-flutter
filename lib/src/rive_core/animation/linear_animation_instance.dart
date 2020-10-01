import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/loop.dart';

class LinearAnimationInstance {
  final LinearAnimation animation;
  double _time = 0;
  int direction = 1;

  LinearAnimationInstance(this.animation)
      : _time =
            (animation.enableWorkArea ? animation.workStart : 0).toDouble() /
                animation.fps;

  double get time => _time;
  set time(double value) {
    if (_time == value) {
      return;
    }
    _time = value;
    direction = 1;
  }

  bool advance(double elapsedSeconds) {
    _time += elapsedSeconds * animation.speed * direction;
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
          if (direction == 1 && frames >= end) {
            direction = -1;
            frames = end + (end - frames);
            _time = frames / animation.fps;
          } else if (direction == -1 && frames < start) {
            direction = 1;
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
