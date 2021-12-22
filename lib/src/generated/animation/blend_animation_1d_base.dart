/// Core automatically generated
/// lib/src/generated/animation/blend_animation_1d_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/animation/blend_animation.dart';

abstract class BlendAnimation1DBase extends BlendAnimation {
  static const int typeKey = 75;
  @override
  int get coreType => BlendAnimation1DBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {BlendAnimation1DBase.typeKey, BlendAnimationBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Value field with key 166.
  static const double valueInitialValue = 0;
  double _value = valueInitialValue;
  static const int valuePropertyKey = 166;
  double get value => _value;

  /// Change the [_value] field value.
  /// [valueChanged] will be invoked only if the field's value has changed.
  set value(double value) {
    if (_value == value) {
      return;
    }
    double from = _value;
    _value = value;
    if (hasValidated) {
      valueChanged(from, value);
    }
  }

  void valueChanged(double from, double to);

  @override
  void copy(covariant BlendAnimation1DBase source) {
    super.copy(source);
    _value = source._value;
  }
}
