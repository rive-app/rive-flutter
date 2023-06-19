import 'package:rive/src/rive_core/component.dart';

abstract class CustomPropertyNumberBase extends Component {
  static const int typeKey = 127;
  @override
  int get coreType => CustomPropertyNumberBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {CustomPropertyNumberBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// PropertyValue field with key 243.
  static const double propertyValueInitialValue = 0;
  double _propertyValue = propertyValueInitialValue;
  static const int propertyValuePropertyKey = 243;
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
  void copy(covariant CustomPropertyNumberBase source) {
    super.copy(source);
    _propertyValue = source._propertyValue;
  }
}
