// ignore_for_file: lines_longer_than_80_chars

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/loop.dart';
import 'package:rive/src/rive_core/event.dart';

class LinearAnimationInstance {
  final LinearAnimation animation;
  final int _speedDirection;

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

  LinearAnimationInstance(this.animation, {double speedMultiplier = 1.0})
      : _time =
            (speedMultiplier >= 0) ? animation.startTime : animation.endTime,
        _speedDirection = (speedMultiplier >= 0) ? 1 : -1;

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
  set direction(int value) => _direction = value == -1 ? -1 : 1;

  /// Returns the animation's play direction: 1 for forwards, -1 for backwards
  int get direction => _direction;

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
      (animation.loop_??animation.loop) != Loop.oneShot ||
      (directedSpeed > 0 && _time < animation.endSeconds) ||
      (directedSpeed < 0 && _time > animation.startSeconds);

  // We estimate whether the animation should keep playing using the speed
  // multiplier provided by the caller
  bool shouldKeepGoing(double speedMultiplier) {
    return (animation.loop_??animation.loop) != Loop.oneShot ||
        (speedMultiplier * directedSpeed > 0 && _time < animation.endSeconds) ||
        (speedMultiplier * directedSpeed < 0 && _time > animation.startSeconds);
  }

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
    _spilledTime = 0;

    var loop = animation.loop_??animation.loop;

    // NOTE:
    // do not track spilled time, if our one shot loop is already completed.
    // stop gap before we move spilled tracking into state machine logic.
    var dontKeepGoing = !keepGoing;

    // TODO review this
    if (loop == Loop.oneShot) {
      if (dontKeepGoing) {
        _didLoop = true;
        return false;
      // } else {
      //   // TODO review animation speed and direction for oneShot
      //   FrequencyPrinter.print(frequency: 500, () => 'oneShot > ${animation.name} '
      //       '${animation.speed} $_direction > ${animation.duration}');
      }
    }

    final absSeconds = elapsedSeconds * animation.speed_;
    if (absSeconds == 0) {
      _didLoop = false;
      return true;
    }

    int direction = _direction;
    final double deltaSeconds;
    if (_direction == 1) {
      deltaSeconds = absSeconds;
    } else {
      deltaSeconds = absSeconds * direction;
    }

    _lastTotalTime = _totalTime;
    _totalTime += absSeconds;

    var lastTime = _time;
    _time += deltaSeconds;

    if (callbackReporter != null) {
      animation.reportKeyedCallbacks(
        lastTime,
        _time,
        reporter: callbackReporter,
        speedDirection: _speedDirection,
      );
    }

    var fps = animation.fps_;
    var frames = _time * fps;

    final int start;
    final int end;
    final int range;
    if (animation.enableWorkArea_) {
      start = animation.workStart_;
      end = animation.workEnd_;
      range = end - start;
    } else {
      start = 0;
      end = animation.duration_;
      range = end;
    }

    // var didLoop = false;

    // var direction = deltaSeconds < 0 ? -1 : 1;
    switch (loop) {
      case Loop.oneShot:

        if (direction == 1 && frames > end) {

          // Account for the time dilation or contraction applied in the
          // animation local time by its speed to calculate spilled time.
          // Calculate the ratio of the time excess by the total elapsed
          // time in local time (deltaFrames) and multiply the elapsed time
          // by it.

          if (!dontKeepGoing) {
            final deltaFrames = deltaSeconds * fps;
            final spilledFramesRatio = (frames - end) / deltaFrames;
            _spilledTime = spilledFramesRatio * elapsedSeconds;
          }

          _time = end.toDouble() / fps;
          _didLoop = true;

        } else if (direction == -1 && frames < start) {

          if (!dontKeepGoing) {
            final deltaFrames = (deltaSeconds * fps).abs();
            final spilledFramesRatio = (start - frames) / deltaFrames;
            _spilledTime = spilledFramesRatio * elapsedSeconds;
          }

          // frames = start.toDouble();
          _time = start.toDouble() / fps;
          _didLoop = true;
        }
        break;

      case Loop.loop:
        if (direction == 1 && frames >= end) {
          // How spilled time has to be calculated, given that local time can be scaled
          // to a factor of the regular time:
          // - for convenience, calculate the local elapsed time in frames (deltaFrames)
          // - get the remainder of current frame position (frames) by duration (range)
          // - use that remainder as the ratio of the original time that was not consumed
          // by the loop (spilledFramesRatio)
          // - multiply the original elapsedTime by the ratio to set the spilled time

          final remainder = (frames - start) % range;

          if (!dontKeepGoing) {
            final deltaFrames = deltaSeconds * fps;
            final spilledFramesRatio = remainder / deltaFrames;
            _spilledTime = spilledFramesRatio * elapsedSeconds;
          }

          frames = start + remainder;
          lastTime = 0;
          _time = frames / fps;
          if (callbackReporter != null) {
            animation.reportKeyedCallbacks(
              lastTime,
              _time,
              reporter: callbackReporter,
              speedDirection: _speedDirection,
            );
          }
          _didLoop = true;
        } else if (direction == -1 && frames <= start) {

          final remainder = (start - frames) % range;

          if (!dontKeepGoing) {
            final deltaFrames = deltaSeconds * fps;
            final spilledFramesRatio = (remainder / deltaFrames).abs();
            _spilledTime = spilledFramesRatio * elapsedSeconds;
          }

          frames = end - remainder;
          lastTime = end / fps;
          _time = frames / fps;
          if (callbackReporter != null) {
            animation.reportKeyedCallbacks(
              lastTime,
              _time,
              reporter: callbackReporter,
              speedDirection: _speedDirection,
            );
          }
          _didLoop = true;
        }
        break;

      case Loop.pingPong:
        // ignore: literal_only_boolean_expressions
        // In ping-pong we only want to report callbacks once per side
        bool fromPong = true;
        while (true) {
          if (direction == 1 && frames >= end) {
            _spilledTime = (frames - end) / animation.fps;
            lastTime = end / fps;
            frames = end + (end - frames);
          } else if (direction == -1 && frames < start) {
            _spilledTime = (start - frames) / animation.fps;
            lastTime = start / fps;
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
          _didLoop = true;
          if (callbackReporter != null) {
            animation.reportKeyedCallbacks(
              lastTime,
              _time,
              reporter: callbackReporter,
              speedDirection: _speedDirection,
              fromPong: fromPong,
            );
          }
          fromPong = !fromPong;
        }
        break;
    }

    // if (dontKeepGoing) {
    //   _spilledTime = 0;
    // }

    // _didLoop = didLoop;
    return keepGoing;
  }

  // Used by runtime to report events from linear animations in nested artboards
  // when not played in state machine
  void reportEvent(Event event) {}
}
