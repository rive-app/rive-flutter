// Core automatically generated
// lib/src/generated/data_bind/bindable_property_number_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/data_bind/bindable_property.dart';

abstract class BindablePropertyNumberBase extends BindableProperty {
  static const int typeKey = 473;
  @override
  int get coreType => BindablePropertyNumberBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {BindablePropertyNumberBase.typeKey, BindablePropertyBase.typeKey};

  /// --------------------------------------------------------------------------
  /// PropertyValue field with key 636.
  static const int propertyValuePropertyKey = 636;
  static const double propertyValueInitialValue = 0;
  double _propertyValue = propertyValueInitialValue;

  /// A property of type double that can be used for data binding.
  double get propertyValue => _propertyValue;

  /// Change the [_propertyValue] field value.
  /// [propertyValueChanged] will be invoked only if the field's value has
  /// changed.
  set propertyValue(double value) {
    if (_propertyValue == value) {
      return;
    }
    double from = _propertyValue;
    _propertyValue = value;
    if (hasValidated) {
      propertyValueChanged(from, value);
    }
  }

  void propertyValueChanged(double from, double to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is BindablePropertyNumberBase) {
      _propertyValue = source._propertyValue;
    }
  }
}
