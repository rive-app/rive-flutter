// Core automatically generated
// lib/src/generated/custom_property_number_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/rive_core/custom_property.dart';

abstract class CustomPropertyNumberBase extends CustomProperty {
  static const int typeKey = 127;
  @override
  int get coreType => CustomPropertyNumberBase.typeKey;
  @override
  Set<int> get coreTypes => {
        CustomPropertyNumberBase.typeKey,
        CustomPropertyBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// PropertyValue field with key 243.
  static const double propertyValueInitialValue = 0;
  double _propertyValue = propertyValueInitialValue;
  static const int propertyValuePropertyKey = 243;
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
    if (source is CustomPropertyNumberBase) {
      _propertyValue = source._propertyValue;
    }
  }
}
