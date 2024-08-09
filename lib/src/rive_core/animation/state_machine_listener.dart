import 'dart:collection';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/state_machine_listener_base.dart';
import 'package:rive/src/rive_core/animation/listener_action.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_component.dart';
import 'package:rive/src/rive_core/event.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';
import 'package:rive/src/rive_core/world_transform_component.dart';
import 'package:rive_common/math.dart';

export 'package:rive/src/generated/animation/state_machine_listener_base.dart';

enum ListenerType { enter, exit, down, up, move, event, click }

enum GestureClickPhase { out, down, clicked }

class StateMachineListener extends StateMachineListenerBase {
  final ListenerActions actions = ListenerActions();

  WorldTransformComponent? _target;
  WorldTransformComponent? get target => _target;
  set target(WorldTransformComponent? value) {
    if (_target == value) {
      return;
    }

    _target = value;

    targetId = _target?.id ?? Core.missingId;
  }

  Event? _event;
  Event? get event => _event;
  set event(Event? value) {
    if (_event == value) {
      return;
    }

    _event = value;

    eventId = _event?.id ?? Core.missingId;
  }

  @override
  String get name =>
      super.name.isEmpty ? (_target?.name ?? 'Listener') : super.name;
  @override
  void listenerTypeValueChanged(int from, int to) {}

  ListenerType get listenerType => ListenerType.values[listenerTypeValue];
  set listenerType(ListenerType value) => listenerTypeValue = value.index;

  @override
  ListBase<StateMachineComponent> machineComponentList(StateMachine machine) =>
      machine.listeners;

  @override
  void targetIdChanged(int from, int to) {
    target = context.resolve(to);
  }

  @override
  void eventIdChanged(int from, int to) {
    event = context.resolve(to);
  }

  /// Called by rive_core to add an [ListenerAction] to this
  /// [StateMachineListener]. This should be @internal when it's supported.
  bool internalAddAction(ListenerAction action) {
    if (actions.contains(action)) {
      return false;
    }
    actions.add(action);

    return true;
  }

  /// Called by rive_core to remove an [ListenerAction] from this
  /// [StateMachineListener]. This should be @internal when it's supported.
  bool internalRemoveAction(ListenerAction action) {
    var removed = actions.remove(action);

    return removed;
  }

  void performChanges(StateMachineController controller, Vec2D position,
      Vec2D previousPosition) {
    for (final action in actions) {
      action.perform(controller, position, previousPosition);
    }
  }
}
