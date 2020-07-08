import 'dart:collection';

import 'package:rive/src/rive_core/drawable.dart';

// TODO: figure out how to make this cleaner.
class DrawableList extends ListBase<Drawable> {
  final List<Drawable> _values = [];
  List<Drawable> get values => _values;

  @override
  int get length => _values.length;

  @override
  set length(int value) => _values.length = value;

  @override
  Drawable operator [](int index) => _values[index];

  @override
  void operator []=(int index, Drawable value) => _values[index] = value;

  void sortDrawables() => sort((a, b) => a.drawOrder.compareTo(b.drawOrder));
}
