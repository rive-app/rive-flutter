import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/blend_state_base.dart';
import 'package:rive/src/rive_core/animation/blend_animation.dart';

export 'package:rive/src/generated/animation/blend_state_base.dart';

//
abstract class BlendState<T extends BlendAnimation> extends BlendStateBase {
  final BlendAnimations<T> _animations = BlendAnimations<T>();
  BlendAnimations<T> get animations => _animations;

  void internalAddAnimation(T animation) {
    assert(!_animations.contains(animation),
        'shouldn\'t already contain the animation');
    _animations.add(animation);
  }

  void internalRemoveAnimation(T animation) {
    _animations.remove(animation);
  }
}
