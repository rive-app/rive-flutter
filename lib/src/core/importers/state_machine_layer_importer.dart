import 'package:rive/rive.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/animation_state.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/state_machine_layer.dart';

class StateMachineLayerImporter extends ImportStackObject {
  final StateMachineLayer layer;
  final ArtboardImporter artboardImporter;
  StateMachineLayerImporter(this.layer, this.artboardImporter);

  final List<LayerState> importedStates = [];

  void addState(LayerState state) {
    importedStates.add(state);
    // Here the state gets assigned a core (artboard) id.
    layer.context.addObject(state);
    layer.internalAddState(state);
  }

  @override
  int get resolvesBefore => StateMachineBase.typeKey;

  bool _resolved = false;
  @override
  bool resolve() {
    assert(!_resolved);
    _resolved = true;
    for (final state in importedStates) {
      if (state is AnimationState) {
        int artboardAnimationIndex = state.animationId;
        assert(artboardAnimationIndex >= 0 &&
            artboardAnimationIndex < artboardImporter.animations.length);
        state.animation = artboardImporter.animations[artboardAnimationIndex];
      }
      for (final transition in state.transitions) {
        // At import time the stateToId is an index relative to the entire layer
        // (which state in this layer). We can use that to find the matching
        // importedState and assign back the core id that will resolve after the
        // entire artboard imports.
        assert(transition.stateToId >= 0 &&
            transition.stateToId < importedStates.length);
        transition.stateTo = importedStates[transition.stateToId];
      }
    }
    return true;
  }
}
