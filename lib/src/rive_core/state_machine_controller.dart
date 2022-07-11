import 'dart:collection';

import 'package:flutter/scheduler.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/animation_state.dart';
import 'package:rive/src/rive_core/animation/animation_state_instance.dart';
import 'package:rive/src/rive_core/animation/any_state.dart';
import 'package:rive/src/rive_core/animation/entry_state.dart';
import 'package:rive/src/rive_core/animation/exit_state.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/nested_state_machine.dart';
import 'package:rive/src/rive_core/animation/state_instance.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_layer.dart';
import 'package:rive/src/rive_core/animation/state_machine_listener.dart';
import 'package:rive/src/rive_core/animation/state_machine_trigger.dart';
import 'package:rive/src/rive_core/animation/state_transition.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/math/aabb.dart';
import 'package:rive/src/rive_core/math/hit_test.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/nested_artboard.dart';
import 'package:rive/src/rive_core/node.dart';
import 'package:rive/src/rive_core/rive_animation_controller.dart';
import 'package:rive/src/rive_core/shapes/shape.dart';

/// Callback signature for satate machine state changes
typedef OnStateChange = void Function(String, String);

/// Callback signature for layer state changes
typedef OnLayerStateChange = void Function(LayerState);

class LayerController {
  final StateMachineLayer layer;
  final StateInstance anyStateInstance;
  final CoreContext core;

  StateInstance? _currentState;
  StateInstance? _stateFrom;
  bool _holdAnimationFrom = false;
  StateTransition? _transition;
  double _mix = 1.0;
  double _mixFrom = 1.0;

  /// Optional callback which is called when a state changes
  /// Takes the state machine name and state name
  final OnLayerStateChange? onLayerStateChange;

  final StateMachineController controller;

  LayerController(
    this.controller,
    this.layer, {
    required this.core,
    this.onLayerStateChange,
  })  : assert(layer.anyState != null),
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

  bool apply(CoreContext core, double elapsedSeconds) {
    if (_currentState != null) {
      _currentState!.advance(elapsedSeconds, controller);
    }

    _updateMix(elapsedSeconds);

    if (_stateFrom != null && _mix < 1) {
      // This didn't advance during our updateState, but it should now that we
      // realize we need to mix it in.
      if (!_holdAnimationFrom) {
        _stateFrom!.advance(elapsedSeconds, controller);
      }
    }

    for (int i = 0; updateState(i != 0); i++) {
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

  bool updateState(bool ignoreTriggers) {
    if (isTransitioning) {
      return false;
    }
    _waitingForExit = false;
    if (tryChangeState(anyStateInstance, ignoreTriggers)) {
      return true;
    }

    return tryChangeState(_currentState, ignoreTriggers);
  }

  bool tryChangeState(StateInstance? stateFrom, bool ignoreTriggers) {
    if (stateFrom == null) {
      return false;
    }

    var outState = _currentState;
    for (final transition in stateFrom.state.transitions) {
      var allowed = transition.allowed(
          stateFrom, controller._inputValues, ignoreTriggers);
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
          _currentState?.advance(spilledTime, controller);
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
  final _inputValues = HashMap<int, dynamic>();
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

      /// See https://github.com/flutter/flutter/issues/103561#issuecomment-1129356149
      _ambiguate(SchedulerBinding.instance)?.addPostFrameCallback((_) {
        String stateName = 'unknown';
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

  late List<_HitShape> hitShapes;
  late List<NestedArtboard> hitNestedArtboards;

  Artboard? _artboard;

  /// The artboard that this state machine controller is manipulating.
  Artboard? get artboard => _artboard;

  late CoreContext core;

  @override
  bool init(CoreContext core) {
    this.core = core;

    _clearLayerControllers();

    for (final layer in stateMachine.layers) {
      layerControllers.add(LayerController(
        this,
        layer,
        core: core,
        onLayerStateChange: _onStateChange,
      ));
    }

    // Make sure triggers are all reset.
    advanceInputs();

    // Initialize all events.
    HashMap<Shape, _HitShape> hitShapeLookup = HashMap<Shape, _HitShape>();
    for (final event in stateMachine.listeners) {
      // Resolve target on this artboard instance.
      var node = core.resolve<Node>(event.targetId);
      if (node == null) {
        continue;
      }

      node.forAll((component) {
        if (component is Shape) {
          var hitShape = hitShapeLookup[component];
          if (hitShape == null) {
            hitShapeLookup[component] = hitShape = _HitShape(component);
          }
          hitShape.events.add(event);
        }
        // Keep iterating so we find all shapes.
        return true;
      });
    }
    hitShapes = hitShapeLookup.values.toList();

    _artboard = core as RuntimeArtboard;

    List<NestedArtboard> nestedArtboards = [];
    if (_artboard != null) {
      for (final nestedArtboard in _artboard!.activeNestedArtboards) {
        if (nestedArtboard.hasNestedStateMachine) {
          nestedArtboards.add(nestedArtboard);
        }
      }
    }
    hitNestedArtboards = nestedArtboards;
    return super.init(core);
  }

  @override
  void dispose() {
    _clearLayerControllers();
    super.dispose();
  }

  @protected
  void advanceInputs() {
    for (final input in stateMachine.inputs) {
      if (input is StateMachineTrigger) {
        _inputValues[input.id] = false;
      }
    }
  }

  dynamic getInputValue(int id) => _inputValues[id];
  void setInputValue(int id, dynamic value) {
    _inputValues[id] = value;
    isActive = true;
  }

  @override
  void apply(CoreContext core, double elapsedSeconds) {
    bool keepGoing = false;
    for (final layerController in layerControllers) {
      if (layerController.apply(core, elapsedSeconds)) {
        keepGoing = true;
      }
    }
    advanceInputs();
    isActive = keepGoing;
  }

  void _processEvent(Vec2D position, {ListenerType? hitEvent}) {
    var artboard = this.artboard;
    if (artboard == null) {
      return;
    }
    if (artboard.frameOrigin) {
      // ignore: parameter_assignments
      position = position -
          Vec2D.fromValues(
            artboard.width * artboard.originX,
            artboard.height * artboard.originY,
          );
    }
    const hitRadius = 2;
    var hitArea = IAABB(
      (position.x - hitRadius).round(),
      (position.y - hitRadius).round(),
      (position.x + hitRadius).round(),
      (position.y + hitRadius).round(),
    );

    for (final hitShape in hitShapes) {
      // for (final hitShape in event.shapes) {
      var shape = hitShape.shape;
      var bounds = shape.worldBounds;

      // Quick reject
      bool isOver = false;
      if (bounds.contains(position)) {
        // Make hit tester.

        var hitTester = TransformingHitTester(hitArea);
        shape.fillHitTester(hitTester);

        // TODO: figure out where we get the fill rule. We could get it from
        // the Shape's first fill or do we want to store it on the event as a
        // user-selectable value in the inspector?

        // Just use bounds for now
        isOver = hitTester.test();
      }

      bool hoverChange = hitShape.isHovered != isOver;
      hitShape.isHovered = isOver;

      // iterate all events associated with this hit shape
      for (final event in hitShape.events) {
        // Always update hover states regardless of which specific event type
        // we're trying to trigger.
        if (hoverChange) {
          if (isOver && event.listenerType == ListenerType.enter) {
            event.performChanges(this, position);
            isActive = true;
          } else if (!isOver && event.listenerType == ListenerType.exit) {
            event.performChanges(this, position);
            isActive = true;
          }
        }
        if (isOver && hitEvent == event.listenerType) {
          event.performChanges(this, position);
          isActive = true;
        }
      }
    }
    for (final nestedArtboard in hitNestedArtboards) {
      var nestedPosition = nestedArtboard.worldToLocal(position);
      if (nestedPosition == null) {
        // Mounted artboard isn't ready or has a 0 scale transform.
        continue;
      }
      for (final nestedStateMachine
          in nestedArtboard.animations.whereType<NestedStateMachine>()) {
        switch (hitEvent) {
          case ListenerType.down:
            nestedStateMachine.pointerDown(nestedPosition);
            break;
          case ListenerType.up:
            nestedStateMachine.pointerUp(nestedPosition);
            break;
          default:
            nestedStateMachine.pointerMove(nestedPosition);
            break;
        }
      }
    }
  }

  void pointerMove(Vec2D position) => _processEvent(
        position,
        hitEvent: ListenerType.move,
      );

  void pointerDown(Vec2D position) => _processEvent(
        position,
        hitEvent: ListenerType.down,
      );

  void pointerUp(Vec2D position) => _processEvent(
        position,
        hitEvent: ListenerType.up,
      );
}

/// Representation of a Shape from the Artboard Instance and all the events it
/// triggers. Allows tracking hover and performing hit detection only once on
/// shapes that trigger multiple events.
class _HitShape {
  Shape shape;
  bool isHovered = false;
  List<StateMachineListener> events = [];
  _HitShape(this.shape);
}

/// This allows a value of type T or T?
/// to be treated as a value of type T?.
///
/// We use this so that APIs that have become
/// non-nullable can still be used with `!` and `?`
/// to support older versions of the API as well.
T? _ambiguate<T>(T? value) => value;
