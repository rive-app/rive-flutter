// Core automatically generated
// lib/src/generated/data_bind/converters/data_converter_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class DataConverterBase<T extends CoreContext> extends Core<T> {
  static const int typeKey = 488;
  @override
  int get coreType => DataConverterBase.typeKey;
  @override
  Set<int> get coreTypes => {DataConverterBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Name field with key 662.
  static const int namePropertyKey = 662;
  static const String nameInitialValue = '';
  String _name = nameInitialValue;

  /// Non-unique identifier, used to give friendly names to data converters.
  String get name => _name;

  /// Change the [_name] field value.
  /// [nameChanged] will be invoked only if the field's value has changed.
  set name(String value) {
    if (_name == value) {
      return;
    }
    String from = _name;
    _name = value;
    if (hasValidated) {
      nameChanged(from, value);
    }
  }

  void nameChanged(String from, String to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is DataConverterBase) {
      _name = source._name;
    }
  }
}
