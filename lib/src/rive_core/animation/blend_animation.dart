import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/blend_animation_base.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/artboard.dart';

export 'package:rive/src/generated/animation/blend_animation_base.dart';

abstract class BlendAnimation extends BlendAnimationBase {
  LinearAnimation? _animation;
  LinearAnimation? get animation => _animation;

  @override
  void animationIdChanged(int from, int to) {
    _animation = context.resolve(to);
  }

  @override
  void onAdded() {}

  @override
  void onAddedDirty() {}

  @override
  bool import(ImportStack importStack) {
    var importer =
        importStack.latest<LayerStateImporter>(LayerStateBase.typeKey);
    if (importer == null || !importer.addBlendAnimation(this)) {
      return false;
    }
    var artboardImporter =
        importStack.latest<ArtboardImporter>(ArtboardBase.typeKey);
    if (artboardImporter == null) {
      return false;
    }

    if (animationId >= 0 &&
        animationId < artboardImporter.artboard.animations.length) {
      var found = artboardImporter.artboard.animations[animationId];
      if (found is LinearAnimation) {
        _animation = found;
      }
    }

    return super.import(importStack);
  }
}
