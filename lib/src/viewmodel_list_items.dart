import 'dart:collection';

import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_list_item.dart';

class ViewModelListItems<T extends ViewModelInstanceListItem>
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
