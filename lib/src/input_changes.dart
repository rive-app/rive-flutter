import 'dart:collection';

import 'package:rive/src/rive_core/animation/listener_input_change.dart';

class InputChanges extends ListBase<ListenerInputChange> {
  final List<ListenerInputChange?> _values = [];
  List<ListenerInputChange> get values => _values.cast<ListenerInputChange>();

  @override
  int get length => _values.length;

  @override
  set length(int value) => _values.length = value;

  @override
  ListenerInputChange operator [](int index) => _values[index]!;

  @override
  void operator []=(int index, ListenerInputChange value) =>
      _values[index] = value;
}
