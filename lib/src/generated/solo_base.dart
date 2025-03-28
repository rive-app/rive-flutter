// Core automatically generated lib/src/generated/solo_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/transform_component_base.dart';
import 'package:rive/src/generated/world_transform_component_base.dart';
import 'package:rive/src/rive_core/node.dart';

const _coreTypes = {
  SoloBase.typeKey,
  NodeBase.typeKey,
  TransformComponentBase.typeKey,
  WorldTransformComponentBase.typeKey,
  ContainerComponentBase.typeKey,
  ComponentBase.typeKey
};

abstract class SoloBase extends Node {
  static const int typeKey = 147;
  @override
  int get coreType => SoloBase.typeKey;
  @override
  Set<int> get coreTypes => _coreTypes;

  /// --------------------------------------------------------------------------
  /// ActiveComponentId field with key 296.
  static const int activeComponentIdPropertyKey = 296;
  static const int activeComponentIdInitialValue = 0;

  @nonVirtual
  int activeComponentId_ = activeComponentIdInitialValue;

  /// Identifier of the active child in the solo set.
  @nonVirtual
  int get activeComponentId => activeComponentId_;

  /// Change the [activeComponentId_] field value.
  /// [activeComponentIdChanged] will be invoked only if the field's value has
  /// changed.
  set activeComponentId(int value) {
    if (activeComponentId_ == value) {
      return;
    }
    int from = activeComponentId_;
    activeComponentId_ = value;
    if (hasValidated) {
      activeComponentIdChanged(from, value);
    }
  }

  void activeComponentIdChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is SoloBase) {
      activeComponentId_ = source.activeComponentId_;
    }
  }
}
