import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/loop.dart';

class LinearAnimationInstance {
  final LinearAnimation animation;

  double _time = 0;
  double _totalTime = 0;
  double _lastTotalTime = 0;
  double _direction = 1;
  bool _didLoop = false;
  bool get didLoop => _didLoop;
  double _spilledTime = 0;
  double get spilledTime => _spilledTime;

  double get totalTime => _totalTime;
  double get lastTotalTime => _lastTotalTime;

  LinearAnimationInstance(this.animation, {double speedMultiplier = 1.0})
      : _time =
            (speedMultiplier >= 0) ? animation.startTime : animation.endTime;

  /// NOTE: that when time is set, the direction will be changed to 1
  set time(double value) {
    if (_time == value) {
      return;
    }

    // Make sure to keep last and total in relative lockstep so state machines
    // can track change even when setting time.
    var diff = _totalTime - _lastTotalTime;
    _time = _totalTime = value;
    _lastTotalTime = _totalTime - diff;

    // NOTE: will cause ping-pongs to get reset if "seeking"
    _direction = 1;
  }

  /// Returns the current time position of the animation in seconds
  double get time => _time;

  /// Direction should only be +1 or -1
  set direction(double value) => _direction = value == -1 ? -1 : 1;

  /// Returns the animation's play direction: 1 for forwards, -1 for backwards
  double get direction => _direction;

  double get directedSpeed => animation.speed * _direction;

  double get progress =>
      (_time - animation.startTime).abs() /
      (animation.endTime - animation.startTime).abs();

  /// Resets the animation to the starting frame
  void reset({double speedMultiplier = 1}) =>
      _time = (speedMultiplier >= 0) ? animation.startTime : animation.endTime;

  /// Whether the controller driving this animation should keep requesting
  /// frames be drawn.
  bool get keepGoing =>
      animation.loop != Loop.oneShot ||
      (directedSpeed > 0 && _time < animation.endSeconds) ||
      (directedSpeed < 0 && _time > animation.startSeconds);

  /// Apply the changes incurred during advance, also automatically fires any
  /// accrued events.
  void apply(CoreContext core, {double mix = 1}) {
    animation.apply(time, coreContext: core, mix: mix);
  }

  void clearSpilledTime() {
    _spilledTime = 0;
  }

  bool advance(double elapsedSeconds,
      {KeyedCallbackReporter? callbackReporter}) {
    var deltaSeconds = elapsedSeconds * animation.speed * _direction;
    _spilledTime = 0;

    if (deltaSeconds == 0) {
      _didLoop = false;
      return true;
    }
    _lastTotalTime = _totalTime;
    _totalTime += deltaSeconds.abs();

    // NOTE:
    // do not track spilled time, if our one shot loop is already completed.
    // stop gap before we move spilled tracking into state machine logic.
    var killSpilledTime = !keepGoing;

    var lastTime = _time;
    _time += deltaSeconds;

    if (callbackReporter != null) {
      animation.reportKeyedCallbacks(
        lastTime,
        _time,
        reporter: callbackReporter,
      );
    }

    var fps = animation.fps;
    double frames = _time * fps;

    var start = animation.enableWorkArea ? animation.workStart : 0;
    var end = animation.enableWorkArea ? animation.workEnd : animation.duration;
    var range = end - start;

    bool didLoop = false;

    int direction = deltaSeconds < 0 ? -1 : 1;
    switch (animation.loop) {
      case Loop.oneShot:
        if (direction == 1 && frames > end) {
          _spilledTime = (frames - end) / fps;
          frames = end.toDouble();
          _time = frames / fps;
          didLoop = true;
        } else if (direction == -1 && frames < start) {
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

    if (killSpilledTime) {
      _spilledTime = 0;
    }

    _didLoop = didLoop;
    return keepGoing;
  }
}
