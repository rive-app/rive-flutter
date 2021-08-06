/// Core automatically generated lib/src/generated/component_base.dart.
/// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class ComponentBase<T extends CoreContext> extends Core<T> {
  static const int typeKey = 10;
  @override
  int get coreType => ComponentBase.typeKey;
  @override
  Set<int> get coreTypes => {ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Name field with key 4.
  static const String nameInitialValue = '';
  String _name = nameInitialValue;
  static const int namePropertyKey = 4;

  /// Non-unique identifier, used to give friendly names to elements in the
  /// hierarchy. Runtimes provide an API for finding components by this [name].
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

  /// --------------------------------------------------------------------------
  /// ParentId field with key 5.
  static const int parentIdInitialValue = 0;
  int _parentId = parentIdInitialValue;
  static const int parentIdPropertyKey = 5;

  /// Identifier used to track parent ContainerComponent.
  int get parentId => _parentId;

  /// Change the [_parentId] field value.
  /// [parentIdChanged] will be invoked only if the field's value has changed.
  set parentId(int value) {
    if (_parentId == value) {
      return;
    }
    int from = _parentId;
    _parentId = value;
    if (hasValidated) {
      parentIdChanged(from, value);
    }
  }

  void parentIdChanged(int from, int to);

  @override
  void copy(covariant ComponentBase source) {
    _name = source._name;
    _parentId = source._parentId;
  }
}
