// Core automatically generated
// lib/src/generated/viewmodel/viewmodel_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_component.dart';

abstract class ViewModelBase extends ViewModelComponent {
  static const int typeKey = 435;
  @override
  int get coreType => ViewModelBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {ViewModelBase.typeKey, ViewModelComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// DefaultInstanceId field with key 564.
  static const int defaultInstanceIdPropertyKey = 564;
  static const int defaultInstanceIdInitialValue = -1;
  int _defaultInstanceId = defaultInstanceIdInitialValue;

  /// The default instance attached to the view model.
  int get defaultInstanceId => _defaultInstanceId;

  /// Change the [_defaultInstanceId] field value.
  /// [defaultInstanceIdChanged] will be invoked only if the field's value has
  /// changed.
  set defaultInstanceId(int value) {
    if (_defaultInstanceId == value) {
      return;
    }
    int from = _defaultInstanceId;
    _defaultInstanceId = value;
    if (hasValidated) {
      defaultInstanceIdChanged(from, value);
    }
  }

  void defaultInstanceIdChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is ViewModelBase) {
      _defaultInstanceId = source._defaultInstanceId;
    }
  }
}
