// Core automatically generated
// lib/src/generated/animation/interpolating_keyframe_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/keyframe.dart';

abstract class InterpolatingKeyFrameBase extends KeyFrame {
  static const int typeKey = 170;
  @override
  int get coreType => InterpolatingKeyFrameBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {InterpolatingKeyFrameBase.typeKey, KeyFrameBase.typeKey};

  /// --------------------------------------------------------------------------
  /// InterpolationType field with key 68.
  static const int interpolationTypePropertyKey = 68;
  static const int interpolationTypeInitialValue = 0;

  /// The type of interpolation index in KeyframeInterpolation applied to this
  /// keyframe.
  @nonVirtual
  int interpolationType = interpolationTypeInitialValue;

  /// --------------------------------------------------------------------------
  /// InterpolatorId field with key 69.
  static const int interpolatorIdPropertyKey = 69;
  static const int interpolatorIdInitialValue = -1;

  // int _interpolatorId = interpolatorIdInitialValue;

  /// The id of the custom interpolator used when interpolation is Cubic.
  // int get interpolatorId => _interpolatorId;

  int get interpolatorId;

  /// Change the [_interpolatorId] field value.
  /// [interpolatorIdChanged] will be invoked only if the field's value has
  /// changed.
  @nonVirtual
  set interpolatorId(int value) {
    // int from = _interpolatorId;
    int from = interpolatorId;
    if (from == value) {
      return;
    }
    // _interpolatorId = value;
    interpolatorIdChanged(from, value);
  }

  void interpolatorIdChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is InterpolatingKeyFrameBase) {
      interpolationType = source.interpolationType;
      // _interpolatorId = source._interpolatorId;
    }
  }
}
