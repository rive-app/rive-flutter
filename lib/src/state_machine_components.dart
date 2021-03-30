import 'dart:collection';
import 'package:rive/src/rive_core/animation/state_machine_component.dart';

class StateMachineComponents<T extends StateMachineComponent>
    extends ListBase<T> {
  final List<T?> _values = [];
  List<T> get values => _values.cast<T>();

  @override
  int get length => _values.length;

  @override
  set length(int value) => _values.length = value;

  @override
  T operator [](int index) => _values[index]!;

  @override
  void operator []=(int index, T value) => _values[index] = value;
}
