// Core automatically generated
// lib/src/generated/viewmodel/viewmodel_property_enum_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/viewmodel/viewmodel_component_base.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_property.dart';

abstract class ViewModelPropertyEnumBase extends ViewModelProperty {
  static const int typeKey = 439;
  @override
  int get coreType => ViewModelPropertyEnumBase.typeKey;
  @override
  Set<int> get coreTypes => {
        ViewModelPropertyEnumBase.typeKey,
        ViewModelPropertyBase.typeKey,
        ViewModelComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// EnumId field with key 574.
  static const int enumIdPropertyKey = 574;
  static const int enumIdInitialValue = -1;
  int _enumId = enumIdInitialValue;

  /// The id of the enum.
  int get enumId => _enumId;

  /// Change the [_enumId] field value.
  /// [enumIdChanged] will be invoked only if the field's value has changed.
  set enumId(int value) {
    if (_enumId == value) {
      return;
    }
    int from = _enumId;
    _enumId = value;
    if (hasValidated) {
      enumIdChanged(from, value);
    }
  }

  void enumIdChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is ViewModelPropertyEnumBase) {
      _enumId = source._enumId;
    }
  }
}
