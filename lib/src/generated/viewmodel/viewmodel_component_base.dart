// Core automatically generated
// lib/src/generated/viewmodel/viewmodel_component_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class ViewModelComponentBase<T extends CoreContext> extends Core<T> {
  static const int typeKey = 429;
  @override
  int get coreType => ViewModelComponentBase.typeKey;
  @override
  Set<int> get coreTypes => {ViewModelComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Name field with key 557.
  static const int namePropertyKey = 557;
  static const String nameInitialValue = '';
  String _name = nameInitialValue;

  /// Non-unique identifier, used to give friendly names to any view model
  /// component.
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
    if (source is ViewModelComponentBase) {
      _name = source._name;
    }
  }
}
