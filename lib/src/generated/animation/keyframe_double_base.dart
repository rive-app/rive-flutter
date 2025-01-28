// Core automatically generated
// lib/src/generated/animation/keyframe_double_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyframe_base.dart';
import 'package:rive/src/rive_core/animation/interpolating_keyframe.dart';

abstract class KeyFrameDoubleBase extends InterpolatingKeyFrame {
  static const int typeKey = 30;
  @override
  int get coreType => KeyFrameDoubleBase.typeKey;
  @override
  Set<int> get coreTypes => {
        KeyFrameDoubleBase.typeKey,
        InterpolatingKeyFrameBase.typeKey,
        KeyFrameBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Value field with key 70.
  static const int valuePropertyKey = 70;
  static const double valueInitialValue = 0;

  /// STOKANAL-FORK-EDIT: exposing
  double value_ = valueInitialValue;

  double get value => value_;

  /// Change the [value_] field value.
  /// [valueChanged] will be invoked only if the field's value has changed.
  set value(double value) {
    if (value_ == value) {
      return;
    }
    double from = value_;
    value_ = value;
    if (hasValidated) {
      valueChanged(from, value);
    }
  }

  void valueChanged(double from, double to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is KeyFrameDoubleBase) {
      value_ = source.value_;
    }
  }
}
