import 'dart:ui';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyframe_color_base.dart';
export 'package:rive/src/generated/animation/keyframe_color_base.dart';

void _apply(Core<CoreContext> object, int propertyKey, double mix, int value) {
  if (mix == 1) {
    RiveCoreContext.setColor(object, propertyKey, value);
  } else {
    var mixedColor = Color.lerp(
        Color(RiveCoreContext.getColor(object, propertyKey)),
        Color(value),
        mix);
    if (mixedColor != null) {
      RiveCoreContext.setColor(object, propertyKey, mixedColor.value);
    }
  }
}

class KeyFrameColor extends KeyFrameColorBase {
  @override
  void apply(Core<CoreContext> object, int propertyKey, double mix) =>
      _apply(object, propertyKey, mix, value);

  @override
  void applyInterpolation(Core<CoreContext> object, int propertyKey,
      double currentTime, KeyFrameColor nextFrame, double mix) {
    var f = (currentTime - seconds) / (nextFrame.seconds - seconds);

    if (interpolator != null) {
      f = interpolator!.transform(f);
    }

    var color = Color.lerp(Color(value), Color(nextFrame.value), f);
    if (color != null) {
      _apply(object, propertyKey, mix, color.value);
    }
  }

  @override
  void valueChanged(int from, int to) {}
}
