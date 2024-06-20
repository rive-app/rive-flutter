// Core automatically generated
// lib/src/generated/viewmodel/viewmodel_instance_number_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/viewmodel/viewmodel_instance_value_base.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_value.dart';

abstract class ViewModelInstanceNumberBase extends ViewModelInstanceValue {
  static const int typeKey = 442;
  @override
  int get coreType => ViewModelInstanceNumberBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {ViewModelInstanceNumberBase.typeKey, ViewModelInstanceValueBase.typeKey};

  /// --------------------------------------------------------------------------
  /// PropertyValue field with key 575.
  static const int propertyValuePropertyKey = 575;
  static const double propertyValueInitialValue = 0;
  double _propertyValue = propertyValueInitialValue;

  /// The number value.
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
    if (source is ViewModelInstanceNumberBase) {
      _propertyValue = source._propertyValue;
    }
  }
}
