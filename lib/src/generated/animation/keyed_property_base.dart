// Core automatically generated
// lib/src/generated/animation/keyed_property_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class KeyedPropertyBase<T extends CoreContext> extends Core<T> {
  static const int typeKey = 26;
  @override
  int get coreType => KeyedPropertyBase.typeKey;
  @override
  Set<int> get coreTypes => {KeyedPropertyBase.typeKey};

  /// --------------------------------------------------------------------------
  /// PropertyKey field with key 53.
  static const int propertyKeyPropertyKey = 53;
  static const int propertyKeyInitialValue = CoreContext.invalidPropertyKey;

  /// STOKANAL-FORK-EDIT: exposing
  int propertyKey_ = propertyKeyInitialValue;

  /// The property type that is keyed.
  int get propertyKey => propertyKey_;

  /// Change the [propertyKey_] field value.
  /// [propertyKeyChanged] will be invoked only if the field's value has
  /// changed.
  set propertyKey(int value) {
    if (propertyKey_ == value) {
      return;
    }
    int from = propertyKey_;
    propertyKey_ = value;
    if (hasValidated) {
      propertyKeyChanged(from, value);
    }
  }

  void propertyKeyChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is KeyedPropertyBase) {
      propertyKey_ = source.propertyKey_;
    }
  }
}
