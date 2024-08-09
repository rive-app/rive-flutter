// Core automatically generated
// lib/src/generated/data_bind/data_bind_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class DataBindBase<T extends CoreContext> extends Core<T> {
  static const int typeKey = 446;
  @override
  int get coreType => DataBindBase.typeKey;
  @override
  Set<int> get coreTypes => {DataBindBase.typeKey};

  /// --------------------------------------------------------------------------
  /// PropertyKey field with key 586.
  static const int propertyKeyPropertyKey = 586;
  static const int propertyKeyInitialValue = CoreContext.invalidPropertyKey;
  int _propertyKey = propertyKeyInitialValue;

  /// The property that is targeted.
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

  /// --------------------------------------------------------------------------
  /// Flags field with key 587.
  static const int flagsPropertyKey = 587;
  static const int flagsInitialValue = 0;
  int _flags = flagsInitialValue;
  int get flags => _flags;

  /// Change the [_flags] field value.
  /// [flagsChanged] will be invoked only if the field's value has changed.
  set flags(int value) {
    if (_flags == value) {
      return;
    }
    int from = _flags;
    _flags = value;
    if (hasValidated) {
      flagsChanged(from, value);
    }
  }

  void flagsChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// ConverterId field with key 660.
  static const int converterIdPropertyKey = 660;
  static const int converterIdInitialValue = -1;
  int _converterId = converterIdInitialValue;

  /// Identifier used to link to a data converter.
  int get converterId => _converterId;

  /// Change the [_converterId] field value.
  /// [converterIdChanged] will be invoked only if the field's value has
  /// changed.
  set converterId(int value) {
    if (_converterId == value) {
      return;
    }
    int from = _converterId;
    _converterId = value;
    if (hasValidated) {
      converterIdChanged(from, value);
    }
  }

  void converterIdChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is DataBindBase) {
      _propertyKey = source._propertyKey;
      _flags = source._flags;
      _converterId = source._converterId;
    }
  }
}
