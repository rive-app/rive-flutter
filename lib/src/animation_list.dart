import 'dart:collection';
import 'package:rive/src/rive_core/animation/animation.dart';

class AnimationList extends ListBase<Animation> {
  // Lame way to do this due to how ListBase needs to expand a nullable list.
  final List<Animation?> _values = [];
  List<Animation> get values => _values.cast<Animation>();

  @override
  int get length => _values.length;

  @override
  set length(int value) => _values.length = value;

  @override
  Animation operator [](int index) => _values[index]!;

  @override
  void operator []=(int index, Animation value) => _values[index] = value;
}
