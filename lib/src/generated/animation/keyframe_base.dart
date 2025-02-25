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

  /// Timecode as frame number can be converted to time by dividing by animation fps
  // @nonVirtual
  // int frame = frameInitialValue;

  @nonVirtual
  int get frame => high;
  @nonVirtual
  set frame(int frame) => high = frame;

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is KeyFrameBase) {
      frame = source.frame;
    }
  }
}
