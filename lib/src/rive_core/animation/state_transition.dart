import 'dart:collection';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/state_transition_base.dart';
import 'package:rive/src/rive_core/animation/animation_state.dart';
import 'package:rive/src/rive_core/animation/animation_state_instance.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/linear_animation_instance.dart';
import 'package:rive/src/rive_core/animation/loop.dart';
import 'package:rive/src/rive_core/animation/state_instance.dart';
import 'package:rive/src/rive_core/animation/transition_condition.dart';
import 'package:rive/src/rive_core/animation/transition_trigger_condition.dart';
import 'package:rive/src/rive_core/state_transition_flags.dart';

export 'package:rive/src/generated/animation/state_transition_base.dart';

enum AllowTransition { no, waitingForExit, yes }

class StateTransition extends StateTransitionBase {
  final StateTransitionConditions conditions = StateTransitionConditions();
  LayerState? stateTo;
  static final StateTransition unknown = StateTransition();

  @override
  bool validate() {
    return super.validate() &&

        // need this last so runtimes get it which makes the whole
        // allowTransitionFrom thing above a little weird.
        stateTo != null;
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

  /// The amount of time to mix the outgoing animation onto the incoming one
  /// when changing state. Only applies when going out from an AnimationState.
  /// [stateFrom] must be provided as at runtime we don't store the reference to
  /// the state this transition comes from.
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

  /// Provide the animation instance to use for computing percentage durations
  /// for exit time.
  LinearAnimationInstance? exitTimeAnimationInstance(StateInstance stateFrom) =>
      stateFrom is AnimationStateInstance ? stateFrom.animationInstance : null;

  /// Provide the animation to use for computing percentage durations for exit
  /// time.
  LinearAnimation? exitTimeAnimation(LayerState stateFrom) =>
      stateFrom is AnimationState ? stateFrom.animation : null;

  /// Computes the exit time in seconds of the [stateFrom]. Set [absolute] to
  /// true if you want the returned time to be relative to the entire animation.
  /// Set [absolute] to false if you want it relative to the work area.
  double exitTimeSeconds(LayerState stateFrom, {bool absolute = false}) {
    if ((flags & StateTransitionFlags.exitTimeIsPercentage) != 0) {
      var animationDuration = 0.0;
      var start = 0.0;

      var exitAnimation = exitTimeAnimation(stateFrom);
      if (exitAnimation != null) {
        start = absolute ? exitAnimation.startSeconds : 0;
        animationDuration = exitAnimation.durationSeconds;
      }

      return start + exitTime / 100 * animationDuration;
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

  /// Called by rive_core to add a [TransitionCondition] to this
  /// [StateTransition]. This should be @internal when it's supported.
  bool internalAddCondition(TransitionCondition condition) {
    if (conditions.contains(condition)) {
      return false;
    }
    conditions.add(condition);

    return true;
  }

  /// Called by rive_core to remove a [TransitionCondition] from this
  /// [StateTransition]. This should be @internal when it's supported.
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

  /// Returns true when this transition can be taken from [stateFrom] with the
  /// given [inputValues].
  AllowTransition allowed(StateInstance stateFrom,
      HashMap<int, dynamic> inputValues, bool ignoreTriggers) {
    if (isDisabled) {
      return AllowTransition.no;
    }
    for (final condition in conditions) {
      if ((ignoreTriggers && condition is TransitionTriggerCondition) ||
          !condition.evaluate(inputValues)) {
        return AllowTransition.no;
      }
    }
    // For now we only enable exit time from AnimationStates, do we want to
    // enable this for BlendStates? How would that work?
    if (enableExitTime) {
      var exitAnimation = exitTimeAnimationInstance(stateFrom);
      if (exitAnimation != null) {
        // Exit time is specified in a value less than a single loop, so we
        // want to allow exiting regardless of which loop we're on. To do that
        // we bring the exit time up to the loop our lastTime is at.
        var lastTime = exitAnimation.lastTotalTime;
        var time = exitAnimation.totalTime;
        var exitTime = exitTimeSeconds(stateFrom.state);
        var animationFrom = exitAnimation.animation;
        if (exitTime <= animationFrom.durationSeconds &&
            animationFrom.loop != Loop.oneShot) {
          // Get exit time relative to the loop lastTime was in.
          exitTime += (lastTime / animationFrom.durationSeconds).floor() *
              animationFrom.durationSeconds;
        }

        if (time < exitTime) {
          return AllowTransition.waitingForExit;
        }
      }
    }
    return AllowTransition.yes;
  }

  bool applyExitCondition(StateInstance stateFrom) {
    // Hold exit time when the user has set to pauseOnExit on this condition
    // (only valid when exiting from an Animation).
    bool useExitTime = enableExitTime && stateFrom is AnimationStateInstance;
    if (pauseOnExit && useExitTime) {
      stateFrom.animationInstance.time =
          exitTimeSeconds(stateFrom.state, absolute: true);
      return true;
    }
    return useExitTime;
  }
}
