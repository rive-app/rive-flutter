// Core automatically generated
// lib/src/generated/world_transform_component_base.dart.
// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/container_component.dart';

const _coreTypes = {
  WorldTransformComponentBase.typeKey,
  ContainerComponentBase.typeKey,
  ComponentBase.typeKey
};

abstract class WorldTransformComponentBase extends ContainerComponent {
  static const int typeKey = 91;
  @override
  int get coreType => WorldTransformComponentBase.typeKey;
  @override
  Set<int> get coreTypes => _coreTypes;

  /// --------------------------------------------------------------------------
  /// Opacity field with key 18.
  static const int opacityPropertyKey = 18;
  static const double opacityInitialValue = 1;

  @nonVirtual
  double opacity_ = opacityInitialValue;
  @nonVirtual
  double get opacity => opacity_;

  /// Change the [opacity_] field value.
  /// [opacityChanged] will be invoked only if the field's value has changed.
  set opacity(double value) {
    if (opacity_ == value) {
      return;
    }
    double from = opacity_;
    opacity_ = value;
    if (hasValidated) {
      opacityChanged(from, value);
    }
  }

  void opacityChanged(double from, double to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is WorldTransformComponentBase) {
      opacity_ = source.opacity_;
    }
  }
}
