/// Core automatically generated
/// lib/src/generated/animation/linear_animation_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/animation/animation.dart';

abstract class LinearAnimationBase extends Animation {
  static const int typeKey = 31;
  @override
  int get coreType => LinearAnimationBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {LinearAnimationBase.typeKey, AnimationBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Fps field with key 56.
  static const int fpsInitialValue = 60;
  int _fps = fpsInitialValue;
  static const int fpsPropertyKey = 56;

  /// Frames per second used to quantize keyframe times to discrete values that
  /// match this rate.
  int get fps => _fps;

  /// Change the [_fps] field value.
  /// [fpsChanged] will be invoked only if the field's value has changed.
  set fps(int value) {
    if (_fps == value) {
      return;
    }
    int from = _fps;
    _fps = value;
    if (hasValidated) {
      fpsChanged(from, value);
    }
  }

  void fpsChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// Duration field with key 57.
  static const int durationInitialValue = 60;
  int _duration = durationInitialValue;
  static const int durationPropertyKey = 57;

  /// Duration expressed in number of frames.
  int get duration => _duration;

  /// Change the [_duration] field value.
  /// [durationChanged] will be invoked only if the field's value has changed.
  set duration(int value) {
    if (_duration == value) {
      return;
    }
    int from = _duration;
    _duration = value;
    if (hasValidated) {
      durationChanged(from, value);
    }
  }

  void durationChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// Speed field with key 58.
  static const double speedInitialValue = 1;
  double _speed = speedInitialValue;
  static const int speedPropertyKey = 58;

  /// Playback speed multiplier.
  double get speed => _speed;

  /// Change the [_speed] field value.
  /// [speedChanged] will be invoked only if the field's value has changed.
  set speed(double value) {
    if (_speed == value) {
      return;
    }
    double from = _speed;
    _speed = value;
    if (hasValidated) {
      speedChanged(from, value);
    }
  }

  void speedChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// LoopValue field with key 59.
  static const int loopValueInitialValue = 0;
  int _loopValue = loopValueInitialValue;
  static const int loopValuePropertyKey = 59;

  /// Loop value option matches Loop enumeration.
  int get loopValue => _loopValue;

  /// Change the [_loopValue] field value.
  /// [loopValueChanged] will be invoked only if the field's value has changed.
  set loopValue(int value) {
    if (_loopValue == value) {
      return;
    }
    int from = _loopValue;
    _loopValue = value;
    if (hasValidated) {
      loopValueChanged(from, value);
    }
  }

  void loopValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// WorkStart field with key 60.
  static const int workStartInitialValue = -1;
  int _workStart = workStartInitialValue;
  static const int workStartPropertyKey = 60;

  /// Start of the work area in frames.
  int get workStart => _workStart;

  /// Change the [_workStart] field value.
  /// [workStartChanged] will be invoked only if the field's value has changed.
  set workStart(int value) {
    if (_workStart == value) {
      return;
    }
    int from = _workStart;
    _workStart = value;
    if (hasValidated) {
      workStartChanged(from, value);
    }
  }

  void workStartChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// WorkEnd field with key 61.
  static const int workEndInitialValue = -1;
  int _workEnd = workEndInitialValue;
  static const int workEndPropertyKey = 61;

  /// End of the work area in frames.
  int get workEnd => _workEnd;

  /// Change the [_workEnd] field value.
  /// [workEndChanged] will be invoked only if the field's value has changed.
  set workEnd(int value) {
    if (_workEnd == value) {
      return;
    }
    int from = _workEnd;
    _workEnd = value;
    if (hasValidated) {
      workEndChanged(from, value);
    }
  }

  void workEndChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// EnableWorkArea field with key 62.
  static const bool enableWorkAreaInitialValue = false;
  bool _enableWorkArea = enableWorkAreaInitialValue;
  static const int enableWorkAreaPropertyKey = 62;

  /// Whether or not the work area is enabled.
  bool get enableWorkArea => _enableWorkArea;

  /// Change the [_enableWorkArea] field value.
  /// [enableWorkAreaChanged] will be invoked only if the field's value has
  /// changed.
  set enableWorkArea(bool value) {
    if (_enableWorkArea == value) {
      return;
    }
    bool from = _enableWorkArea;
    _enableWorkArea = value;
    if (hasValidated) {
      enableWorkAreaChanged(from, value);
    }
  }

  void enableWorkAreaChanged(bool from, bool to);

  @override
  void copy(covariant LinearAnimationBase source) {
    super.copy(source);
    _fps = source._fps;
    _duration = source._duration;
    _speed = source._speed;
    _loopValue = source._loopValue;
    _workStart = source._workStart;
    _workEnd = source._workEnd;
    _enableWorkArea = source._enableWorkArea;
  }
}
