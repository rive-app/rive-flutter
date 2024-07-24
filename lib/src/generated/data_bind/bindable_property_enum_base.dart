// Core automatically generated
// lib/src/generated/data_bind/bindable_property_enum_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/data_bind/bindable_property.dart';

abstract class BindablePropertyEnumBase extends BindableProperty {
  static const int typeKey = 474;
  @override
  int get coreType => BindablePropertyEnumBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {BindablePropertyEnumBase.typeKey, BindablePropertyBase.typeKey};

  /// --------------------------------------------------------------------------
  /// PropertyValue field with key 637.
  static const int propertyValuePropertyKey = 637;
  static const int propertyValueInitialValue = -1;
  int _propertyValue = propertyValueInitialValue;

  /// The id of the enum that can be used for data binding.
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
    if (source is BindablePropertyEnumBase) {
      _propertyValue = source._propertyValue;
    }
  }
}
