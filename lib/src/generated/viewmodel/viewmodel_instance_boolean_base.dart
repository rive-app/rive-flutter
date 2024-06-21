// Core automatically generated
// lib/src/generated/viewmodel/viewmodel_instance_boolean_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/viewmodel/viewmodel_instance_value_base.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_value.dart';

abstract class ViewModelInstanceBooleanBase extends ViewModelInstanceValue {
  static const int typeKey = 449;
  @override
  int get coreType => ViewModelInstanceBooleanBase.typeKey;
  @override
  Set<int> get coreTypes => {
        ViewModelInstanceBooleanBase.typeKey,
        ViewModelInstanceValueBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// PropertyValue field with key 593.
  static const int propertyValuePropertyKey = 593;
  static const bool propertyValueInitialValue = false;
  bool _propertyValue = propertyValueInitialValue;

  /// The boolean value.
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
    if (source is ViewModelInstanceBooleanBase) {
      _propertyValue = source._propertyValue;
    }
  }
}
