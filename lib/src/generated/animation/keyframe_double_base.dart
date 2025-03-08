// Core automatically generated
// lib/src/generated/animation/keyframe_double_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyframe_base.dart';
import 'package:rive/src/rive_core/animation/interpolating_keyframe.dart';

const _coreTypes = <int>{
  KeyFrameDoubleBase.typeKey,
  InterpolatingKeyFrameBase.typeKey,
  KeyFrameBase.typeKey
};

abstract class KeyFrameDoubleBase extends InterpolatingKeyFrame {
  static const int typeKey = 30;
  @override
  int get coreType => KeyFrameDoubleBase.typeKey;
  @override
  Set<int> get coreTypes => _coreTypes;

  /// --------------------------------------------------------------------------
  /// Value field with key 70.
  static const int valuePropertyKey = 70;
  static const double valueInitialValue = 0;

  /// STOKANAL-FORK-EDIT: exposing
  @nonVirtual
  double value = valueInitialValue;

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is KeyFrameDoubleBase) {
      value = source.value;
    }
  }
}
