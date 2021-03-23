import 'dart:collection';
import 'package:rive/src/rive_core/component.dart';

// TODO: figure out how to make this cleaner.
class ContainerChildren extends ListBase<Component> {
  final List<Component?> _values = [];
  List<Component> get values => _values.cast<Component>();

  @override
  int get length => _values.length;

  @override
  set length(int value) => _values.length = value;

  @override
  Component operator [](int index) => _values[index]!;

  @override
  void operator []=(int index, Component value) => _values[index] = value;
}
