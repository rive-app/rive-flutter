import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyframe_double_base.dart';
export 'package:rive/src/generated/animation/keyframe_double_base.dart';

void _apply(
    Core<CoreContext> object, int propertyKey, double mix, double value) {
  if (mix == 1) {
    RiveCoreContext.setDouble(object, propertyKey, value);
  } else {
    var mixi = 1.0 - mix;
    RiveCoreContext.setDouble(object, propertyKey,
        RiveCoreContext.getDouble(object, propertyKey) * mixi + value * mix);
  }
}

class KeyFrameDouble extends KeyFrameDoubleBase {
  @override
  void apply(Core<CoreContext> object, int propertyKey, double mix) =>
      _apply(object, propertyKey, mix, value);

  @override
  void applyInterpolation(Core<CoreContext> object, int propertyKey,
      double currentTime, KeyFrameDouble nextFrame, double mix) {
    var f = (currentTime - seconds) / (nextFrame.seconds - seconds);

    if (interpolator != null) {
      f = interpolator!.transform(f);
    }

    _apply(object, propertyKey, mix, value + (nextFrame.value - value) * f);
  }

  @override
  void valueChanged(double from, double to) {}
}
