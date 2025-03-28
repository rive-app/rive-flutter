import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/layer_state_base.dart';
import 'package:rive/src/rive_core/animation/state_instance.dart';
import 'package:rive/src/rive_core/animation/state_machine_layer.dart';
import 'package:rive/src/rive_core/animation/state_transition.dart';

export 'package:rive/src/generated/animation/layer_state_base.dart';

abstract class LayerState extends LayerStateBase {

  @nonVirtual
  final StateTransitions transitions = StateTransitions();
  // StateTransitions get transitions => _transitions;

  @override
  void onAdded() {}

  @override
  void onAddedDirty() {}

  void internalAddTransition(StateTransition transition) {
    assert(!transitions.contains(transition),
        'shouldn\'t already contain the transition');
    transitions.add(transition);
  }

  void internalRemoveTransition(StateTransition transition) {
    transitions.remove(transition);
  }

  // @override
  // void flagsChanged(int from, int to) {}

  StateInstance makeInstance();

  @override
  bool import(ImportStack stack) {
    var importer =
        stack.latest<StateMachineLayerImporter>(StateMachineLayerBase.typeKey);
    if (importer == null) {
      return false;
    }
    importer.addState(this);

    return super.import(stack);
  }
}
