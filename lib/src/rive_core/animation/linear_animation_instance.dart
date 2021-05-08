import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/loop.dart';

class LinearAnimationInstance {
  final LinearAnimation animation;
  double _time = 0;
  double _totalTime = 0;
  double _lastTotalTime = 0;
  int _direction = 1;
  bool _didLoop = false;
  bool get didLoop => _didLoop;
  double _spilledTime = 0;
  double get spilledTime => _spilledTime;

  double get totalTime => _totalTime;
  double get lastTotalTime => _lastTotalTime;

  LinearAnimationInstance(this.animation)
      : _time =
            (animation.enableWorkArea ? animation.workStart : 0).toDouble() /
                animation.fps;

  /// Note that when time is set, the direction will be changed to 1
  set time(double value) {
    if (_time == value) {
      return;
    }
    // Make sure to keep last and total in relative lockstep so state machines
    // can track change even when setting time.
    var diff = _totalTime - _lastTotalTime;
    _time = _totalTime = value;
    _lastTotalTime = _totalTime - diff;
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

  double get progress => (_time - startTime) / (endTime - startTime);

  /// Resets the animation to the starting frame
  void reset() => _time = startTime;

  /// Whether the controller driving this animation should keep requesting
  /// frames be drawn.
  bool get keepGoing => animation.loop != Loop.oneShot || !_didLoop;

  bool advance(double elapsedSeconds) {
    var deltaSeconds = elapsedSeconds * animation.speed * _direction;
    _lastTotalTime = _totalTime;
    _totalTime += deltaSeconds;
    _time += deltaSeconds;

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
        // ignore: literal_only_boolean_expressions
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
    return keepGoing;
  }
}
