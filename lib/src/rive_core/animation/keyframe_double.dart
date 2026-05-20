import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyframe_double_base.dart';

import '../../generated/rive_core_beans.dart';
export 'package:rive/src/generated/animation/keyframe_double_base.dart';

class KeyFrameDouble extends KeyFrameDoubleBase {

  @override
  K? clone<K extends Core>() => this as K;

  @override
  void apply(Core<CoreContext> object, PropertyBean bean, double mix) {
    if (mix == 1) {
      bean.setDouble(object, value);
    } else {
      bean.applyDouble(object, 1.0 - mix, value * mix);
    }
  }

  @override
  void applyInterpolation(Core<CoreContext> object, PropertyBean bean,
      double currentTime, KeyFrameDouble nextFrame, double mix) {
    var f = (currentTime - seconds) / (nextFrame.seconds - seconds);

    var frameValue = interpolator?.transformValue(value, nextFrame.value, f) ??
        value + (nextFrame.value - value) * f;

    if (mix == 1) {
      bean.setDouble(object, frameValue);
    } else {
      bean.setDouble(object, bean.getDouble(object) * (1.0 - mix) + frameValue * mix);
    }
  }
}
