import 'dart:collection';
import 'package:rive/src/rive_core/event.dart';

class EventList extends ListBase<Event> {
  // Lame way to do this due to how ListBase needs to expand a nullable list.
  final List<Event?> _values = [];
  List<Event> get values => _values.cast<Event>();

  @override
  int get length => _values.length;

  @override
  set length(int value) => _values.length = value;

  @override
  Event operator [](int index) => _values[index]!;

  @override
  void operator []=(int index, Event value) => _values[index] = value;
}
