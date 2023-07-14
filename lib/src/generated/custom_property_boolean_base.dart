// Core automatically generated
// lib/src/generated/custom_property_boolean_base.dart.
// Do not modify manually.

import 'package:rive/src/rive_core/component.dart';

abstract class CustomPropertyBooleanBase extends Component {
  static const int typeKey = 129;
  @override
  int get coreType => CustomPropertyBooleanBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {CustomPropertyBooleanBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// PropertyValue field with key 245.
  static const bool propertyValueInitialValue = false;
  bool _propertyValue = propertyValueInitialValue;
  static const int propertyValuePropertyKey = 245;
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
  void copy(covariant CustomPropertyBooleanBase source) {
    super.copy(source);
    _propertyValue = source._propertyValue;
  }
}
