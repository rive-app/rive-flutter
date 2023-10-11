library rive_core;

import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/animation_state.dart';
import 'package:rive/src/rive_core/animation/animation_state_instance.dart';
import 'package:rive/src/rive_core/animation/any_state.dart';
import 'package:rive/src/rive_core/animation/entry_state.dart';
import 'package:rive/src/rive_core/animation/exit_state.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/nested_state_machine.dart';
import 'package:rive/src/rive_core/animation/state_instance.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_fire_event.dart';
import 'package:rive/src/rive_core/animation/state_machine_layer.dart';
import 'package:rive/src/rive_core/animation/state_machine_listener.dart';
import 'package:rive/src/rive_core/animation/state_machine_trigger.dart';
import 'package:rive/src/rive_core/animation/state_transition.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/event.dart';
import 'package:rive/src/rive_core/nested_artboard.dart';
import 'package:rive/src/rive_core/node.dart';
import 'package:rive/src/rive_core/rive_animation_controller.dart';
import 'package:rive/src/rive_core/shapes/shape.dart';
import 'package:rive/src/runtime_event.dart';
import 'package:rive_common/math.dart';

/// Callback signature for state machine state changes
typedef OnStateChange = void Function(
    String stateMachineName, String stateName);

/// Callback signature for layer state changes
typedef OnLayerStateChange = void Function(LayerState);

/// Callback signature for events firing.
typedef OnEvent = void Function(RiveEvent);

class LayerController {
  final StateMachineLayer layer;
  final StateInstance anyStateInstance;
  final CoreContext core;

  StateInstance? _currentState;
  StateInstance? _stateFrom;
  bool _holdAnimationFrom = false;
  StateTransition? _transition;
  bool _transitionCompleted = false;
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

  void _fireEvents(Iterable<StateMachineFireEvent> fireEvents) {
    for (final fireEvent in fireEvents) {
      Event event = core.resolveWithDefault(fireEvent.eventId, Event.unknown);
      if (event != Event.unknown) {
        controller.reportEvent(event);
      }
    }
  }

  bool _changeState(LayerState? state, {StateTransition? transition}) {
    assert(state is! AnyState,
        'We don\'t allow making the AnyState an active state.');
    if (state == _currentState?.state) {
      return false;
    }
    var currentState = _currentState;
    if (currentState != null) {
      _fireEvents(currentState.state.eventsAt(StateMachineFireOccurance.atEnd));
      currentState.dispose();
    }
    var nextState = state;

    if (nextState != null) {
      _currentState = nextState.makeInstance();
      _fireEvents(nextState.eventsAt(StateMachineFireOccurance.atStart));
    } else {
      _currentState = null;
    }

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
    var transition = _transition;
    if (transition != null && _stateFrom != null && transition.duration != 0) {
      _mix = (_mix + elapsedSeconds / transition.mixTime(_stateFrom!.state))
          .clamp(0, 1)
          .toDouble();

      if (_mix == 1 && !_transitionCompleted) {
        _transitionCompleted = true;
        _fireEvents(transition.eventsAt(StateMachineFireOccurance.atEnd));
      }
    } else {
      _mix = 1;
    }
  }

  void _apply(CoreContext core) {
    if (_holdAnimation != null) {
      _holdAnimation!.apply(_holdTime, coreContext: core, mix: _mixFrom);
      _holdAnimation = null;
    }

    final interpolator = _transition?.interpolator;

    if (_stateFrom != null && _mix < 1) {
      final _applyMixFrom = interpolator?.transform(_mixFrom) ?? _mixFrom;
      _stateFrom!.apply(core, _applyMixFrom);
    }
    if (_currentState != null) {
      final _applyMix = interpolator?.transform(_mix) ?? _mix;
      _currentState!.apply(core, _applyMix);
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

    // give the current state the oportunity to clear spilled time, so that we
    // do not carry this over into another iteration.
    _currentState?.clearSpilledTime();

    // We still need to mix in the current state if mix value is less than one
    // as it still contributes to the end result.
    // It may not need to advance but it does need to apply.
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

        _fireEvents(transition.eventsAt(StateMachineFireOccurance.atStart));
        // Immediately fire end events if transition has no duration.
        if (transition.duration == 0) {
          _transitionCompleted = true;
          _fireEvents(transition.eventsAt(StateMachineFireOccurance.atEnd));
        } else {
          _transitionCompleted = false;
        }

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

class StateMachineController extends RiveAnimationController<CoreContext>
    implements KeyedCallbackReporter {
  final StateMachine stateMachine;
  final _inputValues = HashMap<int, dynamic>();
  final layerControllers = <LayerController>[];
  final _reportedEvents = <Event>[];
  // Keep a seperate list of nested events because we also need to store
  // the source of the nested event in order to compare to listener target
  final Map<int, List<Event>> _reportedNestedEvents = {};

  /// Optional callback for state changes
  final OnStateChange? onStateChange;

  final _eventListeners = <OnEvent>{};

  List<Event> get reportedEvents => _reportedEvents;

  /// Constructor that takes a state machine and optional state change callback
  StateMachineController(
    this.stateMachine, {
    @Deprecated('Use `addEventListener` instead.') this.onStateChange,
  });

  /// Adds a Rive event listener to this controller.
  ///
  /// Documentation: https://help.rive.app/runtimes/rive-events
  void addEventListener(OnEvent callback) => _eventListeners.add(callback);

  /// Removes listener from this controller.
  void removeEventListener(OnEvent callback) =>
      _eventListeners.remove(callback);

  void reportEvent(Event event) {
    _reportedEvents.add(event);
  }

  void reportNestedEvent(Event event, Node source) {
    if (_reportedNestedEvents[source.id] == null) {
      _reportedNestedEvents[source.id] = [];
    }
    _reportedNestedEvents[source.id]!.add(event);
  }

  bool hasListenerWithTarget(Node target) {
    var listeners = stateMachine.listeners.whereType<StateMachineListener>();
    for (final listener in listeners) {
      var listenerTarget = artboard?.context.resolve(listener.targetId);
      if (listenerTarget == target) {
        return true;
      }
    }
    return false;
  }

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

  final _recognizer = ImmediateMultiDragGestureRecognizer();

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
      if (event is StateMachineListener) {
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

    applyEvents();
  }

  void applyEvents() {
    // Callback for events.
    if (_reportedEvents.isNotEmpty || _reportedNestedEvents.isNotEmpty) {
      var events = _reportedEvents.toList(growable: false);
      var nestedEvents = Map<int, List<Event>>.from(_reportedNestedEvents);
      _reportedEvents.clear();
      _reportedNestedEvents.clear();

      var listeners = stateMachine.listeners.whereType<StateMachineListener>();
      listeners.forEach((listener) {
        if (listener.listenerType == ListenerType.event) {
          // Handle events from this artboard
          events.forEach((event) {
            if (listener.eventId == event.id) {
              listener.performChanges(this, Vec2D());
            }
          });
          // Handle events from nested artboards
          nestedEvents.forEach((targetId, eventList) {
            if (listener.targetId == targetId) {
              eventList.forEach((nestedEvent) {
                if (listener.eventId == nestedEvent.id) {
                  listener.performChanges(this, Vec2D());
                }
              });
            }
          });
        }
      });

      _eventListeners.toList().forEach((listener) {
        for (final event in events) {
          listener(RiveEvent.fromCoreEvent(event));
        }
      });
    }
  }

  bool _processEvent(
    Vec2D position, {
    PointerEvent? pointerEvent,
    ListenerType? hitEvent,
  }) {
    var artboard = this.artboard;
    if (artboard == null) {
      return false;
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

    bool hitSomething = false;
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
        if (isOver) {
          hitSomething = true;
        }
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
            nestedStateMachine.pointerDown(
              nestedPosition,
              pointerEvent as PointerDownEvent,
            );
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
    return hitSomething;
  }

  void pointerMove(Vec2D position) => _processEvent(
        position,
        hitEvent: ListenerType.move,
      );

  void pointerDown(Vec2D position, PointerDownEvent event) {
    if (_processEvent(
      position,
      hitEvent: ListenerType.down,
      pointerEvent: event,
    )) {
      _recognizer.addPointer(event);
    }
  }

  void pointerUp(Vec2D position) => _processEvent(
        position,
        hitEvent: ListenerType.up,
      );

  void pointerExit(Vec2D position) => _processEvent(
        position,
        hitEvent: ListenerType.exit,
      );

  void pointerEnter(Vec2D position) => _processEvent(
        position,
        hitEvent: ListenerType.enter,
      );

  /// Implementation of interface that reports which time based events have
  /// elapsed on a timeline within this state machine.
  @override
  void reportKeyedCallback(
      int objectId, int propertyKey, double elapsedSeconds) {
    var coreObject = core.resolve(objectId);
    if (coreObject != null) {
      RiveCoreContext.setCallback(
        coreObject,
        propertyKey,
        CallbackData(this, delay: elapsedSeconds),
      );
    }
  }
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
