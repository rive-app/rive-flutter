// Core automatically generated lib/src/generated/component_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';

const _coreTypes = {ComponentBase.typeKey};

abstract class ComponentBase<T extends CoreContext> extends Core<T> {
  static const int typeKey = 10;
  @override
  int get coreType => ComponentBase.typeKey;
  @override
  Set<int> get coreTypes => _coreTypes;

  /// --------------------------------------------------------------------------
  /// Name field with key 4.
  static const int namePropertyKey = 4;
  static const String nameInitialValue = '';

  @nonVirtual
  String name_ = nameInitialValue;

  /// Non-unique identifier, used to give friendly names to elements in the
  /// hierarchy. Runtimes provide an API for finding components by this [name].
  @nonVirtual
  String get name => name_;

  /// Change the [name_] field value.
  /// [nameChanged] will be invoked only if the field's value has changed.
  set name(String value) {
    if (name_ == value) {
      return;
    }
    String from = name_;
    name_ = value;
    if (hasValidated) {
      nameChanged(from, value);
    }
  }

  void nameChanged(String from, String to);

  /// --------------------------------------------------------------------------
  /// ParentId field with key 5.
  static const int parentIdPropertyKey = 5;
  static const int parentIdInitialValue = 0;

  @nonVirtual
  int parentId_ = parentIdInitialValue;

  /// Identifier used to track parent ContainerComponent.
  @nonVirtual
  int get parentId => parentId_;

  /// Change the [parentId_] field value.
  /// [parentIdChanged] will be invoked only if the field's value has changed.
  set parentId(int value) {
    if (parentId_ == value) {
      return;
    }
    int from = parentId_;
    parentId_ = value;
    if (hasValidated) {
      parentIdChanged(from, value);
    }
  }

  void parentIdChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is ComponentBase) {
      name_ = source.name_;
      parentId_ = source.parentId_;
    }
  }
}
