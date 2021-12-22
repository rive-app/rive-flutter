/// Core automatically generated
/// lib/src/generated/animation/keyframe_play_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/animation/keyframe.dart';

abstract class KeyFramePlayBase extends KeyFrame {
  static const int typeKey = 99;
  @override
  int get coreType => KeyFramePlayBase.typeKey;
  @override
  Set<int> get coreTypes => {KeyFramePlayBase.typeKey, KeyFrameBase.typeKey};

  /// --------------------------------------------------------------------------
  /// NestedPlaybackValue field with key 203.
  static const int nestedPlaybackValueInitialValue = 0;
  int _nestedPlaybackValue = nestedPlaybackValueInitialValue;
  static const int nestedPlaybackValuePropertyKey = 203;

  /// Backing value for NestedPlayback enum.
  int get nestedPlaybackValue => _nestedPlaybackValue;

  /// Change the [_nestedPlaybackValue] field value.
  /// [nestedPlaybackValueChanged] will be invoked only if the field's value has
  /// changed.
  set nestedPlaybackValue(int value) {
    if (_nestedPlaybackValue == value) {
      return;
    }
    int from = _nestedPlaybackValue;
    _nestedPlaybackValue = value;
    if (hasValidated) {
      nestedPlaybackValueChanged(from, value);
    }
  }

  void nestedPlaybackValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// ReferenceTime field with key 204.
  static const int referenceTimeInitialValue = 0;
  int _referenceTime = referenceTimeInitialValue;
  static const int referenceTimePropertyKey = 204;

  /// Represents time value to play/stop at, note that depending on
  /// playbackValue this could also be a percentage.
  int get referenceTime => _referenceTime;

  /// Change the [_referenceTime] field value.
  /// [referenceTimeChanged] will be invoked only if the field's value has
  /// changed.
  set referenceTime(int value) {
    if (_referenceTime == value) {
      return;
    }
    int from = _referenceTime;
    _referenceTime = value;
    if (hasValidated) {
      referenceTimeChanged(from, value);
    }
  }

  void referenceTimeChanged(int from, int to);

  @override
  void copy(covariant KeyFramePlayBase source) {
    super.copy(source);
    _nestedPlaybackValue = source._nestedPlaybackValue;
    _referenceTime = source._referenceTime;
  }
}
