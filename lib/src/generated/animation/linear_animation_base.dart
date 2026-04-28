// Core automatically generated
// lib/src/generated/animation/linear_animation_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
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
  static const int fpsPropertyKey = 56;
  static const int fpsInitialValue = 60;
  int fps_ = fpsInitialValue; // publicly exposed

  /// Frames per second used to quantize keyframe times to discrete values that
  /// match this rate.
  int get fps => fps_;

  /// Change the [fps_] field value.
  /// [fpsChanged] will be invoked only if the field's value has changed.
  set fps(int value) {
    if (fps_ == value) return;
    int from = fps_;
    fps_ = value;
    if (hasValidated) {
      fpsChanged(from, value);
    }
  }

  void fpsChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// Duration field with key 57.
  static const int durationPropertyKey = 57;
  static const int durationInitialValue = 60;
  int duration_ = durationInitialValue; // publicly exposed

  /// Duration expressed in number of frames.
  int get duration => duration_;

  /// Change the [duration_] field value.
  /// [durationChanged] will be invoked only if the field's value has changed.
  set duration(int value) {
    if (duration_ == value) return;
    int from = duration_;
    duration_ = value;
    if (hasValidated) {
      durationChanged(from, value);
    }
  }

  void durationChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// Speed field with key 58.
  static const int speedPropertyKey = 58;
  static const double speedInitialValue = 1;
  double speed_ = speedInitialValue; // publicly exposed

  /// Playback speed multiplier.
  double get speed => speed_;

  /// Change the [speed_] field value.
  /// [speedChanged] will be invoked only if the field's value has changed.
  set speed(double value) {
    if (speed_ == value) {
      return;
    }
    double from = speed_;
    speed_ = value;
    if (hasValidated) {
      speedChanged(from, value);
    }
  }

  void speedChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// LoopValue field with key 59.
  static const int loopValuePropertyKey = 59;
  static const int loopValueInitialValue = 0;
  int _loopValue = loopValueInitialValue;

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
  static const int workStartPropertyKey = 60;
  static const int workStartInitialValue = -1;
  int workStart_ = workStartInitialValue; // publicly exposed

  /// Start of the work area in frames.
  int get workStart => workStart_;

  /// Change the [workStart_] field value.
  /// [workStartChanged] will be invoked only if the field's value has changed.
  set workStart(int value) {
    if (workStart_ == value) return;
    int from = workStart_;
    workStart_ = value;
    if (hasValidated) {
      workStartChanged(from, value);
    }
  }

  void workStartChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// WorkEnd field with key 61.
  static const int workEndPropertyKey = 61;
  static const int workEndInitialValue = -1;
  int workEnd_ = workEndInitialValue; // publicly exposed

  /// End of the work area in frames.
  int get workEnd => workEnd_;

  /// Change the [workEnd_] field value.
  /// [workEndChanged] will be invoked only if the field's value has changed.
  set workEnd(int value) {
    if (workEnd_ == value) {
      return;
    }
    int from = workEnd_;
    workEnd_ = value;
    if (hasValidated) {
      workEndChanged(from, value);
    }
  }

  void workEndChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// EnableWorkArea field with key 62.
  static const int enableWorkAreaPropertyKey = 62;
  static const bool enableWorkAreaInitialValue = false;
  bool enableWorkArea_ = enableWorkAreaInitialValue; // publicly exposed

  /// Whether or not the work area is enabled.
  bool get enableWorkArea => enableWorkArea_;

  /// Change the [enableWorkArea_] field value.
  /// [enableWorkAreaChanged] will be invoked only if the field's value has
  /// changed.
  set enableWorkArea(bool value) {
    if (enableWorkArea_ == value) {
      return;
    }
    bool from = enableWorkArea_;
    enableWorkArea_ = value;
    if (hasValidated) {
      enableWorkAreaChanged(from, value);
    }
  }

  void enableWorkAreaChanged(bool from, bool to);

  /// --------------------------------------------------------------------------
  /// Quantize field with key 376.
  static const int quantizePropertyKey = 376;
  static const bool quantizeInitialValue = false;
  bool quantize_ = quantizeInitialValue; // publicly exposed

  /// Whether frames are quantized to desired frame rate or floating based on
  /// runtime speed.
  bool get quantize => quantize_;

  /// Change the [quantize_] field value.
  /// [quantizeChanged] will be invoked only if the field's value has changed.
  set quantize(bool value) {
    if (quantize_ == value) {
      return;
    }
    bool from = quantize_;
    quantize_ = value;
    if (hasValidated) {
      quantizeChanged(from, value);
    }
  }

  void quantizeChanged(bool from, bool to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is LinearAnimationBase) {
      fps_ = source.fps_;
      duration_ = source.duration_;
      speed_ = source.speed_;
      _loopValue = source._loopValue;
      workStart_ = source.workStart_;
      workEnd_ = source.workEnd_;
      enableWorkArea_ = source.enableWorkArea_;
      quantize_ = source.quantize_;
    }
  }
}
