// Core automatically generated lib/src/generated/animation/keyframe_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class KeyFrameBase<T extends CoreContext> extends Core<T> {
  static const int typeKey = 29;
  @override
  int get coreType => KeyFrameBase.typeKey;
  @override
  Set<int> get coreTypes => {KeyFrameBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Frame field with key 67.
  static const int framePropertyKey = 67;
  static const int frameInitialValue = 0;
  int _frame = frameInitialValue;

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

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is KeyFrameBase) {
      _frame = source._frame;
    }
  }
}
