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
  int _frame;
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
    frameChanged(from, value);
  }

  void frameChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// InterpolationType field with key 68.
  int _interpolationType;
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
    interpolationTypeChanged(from, value);
  }

  void interpolationTypeChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// InterpolatorId field with key 69.
  int _interpolatorId;
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
    interpolatorIdChanged(from, value);
  }

  void interpolatorIdChanged(int from, int to);
}
