import 'dart:collection';

import 'package:rive/src/rive_core/animation/blend_animation_direct.dart';
import 'package:rive/src/rive_core/animation/blend_state_direct.dart';
import 'package:rive/src/rive_core/animation/blend_state_instance.dart';

/// [BlendStateDirect] mixing logic that runs inside the [StateMachine].
class BlendStateDirectInstance
    extends BlendStateInstance<BlendStateDirect, BlendAnimationDirect> {
  BlendStateDirectInstance(BlendStateDirect state) : super(state);

  @override
  void advance(double seconds, HashMap<int, dynamic> inputValues) {
    super.advance(seconds, inputValues);
    for (final animation in animationInstances) {
      dynamic inputValue = inputValues[animation.blendAnimation.inputId];
      var value = (inputValue is double
              ? inputValue
              : animation.blendAnimation.input?.value) ??
          0;
      animation.mix = (value / 100).clamp(0, 1);
    }
  }
}
