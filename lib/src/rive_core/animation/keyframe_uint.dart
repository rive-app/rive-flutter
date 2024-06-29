import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyframe_uint_base.dart';
export 'package:rive/src/generated/animation/keyframe_uint_base.dart';

/// KeyFrame for animating uint properties.
class KeyFrameUint extends KeyFrameUintBase {
  @override
  bool get canInterpolate => false;

  @override
  void apply(Core<CoreContext> object, int propertyKey, double mix) {
    RiveCoreContext.setUint(object, propertyKey, value);
  }

  @override
  void applyInterpolation(Core<CoreContext> object, int propertyKey,
      double currentTime, KeyFrameUint nextFrame, double mix) {
    RiveCoreContext.setUint(object, propertyKey, value);
  }

  @override
  void valueChanged(int from, int to) {}
}
