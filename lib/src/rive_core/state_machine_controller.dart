import 'dart:collection';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/animation_state.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/linear_animation_instance.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_layer.dart';
import 'package:rive/src/rive_core/animation/state_transition.dart';
import 'package:rive/src/rive_core/rive_animation_controller.dart';

class LayerController {
  final StateMachineLayer layer;
  LayerState? _currentState;
  LayerState? _stateFrom;
  bool _holdAnimationFrom = false;
  LinearAnimationInstance? _animationInstanceFrom;
  StateTransition? _transition;
  double _mix = 1.0;
  LinearAnimationInstance? _animationInstance;
  LayerController(this.layer) {
    _changeState(layer.entryState);
  }
  bool _changeState(LayerState? state) {
    if (state == _currentState) {
      return false;
    }
    _currentState = state;
    return true;
  }

  void dispose() {
    _changeState(null);
  }

  bool apply(CoreContext core, double elapsedSeconds,
      HashMap<int, dynamic> inputValues) {
    if (_animationInstance != null) {
      _animationInstance!.advance(elapsedSeconds);
    }
    for (int i = 0; updateState(inputValues); i++) {
      if (i == 100) {
        print('StateMachineController.apply exceeded max iterations.');
        return false;
      }
    }
    if (_transition != null &&
        _stateFrom != null &&
        _transition!.duration != 0) {
      _mix = (_mix + elapsedSeconds / _transition!.mixTime(_stateFrom!))
          .clamp(0, 1)
          .toDouble();
    } else {
      _mix = 1;
    }
    var keepGoing = _mix != 1;
    if (_animationInstanceFrom != null && _mix < 1) {
      if (!_holdAnimationFrom) {
        _animationInstanceFrom!.advance(elapsedSeconds);
      }
      _animationInstanceFrom!.animation.apply(_animationInstanceFrom!.time,
          mix: 1 - _mix, coreContext: core);
    }
    if (_animationInstance != null) {
      _animationInstance!.animation
          .apply(_animationInstance!.time, mix: _mix, coreContext: core);
      if (_animationInstance!.keepGoing) {
        keepGoing = true;
      }
    }
    return keepGoing;
  }

  bool updateState(HashMap<int, dynamic> inputValues) {
    if (tryChangeState(layer.anyState, inputValues)) {
      return true;
    }
    return tryChangeState(_currentState, inputValues);
  }

  bool tryChangeState(
      LayerState? stateFrom, HashMap<int, dynamic> inputValues) {
    if (stateFrom == null) {
      return false;
    }
    for (final transition in stateFrom.transitions) {
      if (transition.isDisabled) {
        continue;
      }
      bool valid = true;
      for (final condition in transition.conditions) {
        if (!condition.evaluate(inputValues)) {
          valid = false;
          break;
        }
      }
      if (valid && stateFrom is AnimationState && transition.enableExitTime) {
        var fromAnimation = stateFrom.animation!;
        if (_animationInstance != null &&
            fromAnimation == _animationInstance!.animation) {
          var lastTime = _animationInstance!.lastTotalTime;
          var time = _animationInstance!.totalTime;
          var exitTime = transition.exitTimeSeconds(stateFrom);
          if (exitTime < fromAnimation.durationSeconds) {
            exitTime += (lastTime / fromAnimation.durationSeconds).floor() *
                fromAnimation.durationSeconds;
          }
          if (time < exitTime) {
            valid = false;
          }
        }
      }
      if (valid && _changeState(transition.stateTo)) {
        _transition = transition;
        _stateFrom = stateFrom;
        if (transition.pauseOnExit &&
            transition.enableExitTime &&
            _animationInstance != null) {
          _animationInstance!.time = transition.exitTimeSeconds(stateFrom);
        }
        if (_mix != 0) {
          _holdAnimationFrom = transition.pauseOnExit;
          _animationInstanceFrom = _animationInstance;
        }
        if (_currentState is AnimationState) {
          var animationState = _currentState as AnimationState;
          var spilledTime = _animationInstanceFrom?.spilledTime ?? 0;
          if (animationState.animation != null) {
            _animationInstance =
                LinearAnimationInstance(animationState.animation!);
            _animationInstance!.advance(spilledTime);
          } else {
            _animationInstance = null;
          }
          _mix = 0;
        } else {
          _animationInstance = null;
        }
        return true;
      }
    }
    return false;
  }
}

class StateMachineController extends RiveAnimationController<CoreContext> {
  final StateMachine stateMachine;
  final inputValues = HashMap<int, dynamic>();
  StateMachineController(this.stateMachine);
  final layerControllers = <LayerController>[];
  void _clearLayerControllers() {
    for (final layer in layerControllers) {
      layer.dispose();
    }
    layerControllers.clear();
  }

  @override
  bool init(CoreContext core) {
    _clearLayerControllers();
    for (final layer in stateMachine.layers) {
      layerControllers.add(LayerController(layer));
    }
    return super.init(core);
  }

  @override
  void dispose() {
    _clearLayerControllers();
    super.dispose();
  }

  @override
  void apply(CoreContext core, double elapsedSeconds) {
    bool keepGoing = false;
    for (final layerController in layerControllers) {
      if (layerController.apply(core, elapsedSeconds, inputValues)) {
        keepGoing = true;
      }
    }
    isActive = keepGoing;
  }
}
