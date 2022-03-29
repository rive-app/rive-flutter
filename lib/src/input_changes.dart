import 'dart:collection';

import 'package:rive/src/rive_core/animation/event_input_change.dart';

class InputChanges extends ListBase<EventInputChange> {
  final List<EventInputChange?> _values = [];
  List<EventInputChange> get values => _values.cast<EventInputChange>();

  @override
  int get length => _values.length;

  @override
  set length(int value) => _values.length = value;

  @override
  EventInputChange operator [](int index) => _values[index]!;

  @override
  void operator []=(int index, EventInputChange value) =>
      _values[index] = value;
}
