import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/keyframe_interpolation.dart';
import 'package:rive/src/generated/animation/keyframe_double_base.dart';
import 'package:rive/src/generated/rive_core_context.dart';
export 'package:rive/src/generated/animation/keyframe_double_base.dart';

class KeyFrameDouble extends KeyFrameDoubleBase {
  @override
  void apply(Core<CoreContext> object, int propertyKey, double mix) {
    RiveCoreContext.setDouble(object, propertyKey, value * mix);
  }

  @override
  void onAdded() {
    super.onAdded();
    interpolation ??= KeyFrameInterpolation.linear;
  }

  @override
  void applyInterpolation(Core<CoreContext> object, int propertyKey,
      double currentTime, KeyFrameDouble nextFrame, double mix) {
    var f = (currentTime - seconds) / (nextFrame.seconds - seconds);
    if (interpolator != null) {
      f = interpolator.transform(f);
    }
    var interpolatedValue = value + (nextFrame.value - value) * f;
    if (mix == 1) {
      RiveCoreContext.setDouble(object, propertyKey, interpolatedValue);
    } else {
      var mixi = 1.0 - mix;
      RiveCoreContext.setDouble(
          object,
          propertyKey,
          RiveCoreContext.getDouble(object, propertyKey) * mixi +
              interpolatedValue * mix);
    }
  }

  @override
  void valueChanged(double from, double to) {}
}
