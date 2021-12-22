/// Core automatically generated
/// lib/src/generated/animation/keyframe_color_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/animation/keyframe.dart';

abstract class KeyFrameColorBase extends KeyFrame {
  static const int typeKey = 37;
  @override
  int get coreType => KeyFrameColorBase.typeKey;
  @override
  Set<int> get coreTypes => {KeyFrameColorBase.typeKey, KeyFrameBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Value field with key 88.
  static const int valueInitialValue = 0;
  int _value = valueInitialValue;
  static const int valuePropertyKey = 88;
  int get value => _value;

  /// Change the [_value] field value.
  /// [valueChanged] will be invoked only if the field's value has changed.
  set value(int value) {
    if (_value == value) {
      return;
    }
    int from = _value;
    _value = value;
    if (hasValidated) {
      valueChanged(from, value);
    }
  }

  void valueChanged(int from, int to);

  @override
  void copy(covariant KeyFrameColorBase source) {
    super.copy(source);
    _value = source._value;
  }
}
