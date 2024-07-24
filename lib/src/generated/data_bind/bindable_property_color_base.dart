// Core automatically generated
// lib/src/generated/data_bind/bindable_property_color_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/data_bind/bindable_property.dart';

abstract class BindablePropertyColorBase extends BindableProperty {
  static const int typeKey = 475;
  @override
  int get coreType => BindablePropertyColorBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {BindablePropertyColorBase.typeKey, BindablePropertyBase.typeKey};

  /// --------------------------------------------------------------------------
  /// PropertyValue field with key 638.
  static const int propertyValuePropertyKey = 638;
  static const int propertyValueInitialValue = 0xFF1D1D1D;
  int _propertyValue = propertyValueInitialValue;

  /// A property of type int that can be used for data binding.
  int get propertyValue => _propertyValue;

  /// Change the [_propertyValue] field value.
  /// [propertyValueChanged] will be invoked only if the field's value has
  /// changed.
  set propertyValue(int value) {
    if (_propertyValue == value) {
      return;
    }
    int from = _propertyValue;
    _propertyValue = value;
    if (hasValidated) {
      propertyValueChanged(from, value);
    }
  }

  void propertyValueChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is BindablePropertyColorBase) {
      _propertyValue = source._propertyValue;
    }
  }
}
