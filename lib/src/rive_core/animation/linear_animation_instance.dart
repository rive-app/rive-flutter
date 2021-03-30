import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/loop.dart';

class LinearAnimationInstance {
  final LinearAnimation animation;
  double _time = 0;
  int _direction = 1;
  bool _didLoop = false;
  bool get didLoop => _didLoop;
  double _spilledTime = 0;
  double get spilledTime => _spilledTime;
  LinearAnimationInstance(this.animation)
      : _time =
            (animation.enableWorkArea ? animation.workStart : 0).toDouble() /
                animation.fps;
  set time(double value) {
    if (_time == value) {
      return;
    }
    _time = value;
    _direction = 1;
  }

  double get time => _time;
  set direction(int value) => _direction = value == -1 ? -1 : 1;
  int get direction => _direction;
  double get endTime =>
      (animation.enableWorkArea ? animation.workEnd : animation.duration)
          .toDouble() /
      animation.fps;
  double get startTime =>
      (animation.enableWorkArea ? animation.workStart : 0).toDouble() /
      animation.fps;
  double get progress => (_time - startTime) / (endTime - startTime);
  void reset() => _time = startTime;
  bool get keepGoing => animation.loop != Loop.oneShot || !_didLoop;
  bool advance(double elapsedSeconds) {
    _time += elapsedSeconds * animation.speed * _direction;
    double frames = _time * animation.fps;
    var start = animation.enableWorkArea ? animation.workStart : 0;
    var end = animation.enableWorkArea ? animation.workEnd : animation.duration;
    var range = end - start;
    bool keepGoing = true;
    _didLoop = false;
    _spilledTime = 0;
    switch (animation.loop) {
      case Loop.oneShot:
        if (frames > end) {
          keepGoing = false;
          _spilledTime = (frames - end) / animation.fps;
          frames = end.toDouble();
          _time = frames / animation.fps;
          _didLoop = true;
        }
        break;
      case Loop.loop:
        if (frames >= end) {
          _spilledTime = (frames - end) / animation.fps;
          frames = _time * animation.fps;
          frames = start + (frames - start) % range;
          _time = frames / animation.fps;
          _didLoop = true;
        }
        break;
      case Loop.pingPong:
        while (true) {
          if (_direction == 1 && frames >= end) {
            _spilledTime = (frames - end) / animation.fps;
            _direction = -1;
            frames = end + (end - frames);
            _time = frames / animation.fps;
            _didLoop = true;
          } else if (_direction == -1 && frames < start) {
            _spilledTime = (start - frames) / animation.fps;
            _direction = 1;
            frames = start + (start - frames);
            _time = frames / animation.fps;
            _didLoop = true;
          } else {
            break;
          }
        }
        break;
    }
    return keepGoing;
  }
}
