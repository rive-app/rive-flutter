/// Core automatically generated lib/src/generated/animation/keyframe_base.dart.
/// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class KeyFrameBase<T extends CoreContext> extends Core<T> {
  static const int typeKey = 29;
  @override
  int get coreType => KeyFrameBase.typeKey;
  @override
  Set<int> get coreTypes => {KeyFrameBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Frame field with key 67.
  static const int frameInitialValue = 0;
  int _frame = frameInitialValue;
  static const int framePropertyKey = 67;

  /// Timecode as frame number can be converted to time by dividing by animation
  /// fps.
  int get frame => _frame;

  /// Change the [_frame] field value.
  /// [frameChanged] will be invoked only if the field's value has changed.
  set frame(int value) {
    if (_frame == value) {
      return;
    }
    int from = _frame;
    _frame = value;
    if (hasValidated) {
      frameChanged(from, value);
    }
  }

  void frameChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// InterpolationType field with key 68.
  static const int interpolationTypeInitialValue = 0;
  int _interpolationType = interpolationTypeInitialValue;
  static const int interpolationTypePropertyKey = 68;

  /// The type of interpolation index in KeyframeInterpolation applied to this
  /// keyframe.
  int get interpolationType => _interpolationType;

  /// Change the [_interpolationType] field value.
  /// [interpolationTypeChanged] will be invoked only if the field's value has
  /// changed.
  set interpolationType(int value) {
    if (_interpolationType == value) {
      return;
    }
    int from = _interpolationType;
    _interpolationType = value;
    if (hasValidated) {
      interpolationTypeChanged(from, value);
    }
  }

  void interpolationTypeChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// InterpolatorId field with key 69.
  static const int interpolatorIdInitialValue = -1;
  int _interpolatorId = interpolatorIdInitialValue;
  static const int interpolatorIdPropertyKey = 69;

  /// The id of the custom interpolator used when interpolation is Cubic.
  int get interpolatorId => _interpolatorId;

  /// Change the [_interpolatorId] field value.
  /// [interpolatorIdChanged] will be invoked only if the field's value has
  /// changed.
  set interpolatorId(int value) {
    if (_interpolatorId == value) {
      return;
    }
    int from = _interpolatorId;
    _interpolatorId = value;
    if (hasValidated) {
      interpolatorIdChanged(from, value);
    }
  }

  void interpolatorIdChanged(int from, int to);

  @override
  void copy(covariant KeyFrameBase source) {
    _frame = source._frame;
    _interpolationType = source._interpolationType;
    _interpolatorId = source._interpolatorId;
  }
}
