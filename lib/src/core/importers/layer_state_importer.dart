import 'package:rive/src/core/importers/artboard_import_stack_object.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/state_transition.dart';

class LayerStateImporter extends ArtboardImportStackObject {
  final LayerState state;
  LayerStateImporter(this.state);

  void addTransition(StateTransition transition) {
    state.context.addObject(transition);
    state.internalAddTransition(transition);
  }
}
