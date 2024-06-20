// Core automatically generated
// lib/src/generated/viewmodel/viewmodel_instance_value_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class ViewModelInstanceValueBase<T extends CoreContext>
    extends Core<T> {
  static const int typeKey = 428;
  @override
  int get coreType => ViewModelInstanceValueBase.typeKey;
  @override
  Set<int> get coreTypes => {ViewModelInstanceValueBase.typeKey};

  /// --------------------------------------------------------------------------
  /// ViewModelPropertyId field with key 554.
  static const int viewModelPropertyIdPropertyKey = 554;
  static const int viewModelPropertyIdInitialValue = 0;
  int _viewModelPropertyId = viewModelPropertyIdInitialValue;

  /// Identifier of the property this value will provide data for. At runtime
  /// these ids are normalized relative to the ViewModel itself.
  int get viewModelPropertyId => _viewModelPropertyId;

  /// Change the [_viewModelPropertyId] field value.
  /// [viewModelPropertyIdChanged] will be invoked only if the field's value has
  /// changed.
  set viewModelPropertyId(int value) {
    if (_viewModelPropertyId == value) {
      return;
    }
    int from = _viewModelPropertyId;
    _viewModelPropertyId = value;
    if (hasValidated) {
      viewModelPropertyIdChanged(from, value);
    }
  }

  void viewModelPropertyIdChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is ViewModelInstanceValueBase) {
      _viewModelPropertyId = source._viewModelPropertyId;
    }
  }
}
