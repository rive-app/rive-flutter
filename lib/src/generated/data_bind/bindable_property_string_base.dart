// Core automatically generated
// lib/src/generated/data_bind/bindable_property_string_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/data_bind/bindable_property.dart';

abstract class BindablePropertyStringBase extends BindableProperty {
  static const int typeKey = 471;
  @override
  int get coreType => BindablePropertyStringBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {BindablePropertyStringBase.typeKey, BindablePropertyBase.typeKey};

  /// --------------------------------------------------------------------------
  /// PropertyValue field with key 635.
  static const int propertyValuePropertyKey = 635;
  static const String propertyValueInitialValue = '';
  String _propertyValue = propertyValueInitialValue;

  /// A property of type String that can be used for data binding.
  String get propertyValue => _propertyValue;

  /// Change the [_propertyValue] field value.
  /// [propertyValueChanged] will be invoked only if the field's value has
  /// changed.
  set propertyValue(String value) {
    if (_propertyValue == value) {
      return;
    }
    String from = _propertyValue;
    _propertyValue = value;
    if (hasValidated) {
      propertyValueChanged(from, value);
    }
  }

  void propertyValueChanged(String from, String to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is BindablePropertyStringBase) {
      _propertyValue = source._propertyValue;
    }
  }
}
