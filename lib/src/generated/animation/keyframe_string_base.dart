/// Core automatically generated
/// lib/src/generated/animation/keyframe_string_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/animation/keyframe.dart';

abstract class KeyFrameStringBase extends KeyFrame {
  static const int typeKey = 142;
  @override
  int get coreType => KeyFrameStringBase.typeKey;
  @override
  Set<int> get coreTypes => {KeyFrameStringBase.typeKey, KeyFrameBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Value field with key 280.
  static const String valueInitialValue = '';
  String _value = valueInitialValue;
  static const int valuePropertyKey = 280;
  String get value => _value;

  /// Change the [_value] field value.
  /// [valueChanged] will be invoked only if the field's value has changed.
  set value(String value) {
    if (_value == value) {
      return;
    }
    String from = _value;
    _value = value;
    if (hasValidated) {
      valueChanged(from, value);
    }
  }

  void valueChanged(String from, String to);

  @override
  void copy(covariant KeyFrameStringBase source) {
    super.copy(source);
    _value = source._value;
  }
}
