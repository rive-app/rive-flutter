// Core automatically generated
// lib/src/generated/data_bind/data_bind_context_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/rive_core/data_bind/data_bind.dart';

abstract class DataBindContextBase extends DataBind {
  static const int typeKey = 447;
  @override
  int get coreType => DataBindContextBase.typeKey;
  @override
  Set<int> get coreTypes => {
        DataBindContextBase.typeKey,
        DataBindBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// SourcePathIds field with key 588.
  static const int sourcePathIdsPropertyKey = 588;
  static final Uint8List sourcePathIdsInitialValue = Uint8List(0);
  Uint8List _sourcePathIds = sourcePathIdsInitialValue;

  /// Path to the selected property.
  Uint8List get sourcePathIds => _sourcePathIds;

  /// Change the [_sourcePathIds] field value.
  /// [sourcePathIdsChanged] will be invoked only if the field's value has
  /// changed.
  set sourcePathIds(Uint8List value) {
    if (listEquals(_sourcePathIds, value)) {
      return;
    }
    Uint8List from = _sourcePathIds;
    _sourcePathIds = value;
    if (hasValidated) {
      sourcePathIdsChanged(from, value);
    }
  }

  void sourcePathIdsChanged(Uint8List from, Uint8List to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is DataBindContextBase) {
      _sourcePathIds = source._sourcePathIds;
    }
  }
}
