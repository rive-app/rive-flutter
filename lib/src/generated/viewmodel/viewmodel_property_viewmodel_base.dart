// Core automatically generated
// lib/src/generated/viewmodel/viewmodel_property_viewmodel_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/viewmodel/viewmodel_component_base.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_property.dart';

abstract class ViewModelPropertyViewModelBase extends ViewModelProperty {
  static const int typeKey = 436;
  @override
  int get coreType => ViewModelPropertyViewModelBase.typeKey;
  @override
  Set<int> get coreTypes => {
        ViewModelPropertyViewModelBase.typeKey,
        ViewModelPropertyBase.typeKey,
        ViewModelComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// ViewModelReferenceId field with key 565.
  static const int viewModelReferenceIdPropertyKey = 565;
  static const int viewModelReferenceIdInitialValue = 0;
  int _viewModelReferenceId = viewModelReferenceIdInitialValue;

  /// Identifier used to track the viewmodel this property points to.
  int get viewModelReferenceId => _viewModelReferenceId;

  /// Change the [_viewModelReferenceId] field value.
  /// [viewModelReferenceIdChanged] will be invoked only if the field's value
  /// has changed.
  set viewModelReferenceId(int value) {
    if (_viewModelReferenceId == value) {
      return;
    }
    int from = _viewModelReferenceId;
    _viewModelReferenceId = value;
    if (hasValidated) {
      viewModelReferenceIdChanged(from, value);
    }
  }

  void viewModelReferenceIdChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is ViewModelPropertyViewModelBase) {
      _viewModelReferenceId = source._viewModelReferenceId;
    }
  }
}
