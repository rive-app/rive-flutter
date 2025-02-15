import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyframe_double_base.dart';

import '../../generated/rive_core_beans.dart';
export 'package:rive/src/generated/animation/keyframe_double_base.dart';

// void _apply(
//     Core<CoreContext> object, int propertyKey, double mix, double value) {
//     RiveCoreContext.setDouble(object, propertyKey,
//         mix == 1 ? value : RiveCoreContext.getDouble(object, propertyKey) * (1.0 - mix) + value * mix);
// }

class KeyFrameDouble extends KeyFrameDoubleBase {

  /// STOKANAL-FORK-EDIT: Reuse this object for every animation
  @override
  K? clone<K extends Core>() => this as K;

  @override
  void apply(Core<CoreContext> object, PropertyBean bean, double mix) =>
      bean.transformDouble(object, (v) => mix == 1 ? value_ : v * (1.0 - mix) + value_ * mix);

  @override
  void applyInterpolation(Core<CoreContext> object, PropertyBean bean,
      double currentTime, KeyFrameDouble nextFrame, double mix) {
    var f = (currentTime - seconds) / (nextFrame.seconds - seconds);

    var frameValue = interpolator?.transformValue(value_, nextFrame.value_, f) ??
        value_ + (nextFrame.value_ - value_) * f;

    // _apply(object, propertyKey, mix, frameValue);

    bean.setDouble(object, mix == 1 ? frameValue : bean.getDouble(object) * (1.0 - mix) + frameValue * mix);
  }

  @override
  void valueChanged(double from, double to) {}
}
