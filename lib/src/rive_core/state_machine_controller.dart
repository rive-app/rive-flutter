import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/animation_state.dart';
import 'package:rive/src/rive_core/animation/animation_state_instance.dart';
import 'package:rive/src/rive_core/animation/any_state.dart';
import 'package:rive/src/rive_core/animation/entry_state.dart';
import 'package:rive/src/rive_core/animation/exit_state.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/state_instance.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_layer.dart';
import 'package:rive/src/rive_core/animation/state_transition.dart';
import 'package:rive/src/rive_core/rive_animation_controller.dart';

/// Callback signature for satate machine state changes
typedef OnStateChange = void Function(String, String);

/// Callback signature for layer state changes
typedef OnLayerStateChange = void Function(LayerState);

class LayerController {
  final StateMachineLayer layer;
  final StateInstance anyStateInstance;

  StateInstance? _currentState;
  StateInstance? _stateFrom;
  bool _holdAnimationFrom = false;
  StateTransition? _transition;
  double _mix = 1.0;
  double _mixFrom = 1.0;

  /// Optional callback which is called when a state changes
  /// Takes the state machine name and state name
  final OnLayerStateChange? onLayerStateChange;

  LayerController(this.layer, {this.onLayerStateChange})
      : assert(layer.anyState != null),
        anyStateInstance = layer.anyState!.makeInstance() {
    _changeState(layer.entryState);
  }

  bool _changeState(LayerState? state, {StateTransition? transition}) {
    assert(state is! AnyState,
        'We don\'t allow making the AnyState an active state.');
    if (state == _currentState?.state) {
      return false;
    }
    _currentState?.dispose();

    _currentState = state?.makeInstance();
    return true;
  }

  void dispose() {
    _changeState(null);
    anyStateInstance.dispose();
  }

  bool get isTransitioning =>
      _transition != null &&
      _stateFrom != null &&
      _transition!.duration != 0 &&
      _mix != 1;

  void _updateMix(double elapsedSeconds) {
    if (_transition != null &&
        _stateFrom != null &&
        _transition!.duration != 0) {
      _mix = (_mix + elapsedSeconds / _transition!.mixTime(_stateFrom!.state))
          .clamp(0, 1)
          .toDouble();
    } else {
      _mix = 1;
    }
  }

  void _apply(CoreContext core) {
    if (_holdAnimation != null) {
      _holdAnimation!.apply(_holdTime, coreContext: core, mix: _mixFrom);
      _holdAnimation = null;
    }
    if (_stateFrom != null && _mix < 1) {
      _stateFrom!.apply(core, _mixFrom);
    }
    if (_currentState != null) {
      _currentState!.apply(core, _mix);
    }
  }

  bool apply(StateMachineController machineController, CoreContext core,
      double elapsedSeconds, HashMap<int, dynamic> inputValues) {
    if (_currentState != null) {
      _currentState!.advance(elapsedSeconds, inputValues);
    }

    _updateMix(elapsedSeconds);

    if (_stateFrom != null && _mix < 1) {
      // This didn't advance during our updateState, but it should now that we
      // realize we need to mix it in.
      if (!_holdAnimationFrom) {
        _stateFrom!.advance(elapsedSeconds, inputValues);
      }
    }

    for (int i = 0; updateState(inputValues, i != 0); i++) {
      _apply(core);

      if (i == 100) {
        // Escape hatch, let the user know their logic is causing some kind of
        // recursive condition.
        print('StateMachineController.apply exceeded max iterations.');

        return false;
      }
    }

    _apply(core);

    return _mix != 1 || _waitingForExit || (_currentState?.keepGoing ?? false);
  }

  bool _waitingForExit = false;
  LinearAnimation? _holdAnimation;
  double _holdTime = 0;

  bool updateState(HashMap<int, dynamic> inputValues, bool ignoreTriggers) {
    if (isTransitioning) {
      return false;
    }
    _waitingForExit = false;
    if (tryChangeState(anyStateInstance, inputValues, ignoreTriggers)) {
      return true;
    }

    return tryChangeState(_currentState, inputValues, ignoreTriggers);
  }

  bool tryChangeState(StateInstance? stateFrom,
      HashMap<int, dynamic> inputValues, bool ignoreTriggers) {
    if (stateFrom == null) {
      return false;
    }

    var outState = _currentState;
    for (final transition in stateFrom.state.transitions) {
      var allowed = transition.allowed(stateFrom, inputValues, ignoreTriggers);
      if (allowed == AllowTransition.yes &&
          _changeState(transition.stateTo, transition: transition)) {
        // Take transition
        _transition = transition;

        _stateFrom = outState;

        // If we had an exit time and wanted to pause on exit, make sure to hold
        // the exit time. Delegate this to the transition by telling it that it
        // was completed.
        if (outState != null && transition.applyExitCondition(outState)) {
          // Make sure we apply this state.
          var inst = (outState as AnimationStateInstance).animationInstance;
          _holdAnimation = inst.animation;
          _holdTime = inst.time;
        }
        _mixFrom = _mix;

        // Keep mixing last animation that was mixed in.
        if (_mix != 0) {
          _holdAnimationFrom = transition.pauseOnExit;
        }
        if (outState is AnimationStateInstance) {
          var spilledTime = outState.animationInstance.spilledTime;
          _currentState?.advance(spilledTime, inputValues);
        }

        _mix = 0;
        _updateMix(0);
        // Make sure to reset _waitingForExit to false if we succeed at taking a
        // transition.
        _waitingForExit = false;
        // State has changed, fire the callback if there's one
        if (_currentState != null) {
          onLayerStateChange?.call(_currentState!.state);
        }
        return true;
      } else if (allowed == AllowTransition.waitingForExit) {
        _waitingForExit = true;
      }
    }
    return false;
  }
}

class StateMachineController extends RiveAnimationController<CoreContext> {
  final StateMachine stateMachine;
  final inputValues = HashMap<int, dynamic>();
  final layerControllers = <LayerController>[];

  /// Optional callback for state changes
  final OnStateChange? onStateChange;

  /// Constructor that takes a state machine and optional state change callback
  StateMachineController(this.stateMachine, {this.onStateChange});

  void _clearLayerControllers() {
    for (final layer in layerControllers) {
      layer.dispose();
    }
    layerControllers.clear();
  }

  /// Handles state change callbacks
  void _onStateChange(LayerState layerState) =>
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        String stateName = 'unknown';
        print('Layer state type ${layerState.runtimeType}');
        if (layerState is AnimationState && layerState.animation != null) {
          stateName = layerState.animation!.name;
        } else if (layerState is EntryState) {
          stateName = 'EntryState';
        } else if (layerState is AnyState) {
          stateName = 'EntryState';
        } else if (layerState is ExitState) {
          stateName = 'ExitState';
        }

        onStateChange?.call(stateMachine.name, stateName);
      });

  @override
  bool init(CoreContext core) {
    _clearLayerControllers();

    for (final layer in stateMachine.layers) {
      layerControllers.add(LayerController(
        layer,
        onLayerStateChange: _onStateChange,
      ));
    }

    // Make sure triggers are all reset.
    advanceInputs();

    return super.init(core);
  }

  @override
  void dispose() {
    _clearLayerControllers();
    super.dispose();
  }

  @protected
  void advanceInputs() {}

  @override
  void apply(CoreContext core, double elapsedSeconds) {
    bool keepGoing = false;
    for (final layerController in layerControllers) {
      if (layerController.apply(this, core, elapsedSeconds, inputValues)) {
        keepGoing = true;
      }
    }
    advanceInputs();
    isActive = keepGoing;
  }
}
