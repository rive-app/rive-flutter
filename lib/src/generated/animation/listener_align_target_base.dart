// Core automatically generated
// lib/src/generated/animation/listener_align_target_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/listener_action.dart';

abstract class ListenerAlignTargetBase extends ListenerAction {
  static const int typeKey = 126;
  @override
  int get coreType => ListenerAlignTargetBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {ListenerAlignTargetBase.typeKey, ListenerActionBase.typeKey};

  /// --------------------------------------------------------------------------
  /// TargetId field with key 240.
  static const int targetIdPropertyKey = 240;
  static const int targetIdInitialValue = 0;
  int _targetId = targetIdInitialValue;

  /// Identifier used to track the object use as a target fo this listener
  /// action.
  int get targetId => _targetId;

  /// Change the [_targetId] field value.
  /// [targetIdChanged] will be invoked only if the field's value has changed.
  set targetId(int value) {
    if (_targetId == value) {
      return;
    }
    int from = _targetId;
    _targetId = value;
    if (hasValidated) {
      targetIdChanged(from, value);
    }
  }

  void targetIdChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// PreserveOffset field with key 541.
  static const int preserveOffsetPropertyKey = 541;
  static const bool preserveOffsetInitialValue = false;
  bool _preserveOffset = preserveOffsetInitialValue;

  /// Whether to preserve offset between mouse position and target position.
  bool get preserveOffset => _preserveOffset;

  /// Change the [_preserveOffset] field value.
  /// [preserveOffsetChanged] will be invoked only if the field's value has
  /// changed.
  set preserveOffset(bool value) {
    if (_preserveOffset == value) {
      return;
    }
    bool from = _preserveOffset;
    _preserveOffset = value;
    if (hasValidated) {
      preserveOffsetChanged(from, value);
    }
  }

  void preserveOffsetChanged(bool from, bool to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is ListenerAlignTargetBase) {
      _targetId = source._targetId;
      _preserveOffset = source._preserveOffset;
    }
  }
}
