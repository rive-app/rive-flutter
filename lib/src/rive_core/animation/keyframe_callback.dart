import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyframe_callback_base.dart';
import 'package:rive/src/rive_core/animation/keyframe.dart';

export 'package:rive/src/generated/animation/keyframe_callback_base.dart';

class KeyFrameCallback extends KeyFrameCallbackBase {
  @override
  KeyFrameCallback? next;

  @override
  KeyFrameCallback? prev;

  @override
  void apply(Core<CoreContext> object, int propertyKey, double mix) {}

  @override
  void applyInterpolation(Core<CoreContext> object, int propertyKey,
      double seconds, covariant KeyFrame nextFrame, double mix) {}

  @override
  void valueFrom(covariant Core<CoreContext> object, int propertyKey) {}
}
