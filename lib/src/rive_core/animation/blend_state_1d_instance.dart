import 'package:rive/src/rive_core/animation/blend_animation_1d.dart';
import 'package:rive/src/rive_core/animation/blend_state_1d.dart';
import 'package:rive/src/rive_core/animation/blend_state_instance.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';

/// [BlendState1D] mixing logic that runs inside the [StateMachine].
class BlendState1DInstance
    extends BlendStateInstance<BlendState1D, BlendAnimation1D> {
  BlendState1DInstance(BlendState1D state) : super(state) {
    animationInstances.sort(
        (a, b) => a.blendAnimation.value.compareTo(b.blendAnimation.value));
  }

  /// Binary find the closest animation index.
  int animationIndex(double value) {
    int idx = 0;
    int mid = 0;
    double closestValue = 0;
    int start = 0;
    int end = animationInstances.length - 1;

    while (start <= end) {
      mid = (start + end) >> 1;
      closestValue = animationInstances[mid].blendAnimation.value;
      if (closestValue < value) {
        start = mid + 1;
      } else if (closestValue > value) {
        end = mid - 1;
      } else {
        idx = start = mid;
        break;
      }

      idx = start;
    }
    return idx;
  }

  BlendStateAnimationInstance<BlendAnimation1D>? _from;
  BlendStateAnimationInstance<BlendAnimation1D>? _to;

  @override
  void advance(double seconds, StateMachineController controller) {
    super.advance(seconds, controller);
    dynamic inputValue =
        controller.getInputValue((state as BlendState1D).inputId);
    var value = (inputValue is double
            ? inputValue
            : (state as BlendState1D).input?.value) ??
        0;
    int index = animationIndex(value);
    _to = index >= 0 && index < animationInstances.length
        ? animationInstances[index]
        : null;
    _from = index - 1 >= 0 && index - 1 < animationInstances.length
        ? animationInstances[index - 1]
        : null;

    double mix, mixFrom;
    if (_to == null ||
        _from == null ||
        _to!.blendAnimation.value == _from!.blendAnimation.value) {
      mix = mixFrom = 1;
    } else {
      mix = (value - _from!.blendAnimation.value) /
          (_to!.blendAnimation.value - _from!.blendAnimation.value);
      mixFrom = 1.0 - mix;
    }

    var toValue = _to?.blendAnimation.value;
    var fromValue = _from?.blendAnimation.value;
    for (final animation in animationInstances) {
      if (animation.blendAnimation.value == toValue) {
        animation.mix = mix;
      } else if (animation.blendAnimation.value == fromValue) {
        animation.mix = mixFrom;
      } else {
        animation.mix = 0;
      }
    }
  }
}
