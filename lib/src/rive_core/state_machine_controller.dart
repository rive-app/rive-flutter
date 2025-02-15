library rive_core;

import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/animation_reset_factory.dart'
    as animation_reset_factory;
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
import 'package:rive/src/rive_core/audio_event.dart';
import 'package:rive/src/rive_core/audio_player.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/drawable.dart';
import 'package:rive/src/rive_core/event.dart';
import 'package:rive/src/rive_core/layer_state_flags.dart';
import 'package:rive/src/rive_core/nested_artboard.dart';
import 'package:rive/src/rive_core/node.dart';
import 'package:rive/src/rive_core/rive_animation_controller.dart';
import 'package:rive/src/rive_core/shapes/shape.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance.dart';
import 'package:rive/src/runtime_event.dart';
import 'package:rive_common/math.dart';

/// Callback signature for state machine state changes
typedef OnStateChange = void Function(
    String stateMachineName, String stateName);

/// Callback signature for nested input changes
typedef OnInputValueChange = void Function(int id, dynamic value);

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

  animation_reset_factory.AnimationReset? animationReset;

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
      var event = core.resolve(fireEvent.eventId);
      if (event != null) {
        controller.reportEvent(event);
      }
    }
  }

  bool _canChangeState(LayerState? state) {
    return state != _currentState?.state;
  }

  void _changeState(LayerState? state, {StateTransition? transition}) {
    assert(state is! AnyState,
        'We don\'t allow making the AnyState an active state.');
    assert(state != _currentState?.state, 'Cannot change to state to self.');
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
        _clearAnimationReset();
        _fireEvents(transition.eventsAt(StateMachineFireOccurance.atEnd));
      }
    } else {
      _mix = 1;
    }
  }

  void _apply(CoreContext core) {
    animationReset?.apply(core);
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
    _apply(core);

    for (int i = 0; updateState(i != 0); i++) {
      _apply(core);

      if (i == 100) {
        // Escape hatch, let the user know their logic is causing some kind of
        // recursive condition.
        print('StateMachineController.apply exceeded max iterations.');

        return false;
      }
    }

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
    if (isTransitioning && _transition!.enableEarlyExit == false) {
      return false;
    }
    _waitingForExit = false;
    if (tryChangeState(anyStateInstance, ignoreTriggers)) {
      return true;
    }

    return tryChangeState(_currentState, ignoreTriggers);
  }

  StateTransition? _findRandomTransition(StateInstance stateFrom,
      bool ignoreTriggers, ViewModelInstance? viewModelInstance) {
    double totalWeight = 0;
    final transitions = stateFrom.state.transitions;
    for (final transition in transitions) {
      var allowed = transition.allowed(stateFrom, controller._inputValues,
          ignoreTriggers, viewModelInstance);
      if (allowed == AllowTransition.yes &&
          _canChangeState(transition.stateTo)) {
        transition.evaluatedRandomWeight = transition.randomWeight;
        totalWeight += transition.randomWeight;
        // If random is not active we don't search for more candidates
      } else {
        transition.evaluatedRandomWeight = 0;
        if (allowed == AllowTransition.waitingForExit) {
          _waitingForExit = true;
        }
      }
    }
    if (totalWeight > 0) {
      final random = Random().nextDouble() * totalWeight;
      double currentWeight = 0;
      int index = 0;
      while (index < transitions.length) {
        final transitionWeight =
            transitions.elementAt(index).evaluatedRandomWeight;
        if (currentWeight + transitionWeight > random) {
          break;
        }
        currentWeight += transitionWeight;
        index += 1;
      }
      assert(index < transitions.length);
      final transition = transitions.elementAt(index);
      return transition;
    }
    return null;
  }

  StateTransition? _findAllowedTransition(StateInstance stateFrom,
      bool ignoreTriggers, ViewModelInstance? viewModelInstance) {
    if (stateFrom.state.flags & LayerStateFlags.random ==
        LayerStateFlags.random) {
      return _findRandomTransition(
          stateFrom, ignoreTriggers, viewModelInstance);
    }
    final transitions = stateFrom.state.transitions;
    for (final transition in transitions) {
      var allowed = transition.allowed(stateFrom, controller._inputValues,
          ignoreTriggers, viewModelInstance);
      if (allowed == AllowTransition.yes &&
          _canChangeState(transition.stateTo)) {
        return transition;
      } else if (allowed == AllowTransition.waitingForExit) {
        _waitingForExit = true;
      }
    }
    return null;
  }

  // It provides an instance of AnimationReset that is used to reset values on
  // every frame. This generates a more linear and predictable mix of states
  // during transitions.
  void _buildAnimationResetForTransition() {
    animationReset =
        animation_reset_factory.fromStates(_stateFrom, _currentState, core);
  }

  void _clearAnimationReset() {
    if (animationReset != null) {
      animation_reset_factory.release(animationReset!);
      animationReset = null;
    }
  }

  bool tryChangeState(StateInstance? stateFrom, bool ignoreTriggers) {
    if (stateFrom == null) {
      return false;
    }

    var outState = _currentState;
    final transition = _findAllowedTransition(
        stateFrom, ignoreTriggers, controller._artboard?.viewModelInstance);
    if (transition != null) {
      _clearAnimationReset();
      _changeState(transition.stateTo, transition: transition);
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

      if (!_transitionCompleted) {
        _buildAnimationResetForTransition();
      }

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
  final Map<int, List<Event>> _reportedNestedEvents = HashMap<int, List<Event>>();//{};

  /// Optional callback for state changes
  final OnStateChange? onStateChange;

  /// Optional callback for input value changes
  OnInputValueChange? onInputValueChange;

  final _eventListeners = <OnEvent>{};
  AudioPlayer? _audioPlayer;

  AudioPlayer get audioPlayer => (_audioPlayer ??= AudioPlayer.make())!;

  AudioPlayer? get peekAudioPlayer => _audioPlayer;

  List<Event> get reportedEvents => _reportedEvents;

  /// Constructor that takes a state machine and optional state change callback
  StateMachineController(
    this.stateMachine, {
    @Deprecated('Use `addEventListener` instead.') this.onStateChange,
  });

  /// Adds a Rive event listener to this controller.
  ///
  /// Documentation: https://rive.app/community/doc/rive-events/docbOnaeffgr
  void addEventListener(OnEvent callback) => _eventListeners.add(callback);

  /// Removes listener from this controller.
  void removeEventListener(OnEvent callback) =>
      _eventListeners.remove(callback);

  void reportEvent(Event event) {
    _reportedEvents.add(event);

    isActive = true;
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

  bool tryChangeState() {
    bool didChangeState = false;
    for (final layer in layerControllers) {
      if (layer.updateState(true)) {
        didChangeState = true;
      }
    }
    return didChangeState;
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

  late List<_HitComponent> hitComponents = [];
  final List<_ListenerGroup> listenerGroups = [];

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
      if (event is StateMachineListener) {
        if (event.listenerType == ListenerType.event) {
          continue;
        }
        // Resolve target on this artboard instance.
        var node = core.resolve<Node>(event.targetId);
        if (node == null) {
          continue;
        }
        _ListenerGroup listenerGroup = _ListenerGroup(event);
        listenerGroups.add(listenerGroup);

        node.forAll((component) {
          if (component is Shape) {
            var hitShape = hitShapeLookup[component];
            if (hitShape == null) {
              hitShapeLookup[component] = hitShape = _HitShape(component, this);
            }
            hitShape.addListener(listenerGroup);
          }
          // Keep iterating so we find all shapes.
          return true;
        });
      }
    }

    // hitShapeLookup.values.toList().forEach(hitComponents.add);
    hitShapeLookup.values.forEach(hitComponents.add);

    _artboard = core as RuntimeArtboard;

    if (_artboard != null) {
      for (final nestedArtboard in _artboard!.activeNestedArtboards) {
        if (nestedArtboard.hasNestedStateMachine) {
          hitComponents.add(_HitNestedArtboard(nestedArtboard, this));
        }
      }
    }
    _sortHittableComponents();
    return super.init(core);
  }

  @override
  void dispose() {
    _clearLayerControllers();
    super.dispose();

    _audioPlayer?.dispose();
    _audioPlayer = null;
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

    if (onInputValueChange != null) {
      onInputValueChange!(id, value);
    }
  }

  void _sortHittableComponents() {
    Drawable? firstDrawable = artboard?.firstDrawable;
    if (firstDrawable != null) {
      // walk to the end, so we can visit in reverse-order
      while (firstDrawable!.prev != null) {
        firstDrawable = firstDrawable.prev;
      }

      int hitComponentsCount = hitComponents.length;
      int currentSortedIndex = 0;
      while (firstDrawable != null) {
        for (var i = currentSortedIndex; i < hitComponentsCount; i++) {
          if (hitComponents.elementAt(i).component == firstDrawable) {
            if (currentSortedIndex != i) {
              hitComponents.swap(i, currentSortedIndex);
            }
            currentSortedIndex++;
            break;
          }
        }
        if (currentSortedIndex == hitComponentsCount) {
          break;
        }
        firstDrawable = firstDrawable.next;
      }
    }
  }

  @override
  void apply(CoreContext core, double elapsedSeconds) {
    if (artboard?.hasChangedDrawOrderInLastUpdate ?? false) {
      _sortHittableComponents();
    }

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

      // var listeners = stateMachine.listeners.whereType<StateMachineListener>();
      // stateMachine.listeners.whereType<StateMachineListener>().forEach((listener) {
      for (final listener in stateMachine.listeners.whereType<StateMachineListener>()) {
        var listenerTarget = artboard?.context.resolve(listener.targetId);
        if (listener.listenerType == ListenerType.event) {
          // Handle events from this artboard if it is the target
          if (listenerTarget == artboard) {
            // events.forEach((event) {

            var t = events.length;
            for (var i = 0; i < t; i++) {
              if (listener.eventId == events[i].id) {
                listener.performChanges(this, Vec2D(), Vec2D());
              }
            }
            // for (final event in events) {
            //   if (listener.eventId == event.id) {
            //     listener.performChanges(this, Vec2D(), Vec2D());
            //   }
            // }

          } else {
            // Handle events from nested artboards
            nestedEvents.forEach((targetId, eventList) {
              if (listener.targetId == targetId) {

                var t = eventList.length;
                for (var i = 0; i < t; i++) {
                  if (listener.eventId == eventList[i].id) {
                    listener.performChanges(this, Vec2D(), Vec2D());
                  }
                }
                // for (final nestedEvent in eventList) {
                //   if (listener.eventId == nestedEvent.id) {
                //     listener.performChanges(this, Vec2D(), Vec2D());
                //   }
                // }
              }
            });
          }
        }
      }//);

      var riveEvents = <RiveEvent>[];

      for (final event in events) {
        if (event is AudioEvent && event.asset != null) {
          event.play(audioPlayer);
        }
        riveEvents.add(RiveEvent.fromCoreEvent(event));
      }
      // _eventListeners.toList().forEach((listener) {
      for (final listener in _eventListeners) {
        riveEvents.forEach(listener);
      }//);
    }
  }

  HitResult _processEvent(
    Vec2D position, {
    PointerEvent? pointerEvent,
    ListenerType? hitEvent,
  }) {
    var artboard = this.artboard;
    if (artboard == null) {
      return HitResult.none;
    }
    if (artboard.frameOrigin) {
      // ignore: parameter_assignments
      position = position -
          Vec2D.fromValues(
            artboard.width * artboard.originX,
            artboard.height * artboard.originY,
          );
    }

    for (final listenerGroup in listenerGroups) {
      listenerGroup.reset();
    }
    for (final hitComponent in hitComponents) {
      hitComponent.prepareEvent(position, hitEvent);
    }
    bool hitSomething = false;
    bool hitOpaque = false;
    HitResult hitResult = HitResult.none;
    for (final hitComponent in hitComponents) {
      hitResult = hitComponent.processEvent(position,
          hitEvent: hitEvent, pointerEvent: pointerEvent, canHit: !hitOpaque);
      if (hitResult != HitResult.none) {
        hitSomething = true;
        if (hitResult == HitResult.hitOpaque) {
          hitOpaque = true;
        }
      }
    }
    return hitSomething
        ? hitOpaque
            ? HitResult.hitOpaque
            : HitResult.hit
        : HitResult.none;
  }

  /// Hit testing. If any listeners were hit, returns true.
  bool hitTest(
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

    for (final hitComponent in hitComponents) {
      if (hitComponent.hitTest(position)) {
        return true;
      }
    }

    return false; // no hit targets found
  }

  HitResult pointerMove(Vec2D position) => _processEvent(
        position,
        hitEvent: ListenerType.move,
      );

  HitResult pointerDown(Vec2D position, PointerDownEvent event) {
    final hitResult = _processEvent(
      position,
      hitEvent: ListenerType.down,
      pointerEvent: event,
    );
    return hitResult;
  }

  HitResult pointerUp(Vec2D position) => _processEvent(
        position,
        hitEvent: ListenerType.up,
      );

  HitResult pointerExit(Vec2D position) => _processEvent(
        position,
        hitEvent: ListenerType.exit,
      );

  HitResult pointerEnter(Vec2D position) => _processEvent(
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

enum HitResult {
  none,
  hit,
  hitOpaque,
}

class _ListenerGroup {
  final StateMachineListener listener;
  bool _isConsumed = false;
  bool _isHovered = false;
  bool _prevIsHovered = false;
  GestureClickPhase clickPhase = GestureClickPhase.out;
  final Vec2D previousPosition = Vec2D();

  _ListenerGroup(this.listener);
  void consume() {
    _isConsumed = true;
  }

  void hover() {
    _isHovered = true;
  }

  void unhover() {
    _isHovered = false;
  }

  void reset() {
    _isConsumed = false;
    _prevIsHovered = _isHovered;
    _isHovered = false;
    if (clickPhase == GestureClickPhase.clicked) {
      clickPhase = GestureClickPhase.out;
    }
  }

  bool isConsumed() {
    return _isConsumed;
  }

  bool isHovered() {
    return _isHovered;
  }

  bool prevHovered() {
    return _prevIsHovered;
  }
}

class _HitComponent {
  final Component component;
  final StateMachineController controller;
  HitResult processEvent(
    Vec2D position, {
    PointerEvent? pointerEvent,
    ListenerType? hitEvent,
    bool canHit = true,
  }) {
    return HitResult.none;
  }

  void prepareEvent(Vec2D position, ListenerType? hitType) {}

  bool hitTest(Vec2D position) {
    return false;
  }

  _HitComponent(this.component, this.controller);
}

/// Representation of a Shape from the Artboard Instance and all the events it
/// triggers. Allows tracking hover and performing hit detection only once on
/// shapes that trigger multiple events.
class _HitShape extends _HitComponent {
  final Shape shape;
  double hitRadius = 2;
  bool isHovered = false;
  bool canEarlyOut = true;
  bool hasDownListener = false;
  bool hasUpListener = false;
  List<_ListenerGroup> listenerGroups = [];

  _HitShape(this.shape, StateMachineController controller)
      : super(shape, controller) {
    canEarlyOut = !shape.isTargetOpaque;
  }

  @override
  bool hitTest(Vec2D position) {
    var shape = component as Shape;
    var bounds = shape.worldBounds;

    // Quick reject
    if (bounds.contains(position)) {
      var hitArea = IAABB(
        (position.x - hitRadius).round(),
        (position.y - hitRadius).round(),
        (position.x + hitRadius).round(),
        (position.y + hitRadius).round(),
      );
      // Make hit tester.
      var hitTester = TransformingHitTester(hitArea);
      shape.fillHitTester(hitTester);
      return hitTester.test(); // exit early
    }
    return false;
  }

  @override
  void prepareEvent(Vec2D position, ListenerType? hitType) {
    if (canEarlyOut &&
        (hitType != ListenerType.down || !hasDownListener) &&
        (hitType != ListenerType.up || !hasUpListener)) {
      return;
    }
    isHovered = hitTest(position);

    // iterate all listeners associated with this hit shape
    if (isHovered) {
      for (final listenerGroup in listenerGroups) {
        listenerGroup.hover();
      }
    }
  }

  @override
  HitResult processEvent(
    Vec2D position, {
    PointerEvent? pointerEvent,
    ListenerType? hitEvent,
    bool canHit = true,
  }) {
    if (canEarlyOut &&
        (hitEvent != ListenerType.down || !hasDownListener) &&
        (hitEvent != ListenerType.up || !hasUpListener)) {
      return HitResult.none;
    }

    var shape = component as Shape;

    // iterate all events associated with this hit shape
    for (final listenerGroup in listenerGroups) {
      if (listenerGroup.isConsumed()) {
        continue;
      }
      // Because each group is tested individually for its hover state, a group
      // could be marked "incorrectly" as hovered at this point.
      // But once we iterate each element in the drawing order, that group can
      // be occluded by an opaque target on top  of it.
      // So although it is hovered in isolation, it shouldn't be considered as
      // hovered in the full context.
      // In this case, we unhover the group so it is not marked as previously
      // hovered.
      if (!canHit && listenerGroup.isHovered()) {
        listenerGroup.unhover();
      }
      final isGroupHovered = canHit && listenerGroup.isHovered();
      bool hoverChange = listenerGroup.prevHovered() != isGroupHovered;
      // If hover has changes, it means that the element is hovered for the
      // first time. Previous positions need to be reset to avoid jumps.
      if (hoverChange && isGroupHovered) {
        listenerGroup.previousPosition.x = position.x;
        listenerGroup.previousPosition.y = position.y;
      }
      // Handle click gesture phases. A click gesture has two phases.
      // First one attached to a pointer down actions, second one attached to a
      // pointer up action. Both need to act on a shape of the listener group.
      if (isGroupHovered) {
        if (hitEvent == ListenerType.down) {
          listenerGroup.clickPhase = GestureClickPhase.down;
        } else if (hitEvent == ListenerType.up &&
            listenerGroup.clickPhase == GestureClickPhase.down) {
          listenerGroup.clickPhase = GestureClickPhase.clicked;
        }
      } else {
        if (hitEvent == ListenerType.down || hitEvent == ListenerType.up) {
          listenerGroup.clickPhase = GestureClickPhase.out;
        }
      }
      // Always update hover states regardless of which specific event type
      // we're trying to trigger.
      // If hover has changed and:
      // - it's hovering and the listener is of type enter
      // - it's not hovering and the listener is of type exit
      final listener = listenerGroup.listener;
      if (hoverChange &&
          ((isGroupHovered && listener.listenerType == ListenerType.enter) ||
              (!isGroupHovered &&
                  listener.listenerType == ListenerType.exit))) {
        listener.performChanges(
            controller, position, listenerGroup.previousPosition);
        controller.isActive = true;
        listenerGroup.consume();
      }
      // Perform changes if:
      // - the click gesture is complete and the listener is of type click
      // - the event type matches the listener type and it is hovering the group
      if ((listenerGroup.clickPhase == GestureClickPhase.clicked &&
              listener.listenerType == ListenerType.click) ||
          (isGroupHovered && hitEvent == listener.listenerType)) {
        listener.performChanges(
            controller, position, listenerGroup.previousPosition);
        controller.isActive = true;
        listenerGroup.consume();
      }
      listenerGroup.previousPosition.x = position.x;
      listenerGroup.previousPosition.y = position.y;
    }
    return isHovered && canHit
        ? shape.isTargetOpaque
            ? HitResult.hitOpaque
            : HitResult.hit
        : HitResult.none;
  }

  void addListener(_ListenerGroup listenerGroup) {
    final listener = listenerGroup.listener;
    final listenerType = listener.listenerType;
    if (listenerType == ListenerType.enter ||
        listenerType == ListenerType.exit ||
        listenerType == ListenerType.move) {
      canEarlyOut = false;
    } else {
      if (listenerType == ListenerType.down ||
          listenerType == ListenerType.click) {
        hasDownListener = true;
      }
      if (listenerType == ListenerType.up ||
          listenerType == ListenerType.click) {
        hasUpListener = true;
      }
    }
    listenerGroups.add(listenerGroup);
  }
}

class _HitNestedArtboard extends _HitComponent {
  final NestedArtboard nestedArtboard;
  _HitNestedArtboard(this.nestedArtboard, StateMachineController controller)
      : super(nestedArtboard, controller);

  @override
  bool hitTest(Vec2D position) {
    var nestedPosition = nestedArtboard.worldToLocal(position);
    if (nestedArtboard.isCollapsed) {
      return false;
    }
    if (nestedPosition == null) {
      // Mounted artboard isn't ready or has a 0 scale transform.
      return false;
    }
    for (final nestedStateMachine
        in nestedArtboard.animations.whereType<NestedStateMachine>()) {
      if (nestedStateMachine.hitTest(nestedPosition)) {
        return true; // exit early
      }
    }
    return false;
  }

  @override
  HitResult processEvent(
    Vec2D position, {
    PointerEvent? pointerEvent,
    ListenerType? hitEvent,
    bool canHit = true,
  }) {
    HitResult hitResult = HitResult.none;
    if (nestedArtboard.isCollapsed) {
      return hitResult;
    }
    var nestedPosition = nestedArtboard.worldToLocal(position);
    if (nestedPosition == null) {
      // Mounted artboard isn't ready or has a 0 scale transform.
      return hitResult;
    }
    for (final nestedStateMachine
        in nestedArtboard.animations.whereType<NestedStateMachine>()) {
      if (canHit) {
        switch (hitEvent) {
          case ListenerType.down:
            hitResult = nestedStateMachine.pointerDown(
              nestedPosition,
              pointerEvent as PointerDownEvent,
            );
            break;
          case ListenerType.up:
            hitResult = nestedStateMachine.pointerUp(nestedPosition);
            break;
          default:
            hitResult = nestedStateMachine.pointerMove(nestedPosition);
            break;
        }
      } else {
        nestedStateMachine.pointerExit(nestedPosition);
      }
    }
    return hitResult;
  }
}

/// This allows a value of type T or T?
/// to be treated as a value of type T?.
///
/// We use this so that APIs that have become
/// non-nullable can still be used with `!` and `?`
/// to support older versions of the API as well.
T? _ambiguate<T>(T? value) => value;
