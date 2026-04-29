import 'package:rive/src/generated/animation/blend_state_base.dart';
import 'package:rive/src/rive_core/animation/blend_animation.dart';

export 'package:rive/src/generated/animation/blend_state_base.dart';

//
abstract class BlendState<T extends BlendAnimation> extends BlendStateBase {

  final List<T> animations = <T>[];

  void internalAddAnimation(T animation) {
    assert(!animations.contains(animation), 'shouldn\'t already contain the animation');
    animations.add(animation);
  }

  void internalRemoveAnimation(T animation) {
    animations.remove(animation);
  }
}
