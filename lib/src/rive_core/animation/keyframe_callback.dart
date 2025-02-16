import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyframe_callback_base.dart';
import 'package:rive/src/rive_core/animation/keyframe.dart';

import '../../generated/rive_core_beans.dart';

export 'package:rive/src/generated/animation/keyframe_callback_base.dart';

class KeyFrameCallback extends KeyFrameCallbackBase {
  @override
  void apply(Core<CoreContext> object, PropertyBean bean, double mix) {}

  @override
  void applyInterpolation(Core<CoreContext> object, PropertyBean bean,
      double seconds, covariant KeyFrame nextFrame, double mix) {}
}
