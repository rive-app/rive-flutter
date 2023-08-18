import 'dart:collection';

import 'package:rive/src/rive_core/animation/state_machine_fire_event.dart';

class LayerComponentEvents extends ListBase<StateMachineFireEvent> {
  final List<StateMachineFireEvent?> _values = [];
  List<StateMachineFireEvent> get values =>
      _values.cast<StateMachineFireEvent>();

  @override
  int get length => _values.length;

  @override
  set length(int value) => _values.length = value;

  @override
  StateMachineFireEvent operator [](int index) => _values[index]!;

  @override
  void operator []=(int index, StateMachineFireEvent value) =>
      _values[index] = value;
}
