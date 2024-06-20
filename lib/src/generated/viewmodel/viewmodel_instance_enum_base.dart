// Core automatically generated
// lib/src/generated/viewmodel/viewmodel_instance_enum_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/viewmodel/viewmodel_instance_value_base.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_value.dart';

abstract class ViewModelInstanceEnumBase extends ViewModelInstanceValue {
  static const int typeKey = 432;
  @override
  int get coreType => ViewModelInstanceEnumBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {ViewModelInstanceEnumBase.typeKey, ViewModelInstanceValueBase.typeKey};

  /// --------------------------------------------------------------------------
  /// PropertyValue field with key 560.
  static const int propertyValuePropertyKey = 560;
  static const int propertyValueInitialValue = 0;
  int _propertyValue = propertyValueInitialValue;

  /// The id of the enum value.
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
    if (source is ViewModelInstanceEnumBase) {
      _propertyValue = source._propertyValue;
    }
  }
}
