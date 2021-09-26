import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/loop.dart';

class LinearAnimationInstance {
  final LinearAnimation animation;

  double _time = 0;
  double _lastTime = 0;
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
                animation.fps {
    _lastTime = _time;
  }

  /// Note that when time is set, the direction will be changed to 1
  set time(double value) {
    if (_time == value) {
      return;
    }
    // Make sure to keep last and total in relative lockstep so state machines
    // can track change even when setting time.
    var diff = _totalTime - _lastTotalTime;
    _lastTime = _time = _totalTime = value;
    _lastTotalTime = _totalTime - diff;
    _direction = 1;
  }

  /// Returns the current time position of the animation in seconds
  double get time => _time;

  /// Returns the time the position was at when the previous advance was called.
  double get lastTime => _lastTime;

  /// Direction should only be +1 or -1
  set direction(int value) => _direction = value == -1 ? -1 : 1;

  /// Returns the animation's play direction: 1 for forwards, -1 for backwards
  int get direction => _direction;

  double get progress =>
      (_time - animation.startTime) / (animation.endTime - animation.startTime);

  /// Resets the animation to the starting frame
  void reset() => _time = animation.startTime;

  /// Whether the controller driving this animation should keep requesting
  /// frames be drawn.
  bool get keepGoing => animation.loop != Loop.oneShot || !_didLoop;

  /// Apply the changes incurred during advance, also automatically fires any
  /// accrued events.
  void apply(CoreContext core, {double mix = 1}) {
    animation.apply(time, coreContext: core, mix: mix);
  }

  bool advance(double elapsedSeconds) {
    var deltaSeconds = elapsedSeconds * animation.speed * _direction;
    _lastTotalTime = _totalTime;
    _totalTime += deltaSeconds;
    _lastTime = _time;
    _time += deltaSeconds;

    double frames = _time * animation.fps;
    var fps = animation.fps;

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
          _spilledTime = (frames - end) / fps;
          frames = end.toDouble();
          _time = frames / fps;
          _didLoop = true;
        }
        break;
      case Loop.loop:
        if (frames >= end) {
          _spilledTime = (frames - end) / fps;
          frames = _time * fps;
          frames = start + (frames - start) % range;
          _time = frames / fps;
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
          _lastTime = _time;
        }
        break;
    }
    return keepGoing;
  }
}
