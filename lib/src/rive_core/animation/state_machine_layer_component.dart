// We really want this file to import core for the flutter runtime, so make the
// linter happy...

// ignore: unused_import
import 'dart:collection';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/state_machine_layer_component_base.dart';
import 'package:rive/src/rive_core/animation/state_machine_fire_event.dart';

export 'package:rive/src/generated/animation/state_machine_layer_component_base.dart';

abstract class StateMachineLayerComponent
    extends StateMachineLayerComponentBase<RuntimeArtboard> {

  // final LayerComponentEvents events = LayerComponentEvents();
  final List<StateMachineFireEvent> events = <StateMachineFireEvent>[];

  void internalAddFireEvent(StateMachineFireEvent event) {
    assert(!events.contains(event), 'shouldn\'t already contain the event');
    events.add(event);
    _atStart = null;
    _atEnd = null;
  }

  List<StateMachineFireEvent>? _atStart;
  List<StateMachineFireEvent>? _atEnd;

  List<StateMachineFireEvent> _build(StateMachineFireOccurance occurence) => events
    .where((fireEvent) => fireEvent.occurs == occurence)
    .nonNulls
    .toList();

  List<StateMachineFireEvent> eventsAt(StateMachineFireOccurance occurence) {
    switch (occurence) {
      case StateMachineFireOccurance.atStart:
        return _atStart ?? (_atStart = _build(occurence));
      case StateMachineFireOccurance.atEnd:
        return _atEnd ?? (_atEnd = _build(occurence));
    }
  }
}
