/// Core automatically generated
/// lib/src/generated/custom_property_string_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/component.dart';

abstract class CustomPropertyStringBase extends Component {
  static const int typeKey = 130;
  @override
  int get coreType => CustomPropertyStringBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {CustomPropertyStringBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// PropertyValue field with key 246.
  static const String propertyValueInitialValue = '';
  String _propertyValue = propertyValueInitialValue;
  static const int propertyValuePropertyKey = 246;
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
  void copy(covariant CustomPropertyStringBase source) {
    super.copy(source);
    _propertyValue = source._propertyValue;
  }
}
