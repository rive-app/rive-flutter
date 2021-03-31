import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/animation_state.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/transition_condition.dart';
import 'package:rive/src/generated/animation/state_transition_base.dart';
import 'package:rive/src/rive_core/state_transition_flags.dart';
export 'package:rive/src/generated/animation/state_transition_base.dart';

class StateTransition extends StateTransitionBase {
  final StateTransitionConditions conditions = StateTransitionConditions();
  LayerState? stateTo;
  static final StateTransition unknown = StateTransition();
  @override
  bool validate() {
    return super.validate() && stateTo != null;
  }

  @override
  void onAdded() {}
  @override
  void onAddedDirty() {}
  @override
  void onRemoved() {
    super.onRemoved();
  }

  bool get isDisabled => (flags & StateTransitionFlags.disabled) != 0;
  bool get pauseOnExit => (flags & StateTransitionFlags.pauseOnExit) != 0;
  bool get enableExitTime => (flags & StateTransitionFlags.enableExitTime) != 0;
  double mixTime(LayerState stateFrom) {
    if (duration == 0) {
      return 0;
    }
    if ((flags & StateTransitionFlags.durationIsPercentage) != 0) {
      var animationDuration = 0.0;
      if (stateFrom is AnimationState) {
        animationDuration = stateFrom.animation?.durationSeconds ?? 0;
      }
      return duration / 100 * animationDuration;
    } else {
      return duration / 1000;
    }
  }

  double exitTimeSeconds(LayerState stateFrom) {
    if (exitTime == 0) {
      return 0;
    }
    if ((flags & StateTransitionFlags.exitTimeIsPercentage) != 0) {
      var animationDuration = 0.0;
      if (stateFrom is AnimationState) {
        animationDuration = stateFrom.animation?.durationSeconds ?? 0;
      }
      return exitTime / 100 * animationDuration;
    } else {
      return exitTime / 1000;
    }
  }

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
  void exitTimeChanged(int from, int to) {}
  @override
  void stateToIdChanged(int from, int to) {}
}
