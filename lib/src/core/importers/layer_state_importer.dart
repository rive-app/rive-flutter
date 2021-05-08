import 'package:rive/src/core/importers/artboard_import_stack_object.dart';
import 'package:rive/src/rive_core/animation/blend_animation.dart';
import 'package:rive/src/rive_core/animation/blend_state.dart';
import 'package:rive/src/rive_core/animation/blend_state_transition.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/state_transition.dart';

class LayerStateImporter extends ArtboardImportStackObject {
  final LayerState state;
  LayerStateImporter(this.state);

  void addTransition(StateTransition transition) {
    state.context.addObject(transition);
    state.internalAddTransition(transition);
  }

  bool addBlendAnimation(BlendAnimation blendAnimation) {
    // This works because we explicitly export our transitions before our
    // animations.
    if (state is BlendState) {
      var blendState = state as BlendState;
      for (final transition
          in state.transitions.whereType<BlendStateTransition>()) {
        if (transition.exitBlendAnimationId >= 0 &&
            transition.exitBlendAnimationId < blendState.animations.length) {
          transition.exitBlendAnimation =
              blendState.animations[transition.exitBlendAnimationId];
        }
      }
    }
    if (state is BlendState) {
      (state as BlendState).internalAddAnimation(blendAnimation);
      return true;
    }

    return false;
  }
}
