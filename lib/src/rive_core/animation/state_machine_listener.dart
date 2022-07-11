import 'dart:collection';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/state_machine_listener_base.dart';
import 'package:rive/src/rive_core/animation/listener_action.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_component.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/node.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';

export 'package:rive/src/generated/animation/state_machine_listener_base.dart';

enum ListenerType { enter, exit, down, up, move }

class StateMachineListener extends StateMachineListenerBase {
  final ListenerActions actions = ListenerActions();

  Node? _target;
  Node? get target => _target;
  set target(Node? value) {
    if (_target == value) {
      return;
    }

    _target = value;

    targetId = _target?.id ?? Core.missingId;
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
  void targetIdChanged(int from, int to) => target = context.resolve(to);

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

  void performChanges(StateMachineController controller, Vec2D position) {
    for (final action in actions) {
      action.perform(controller, position);
    }
  }
}
