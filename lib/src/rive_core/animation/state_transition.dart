import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/transition_condition.dart';
import 'package:rive/src/generated/animation/state_transition_base.dart';
import 'package:rive/src/rive_core/state_transition_flags.dart';
export 'package:rive/src/generated/animation/state_transition_base.dart';

class StateTransition extends StateTransitionBase {
  final StateTransitionConditions conditions = StateTransitionConditions();
  LayerState stateTo;
  LayerState stateFrom;
  @override
  void onAdded() {}
  @override
  void onAddedDirty() {
    if (stateToId != null) {
      stateTo = context?.resolve(stateToId);
    }
  }

  @override
  void onRemoved() {
    super.onRemoved();
  }

  bool get isDisabled => (flags & StateTransitionFlags.disabled) != 0;
  @override
  bool import(ImportStack importStack) {
    var importer =
        importStack.latest<LayerStateImporter>(LayerStateBase.typeKey);
    if (importer == null) {
      return false;
    }
    importer.addTransition(this);
    return super.import(importStack);
  }

  bool internalAddCondition(TransitionCondition condition) {
    if (conditions.contains(condition)) {
      return false;
    }
    conditions.add(condition);
    return true;
  }

  bool internalRemoveCondition(TransitionCondition condition) {
    var removed = conditions.remove(condition);
    return removed;
  }

  @override
  void flagsChanged(int from, int to) {}
  @override
  void durationChanged(int from, int to) {}
  @override
  void stateToIdChanged(int from, int to) => stateTo = context?.resolve(to);
}
