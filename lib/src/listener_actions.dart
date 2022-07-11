import 'dart:collection';

import 'package:rive/src/rive_core/animation/listener_action.dart';

class ListenerActions extends ListBase<ListenerAction> {
  final List<ListenerAction?> _values = [];
  List<ListenerAction> get values => _values.cast<ListenerAction>();

  @override
  int get length => _values.length;

  @override
  set length(int value) => _values.length = value;

  @override
  ListenerAction operator [](int index) => _values[index]!;

  @override
  void operator []=(int index, ListenerAction value) => _values[index] = value;
}
