import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyframe_id_base.dart';
export 'package:rive/src/generated/animation/keyframe_id_base.dart';

class KeyFrameId extends KeyFrameIdBase {
  @override
  bool get canInterpolate => false;

  @override
  void apply(Core<CoreContext> object, int propertyKey, double mix) {
    RiveCoreContext.setUint(object, propertyKey, value);
  }

  @override
  void applyInterpolation(Core<CoreContext> object, int propertyKey,
      double currentTime, KeyFrameId nextFrame, double mix) {
    RiveCoreContext.setUint(object, propertyKey, value);
  }

  @override
  void valueChanged(int from, int to) {}
}
