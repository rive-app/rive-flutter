import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/state_transition.dart';
import 'package:rive/src/rive_core/animation/transition_condition.dart';

class StateTransitionImporter extends ImportStackObject {
  final StateTransition transition;
  StateTransitionImporter(this.transition);

  void addCondition(TransitionCondition condition) {
    transition.internalAddCondition(condition);
  }

  @override
  bool resolve() => true;
}
