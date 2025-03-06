import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:rive/src/rive_core/animation/transition_condition.dart';

class StateTransitionConditions extends ListBase<TransitionCondition> {

  // final List<TransitionCondition?> _values = [];
  // List<TransitionCondition> get values => _values.cast<TransitionCondition>();

  @nonVirtual
  @override
  final List<TransitionCondition?> values = <TransitionCondition?>[]; // has to be nullable
  // List<TransitionCondition> get values => _values.cast<TransitionCondition>();

  @override
  int get length => values.length;

  @override
  set length(int value) => values.length = value;

  @override
  TransitionCondition operator [](int index) => values[index]!;

  @override
  void operator []=(int index, TransitionCondition value) => values[index] = value;
}
