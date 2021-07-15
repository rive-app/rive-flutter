import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/animation_state_base.dart';
import 'package:rive/src/rive_core/animation/animation_state_instance.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/state_instance.dart';
import 'package:rive/src/rive_core/artboard.dart';

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

  @override
  StateInstance makeInstance() {
    if (animation == null) {
      // Failed to load at runtime/some new type we don't understand.
      return SystemStateInstance(this);
    }

    return AnimationStateInstance(this);
  }

  // We keep the importer code here so that we can inject this for runtime.
  // #2690
  @override
  bool import(ImportStack stack) {
    var importer = stack.latest<ArtboardImporter>(ArtboardBase.typeKey);
    if (importer == null) {
      return false;
    }

    if (animationId >= 0 && animationId < importer.artboard.animations.length) {
      var found = importer.artboard.animations[animationId];
      if (found is LinearAnimation) {
        animation = found;
      }
    }

    return super.import(stack);
  }
}
