import 'dart:collection';
import 'package:rive/src/rive_core/animation/transition_condition.dart';

class StateTransitionConditions extends ListBase<TransitionCondition> {
  final List<TransitionCondition?> _values = [];
  List<TransitionCondition> get values => _values.cast<TransitionCondition>();

  @override
  int get length => _values.length;

  @override
  set length(int value) => _values.length = value;

  @override
  TransitionCondition operator [](int index) => _values[index]!;

  @override
  void operator []=(int index, TransitionCondition value) =>
      _values[index] = value;
}
