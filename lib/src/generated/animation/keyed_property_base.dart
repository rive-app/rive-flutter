/// Core automatically generated
/// lib/src/generated/animation/keyed_property_base.dart.
/// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class KeyedPropertyBase<T extends CoreContext> extends Core<T> {
  static const int typeKey = 26;
  @override
  int get coreType => KeyedPropertyBase.typeKey;
  @override
  Set<int> get coreTypes => {KeyedPropertyBase.typeKey};

  /// --------------------------------------------------------------------------
  /// PropertyKey field with key 53.
  static const int propertyKeyInitialValue = CoreContext.invalidPropertyKey;
  int _propertyKey = propertyKeyInitialValue;
  static const int propertyKeyPropertyKey = 53;

  /// The property type that is keyed.
  int get propertyKey => _propertyKey;

  /// Change the [_propertyKey] field value.
  /// [propertyKeyChanged] will be invoked only if the field's value has
  /// changed.
  set propertyKey(int value) {
    if (_propertyKey == value) {
      return;
    }
    int from = _propertyKey;
    _propertyKey = value;
    if (hasValidated) {
      propertyKeyChanged(from, value);
    }
  }

  void propertyKeyChanged(int from, int to);

  @override
  void copy(covariant KeyedPropertyBase source) {
    _propertyKey = source._propertyKey;
  }
}
