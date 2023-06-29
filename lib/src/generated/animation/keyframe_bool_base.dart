/// Core automatically generated
/// lib/src/generated/animation/keyframe_bool_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/animation/keyframe.dart';

abstract class KeyFrameBoolBase extends KeyFrame {
  static const int typeKey = 84;
  @override
  int get coreType => KeyFrameBoolBase.typeKey;
  @override
  Set<int> get coreTypes => {KeyFrameBoolBase.typeKey, KeyFrameBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Value field with key 181.
  static const bool valueInitialValue = false;
  bool _value = valueInitialValue;
  static const int valuePropertyKey = 181;
  bool get value => _value;

  /// Change the [_value] field value.
  /// [valueChanged] will be invoked only if the field's value has changed.
  set value(bool value) {
    if (_value == value) {
      return;
    }
    bool from = _value;
    _value = value;
    if (hasValidated) {
      valueChanged(from, value);
    }
  }

  void valueChanged(bool from, bool to);

  @override
  void copy(covariant KeyFrameBoolBase source) {
    super.copy(source);
    _value = source._value;
  }
}
