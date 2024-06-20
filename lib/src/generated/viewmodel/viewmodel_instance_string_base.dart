// Core automatically generated
// lib/src/generated/viewmodel/viewmodel_instance_string_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/viewmodel/viewmodel_instance_value_base.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_value.dart';

abstract class ViewModelInstanceStringBase extends ViewModelInstanceValue {
  static const int typeKey = 433;
  @override
  int get coreType => ViewModelInstanceStringBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {ViewModelInstanceStringBase.typeKey, ViewModelInstanceValueBase.typeKey};

  /// --------------------------------------------------------------------------
  /// PropertyValue field with key 561.
  static const int propertyValuePropertyKey = 561;
  static const String propertyValueInitialValue = '';
  String _propertyValue = propertyValueInitialValue;

  /// The string value.
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
    if (source is ViewModelInstanceStringBase) {
      _propertyValue = source._propertyValue;
    }
  }
}
