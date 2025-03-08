// Core automatically generated
// lib/src/generated/animation/keyed_property_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';

import '../rive_core_beans.dart';

const _coreTypes = <int>{KeyedPropertyBase.typeKey};

abstract class KeyedPropertyBase<T extends CoreContext> extends Core<T> {
  static const int typeKey = 26;
  @override
  int get coreType => KeyedPropertyBase.typeKey;
  @override
  Set<int> get coreTypes => _coreTypes;

  /// --------------------------------------------------------------------------
  /// PropertyKey field with key 53.
  static const int propertyKeyPropertyKey = 53;
  // static const int propertyKeyInitialValue = CoreContext.invalidPropertyKey;

  /// STOKANAL-FORK-EDIT: exposing
  // int propertyKey_ = CoreContext.invalidPropertyKey;
  PropertyBean propertyBean = PropertyBeans.invalid;

  /// The property type that is keyed.
  // int get propertyKey => propertyKey_;
  int get propertyKey => propertyBean.propertyKey;

  /// Change the [propertyKey_] field value.
  /// [propertyKeyChanged] will be invoked only if the field's value has
  /// changed.
  @nonVirtual
  set propertyKey(int value) {
    if (propertyKey == value) {
      return;
    }

    // int from = propertyKey_;

    // propertyKey_ = value;
    propertyBean = PropertyBeans.get(value);

    // if (hasValidated) {
    //   propertyKeyChanged(from, value);
    // }
  }

  // void propertyKeyChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is KeyedPropertyBase) {
      // propertyKey_ = source.propertyKey_;
      propertyBean = source.propertyBean;
    }
  }
}
