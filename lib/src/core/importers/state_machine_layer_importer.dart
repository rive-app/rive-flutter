import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/state_machine_layer.dart';

class StateMachineLayerImporter extends ImportStackObject {
  final StateMachineLayer layer;
  StateMachineLayerImporter(this.layer);

  final List<LayerState> importedStates = [];

  void addState(LayerState state) {
    importedStates.add(state);
    // Here the state gets assigned a core (artboard) id.
    layer.context.addObject(state);
    layer.internalAddState(state);
  }

  @override
  void resolve() {
    for (final state in importedStates) {
      for (final transition in state.transitions) {
        // At import time the stateToId is an index relative to the entire layer
        // (which state in this layer). We can use that to find the matching
        // importedState and assign back the core id that will resolve after the
        // entire artboard imports.
        assert(transition.stateToId >= 0 &&
            transition.stateToId < importedStates.length);
        transition.stateToId = importedStates[transition.stateToId].id;

        // As an alternative way to do this, in the future we could consider
        // just short-circuiting the reference here. We're avoiding this for now
        // to keep shared code between the editor and runtime more consistent.

        // transition.stateTo = importedStates[transition.stateToId];
      }
    }
  }
}
