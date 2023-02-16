import 'package:rive/src/core/core.dart';
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

    if (deltaSeconds == 0) {
      // we say keep going, if you advance by 0.
      // could argue that any further advances by 0 result in nothing so you should not keep going
      // could argue its saying, we are not at the end of the animation yet, so keep going
      // our runtimes currently expect the latter, so we say keep going!
      _didLoop = false;
      return true;
    }
    _lastTotalTime = _totalTime;
    _totalTime += deltaSeconds.abs();
    _time += deltaSeconds;

    var fps = animation.fps;
    double frames = _time * fps;

    var start = animation.enableWorkArea ? animation.workStart : 0;
    var end = animation.enableWorkArea ? animation.workEnd : animation.duration;
    var range = end - start;

    bool keepGoing = true;
    bool didLoop = false;
    _spilledTime = 0;

    int direction = deltaSeconds < 0 ? -1 : 1;
    switch (animation.loop) {
      case Loop.oneShot:
        if (direction == 1 && frames > end) {
          keepGoing = false;
          _spilledTime = (frames - end) / fps;
          frames = end.toDouble();
          _time = frames / fps;
          didLoop = true;
        } else if (direction == -1 && frames < start) {
          keepGoing = false;
          _spilledTime = (start - frames) / fps;
          frames = start.toDouble();
          _time = frames / fps;
          didLoop = true;
        }
        break;
      case Loop.loop:
        if (direction == 1 && frames >= end) {
          _spilledTime = (frames - end) / fps;
          frames = _time * fps;
          frames = start + (frames - start) % range;
          _time = frames / fps;
          didLoop = true;
        } else if (direction == -1 && frames <= start) {
          _spilledTime = (start - frames) / fps;
          frames = _time * fps;
          frames = end - (start - frames) % range;
          _time = frames / fps;
          didLoop = true;
        }
        break;
      case Loop.pingPong:
        // ignore: literal_only_boolean_expressions
        while (true) {
          if (direction == 1 && frames >= end) {
            _spilledTime = (frames - end) / animation.fps;
            frames = end + (end - frames);
          } else if (direction == -1 && frames < start) {
            _spilledTime = (start - frames) / animation.fps;
            frames = start + (start - frames);
          } else {
            // we're within the range, we can stop fixing. We do this in a
            // loop to fix conditions when time has advanced so far that we've
            // ping-ponged back and forth a few times in a single frame. We
            // want to accomodate for this in cases where animations are not
            // advanced on regular intervals.
            break;
          }
          _time = frames / animation.fps;
          _direction *= -1;
          direction *= -1;
          didLoop = true;
        }
        break;
    }
    _didLoop = didLoop;
    return keepGoing;
  }
}
