import 'dart:ui';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyframe_color_base.dart';

import '../../generated/rive_core_beans.dart';
export 'package:rive/src/generated/animation/keyframe_color_base.dart';

void _apply(Core<CoreContext> object, PropertyBean bean, double mix, int value) {
  if (mix == 1) {
    // RiveCoreContext.setColor(object, propertyKey, value);
    bean.setColor(object, value);
  } else {
    var mixedColor = Color.lerp(
        Color(bean.getColor(object)),
        Color(value),
        mix);
    if (mixedColor != null) {
      bean.setColor(object, mixedColor.value);
    }
  }
}

class KeyFrameColor extends KeyFrameColorBase {
  @override
  void apply(Core<CoreContext> object, PropertyBean bean, double mix) =>
      _apply(object, bean, mix, value);

  @override
  void applyInterpolation(Core<CoreContext> object, PropertyBean bean,
      double currentTime, KeyFrameColor nextFrame, double mix) {
    var f = (currentTime - seconds) / (nextFrame.seconds - seconds);

    if (interpolator != null) {
      f = interpolator!.transform(f);
    }

    var color = Color.lerp(Color(value), Color(nextFrame.value), f);
    if (color != null) {
      _apply(object, bean, mix, color.value);
    }
  }

  @override
  void valueChanged(int from, int to) {}
}
