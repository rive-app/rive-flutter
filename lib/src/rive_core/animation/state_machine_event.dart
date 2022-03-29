import 'dart:collection';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/state_machine_event_base.dart';
import 'package:rive/src/rive_core/animation/event_input_change.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_component.dart';
import 'package:rive/src/rive_core/node.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';

export 'package:rive/src/generated/animation/state_machine_event_base.dart';

enum EventType { enter, exit, down, up }

class StateMachineEvent extends StateMachineEventBase {
  final InputChanges inputChanges = InputChanges();

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
      super.name.isEmpty ? (_target?.name ?? 'Event') : super.name;
  @override
  void eventTypeValueChanged(int from, int to) {}

  EventType get eventType => EventType.values[eventTypeValue];
  set eventType(EventType value) => eventTypeValue = value.index;

  @override
  ListBase<StateMachineComponent> machineComponentList(StateMachine machine) =>
      machine.events;

  @override
  void targetIdChanged(int from, int to) => target = context.resolve(to);

  /// Called by rive_core to add an [EventInputChange] to this
  /// [StateMachineEvent]. This should be @internal when it's supported.
  bool internalAddInputChange(EventInputChange change) {
    if (inputChanges.contains(change)) {
      return false;
    }
    inputChanges.add(change);

    return true;
  }

  /// Called by rive_core to remove an [EventInputChange] from this
  /// [StateMachineEvent]. This should be @internal when it's supported.
  bool internalRemoveInputChange(EventInputChange change) {
    var removed = inputChanges.remove(change);

    return removed;
  }

  void performChanges(StateMachineController controller) {
    for (final change in inputChanges) {
      change.perform(controller);
    }
  }
}
