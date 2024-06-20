// Core automatically generated
// lib/src/generated/viewmodel/data_enum_value_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class DataEnumValueBase<T extends CoreContext> extends Core<T> {
  static const int typeKey = 445;
  @override
  int get coreType => DataEnumValueBase.typeKey;
  @override
  Set<int> get coreTypes => {DataEnumValueBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Key field with key 578.
  static const int keyPropertyKey = 578;
  static const String keyInitialValue = '';
  String _key = keyInitialValue;

  /// The key of this key value enum pair.
  String get key => _key;

  /// Change the [_key] field value.
  /// [keyChanged] will be invoked only if the field's value has changed.
  set key(String value) {
    if (_key == value) {
      return;
    }
    String from = _key;
    _key = value;
    if (hasValidated) {
      keyChanged(from, value);
    }
  }

  void keyChanged(String from, String to);

  /// --------------------------------------------------------------------------
  /// Value field with key 579.
  static const int valuePropertyKey = 579;
  static const String valueInitialValue = '';
  String _value = valueInitialValue;

  /// The value of this key value enum pair.
  String get value => _value;

  /// Change the [_value] field value.
  /// [valueChanged] will be invoked only if the field's value has changed.
  set value(String value) {
    if (_value == value) {
      return;
    }
    String from = _value;
    _value = value;
    if (hasValidated) {
      valueChanged(from, value);
    }
  }

  void valueChanged(String from, String to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is DataEnumValueBase) {
      _key = source._key;
      _value = source._value;
    }
  }
}
