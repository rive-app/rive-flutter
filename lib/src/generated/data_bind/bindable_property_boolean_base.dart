// Core automatically generated
// lib/src/generated/data_bind/bindable_property_boolean_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/data_bind/bindable_property.dart';

abstract class BindablePropertyBooleanBase extends BindableProperty {
  static const int typeKey = 472;
  @override
  int get coreType => BindablePropertyBooleanBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {BindablePropertyBooleanBase.typeKey, BindablePropertyBase.typeKey};

  /// --------------------------------------------------------------------------
  /// PropertyValue field with key 634.
  static const int propertyValuePropertyKey = 634;
  static const bool propertyValueInitialValue = false;
  bool _propertyValue = propertyValueInitialValue;

  /// A property of type bool that can be used for data binding.
  bool get propertyValue => _propertyValue;

  /// Change the [_propertyValue] field value.
  /// [propertyValueChanged] will be invoked only if the field's value has
  /// changed.
  set propertyValue(bool value) {
    if (_propertyValue == value) {
      return;
    }
    bool from = _propertyValue;
    _propertyValue = value;
    if (hasValidated) {
      propertyValueChanged(from, value);
    }
  }

  void propertyValueChanged(bool from, bool to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is BindablePropertyBooleanBase) {
      _propertyValue = source._propertyValue;
    }
  }
}
