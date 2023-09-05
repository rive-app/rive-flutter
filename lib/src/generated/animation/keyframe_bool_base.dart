// Core automatically generated
// lib/src/generated/animation/keyframe_bool_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyframe_base.dart';
import 'package:rive/src/rive_core/animation/interpolating_keyframe.dart';

abstract class KeyFrameBoolBase extends InterpolatingKeyFrame {
  static const int typeKey = 84;
  @override
  int get coreType => KeyFrameBoolBase.typeKey;
  @override
  Set<int> get coreTypes => {
        KeyFrameBoolBase.typeKey,
        InterpolatingKeyFrameBase.typeKey,
        KeyFrameBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Value field with key 181.
  static const int valuePropertyKey = 181;
  static const bool valueInitialValue = false;
  bool _value = valueInitialValue;
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
  void copy(Core source) {
    super.copy(source);
    if (source is KeyFrameBoolBase) {
      _value = source._value;
    }
  }
}
