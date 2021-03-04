import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/state_transition.dart';

class LayerStateImporter extends ImportStackObject {
  final LayerState state;
  LayerStateImporter(this.state);

  void addTransition(StateTransition transition) {
    state.context.addObject(transition);
    transition.stateFrom = state;
  }

  @override
  void resolve() {}
}
