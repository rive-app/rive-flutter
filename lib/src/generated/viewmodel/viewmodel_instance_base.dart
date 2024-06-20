// Core automatically generated
// lib/src/generated/viewmodel/viewmodel_instance_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/component.dart';

abstract class ViewModelInstanceBase extends Component {
  static const int typeKey = 437;
  @override
  int get coreType => ViewModelInstanceBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {ViewModelInstanceBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// ViewModelId field with key 566.
  static const int viewModelIdPropertyKey = 566;
  static const int viewModelIdInitialValue = 0;
  int _viewModelId = viewModelIdInitialValue;
  int get viewModelId => _viewModelId;

  /// Change the [_viewModelId] field value.
  /// [viewModelIdChanged] will be invoked only if the field's value has
  /// changed.
  set viewModelId(int value) {
    if (_viewModelId == value) {
      return;
    }
    int from = _viewModelId;
    _viewModelId = value;
    if (hasValidated) {
      viewModelIdChanged(from, value);
    }
  }

  void viewModelIdChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is ViewModelInstanceBase) {
      _viewModelId = source._viewModelId;
    }
  }
}
