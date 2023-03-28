/// Core automatically generated lib/src/generated/solo_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/transform_component_base.dart';
import 'package:rive/src/generated/world_transform_component_base.dart';
import 'package:rive/src/rive_core/node.dart';

abstract class SoloBase extends Node {
  static const int typeKey = 147;
  @override
  int get coreType => SoloBase.typeKey;
  @override
  Set<int> get coreTypes => {
        SoloBase.typeKey,
        NodeBase.typeKey,
        TransformComponentBase.typeKey,
        WorldTransformComponentBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// ActiveComponentId field with key 296.
  static const int activeComponentIdInitialValue = 0;
  int _activeComponentId = activeComponentIdInitialValue;
  static const int activeComponentIdPropertyKey = 296;

  /// Identifier of the active child in the solo set.
  int get activeComponentId => _activeComponentId;

  /// Change the [_activeComponentId] field value.
  /// [activeComponentIdChanged] will be invoked only if the field's value has
  /// changed.
  set activeComponentId(int value) {
    if (_activeComponentId == value) {
      return;
    }
    int from = _activeComponentId;
    _activeComponentId = value;
    if (hasValidated) {
      activeComponentIdChanged(from, value);
    }
  }

  void activeComponentIdChanged(int from, int to);

  @override
  void copy(covariant SoloBase source) {
    super.copy(source);
    _activeComponentId = source._activeComponentId;
  }
}
