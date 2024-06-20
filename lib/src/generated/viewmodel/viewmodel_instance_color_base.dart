// Core automatically generated
// lib/src/generated/viewmodel/viewmodel_instance_color_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/viewmodel/viewmodel_instance_value_base.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_value.dart';

abstract class ViewModelInstanceColorBase extends ViewModelInstanceValue {
  static const int typeKey = 426;
  @override
  int get coreType => ViewModelInstanceColorBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {ViewModelInstanceColorBase.typeKey, ViewModelInstanceValueBase.typeKey};

  /// --------------------------------------------------------------------------
  /// PropertyValue field with key 555.
  static const int propertyValuePropertyKey = 555;
  static const int propertyValueInitialValue = 0xFF1D1D1D;
  int _propertyValue = propertyValueInitialValue;

  /// The color value
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
    if (source is ViewModelInstanceColorBase) {
      _propertyValue = source._propertyValue;
    }
  }
}
