import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/generated/animation/animation_state_base.dart';
export 'package:rive/src/generated/animation/animation_state_base.dart';

class AnimationState extends AnimationStateBase {
  @override
  String toString() {
    return '${super.toString()} ($id) -> ${_animation?.name}';
  }

  LinearAnimation? _animation;
  LinearAnimation? get animation => _animation;
  set animation(LinearAnimation? value) {
    if (_animation == value) {
      return;
    }
    _animation = value;
    animationId = value?.id ?? Core.missingId;
  }

  @override
  void animationIdChanged(int from, int to) {
    animation = id == Core.missingId ? null : context.resolve(to);
  }
}
