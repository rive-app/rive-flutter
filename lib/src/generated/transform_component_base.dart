// Core automatically generated
// lib/src/generated/transform_component_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/world_transform_component.dart';

const _coreTypes = {
  TransformComponentBase.typeKey,
  WorldTransformComponentBase.typeKey,
  ContainerComponentBase.typeKey,
  ComponentBase.typeKey
};

abstract class TransformComponentBase extends WorldTransformComponent {
  static const int typeKey = 38;
  @override
  int get coreType => TransformComponentBase.typeKey;
  @override
  Set<int> get coreTypes => _coreTypes;

  /// --------------------------------------------------------------------------
  /// Rotation field with key 15.
  static const int rotationPropertyKey = 15;
  static const double rotationInitialValue = 0;

  @nonVirtual
  double rotation_ = rotationInitialValue;
  @nonVirtual
  double get rotation => rotation_;

  /// Change the [rotation_] field value.
  /// [rotationChanged] will be invoked only if the field's value has changed.
  set rotation(double value) {
    if (rotation_ == value) {
      return;
    }
    double from = rotation_;
    rotation_ = value;
    if (hasValidated) {
      rotationChanged(from, value);
    }
  }

  void rotationChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// ScaleX field with key 16.
  static const int scaleXPropertyKey = 16;
  static const double scaleXInitialValue = 1;

  @nonVirtual
  double scaleX_ = scaleXInitialValue;

  @nonVirtual
  double get scaleX => scaleX_;

  /// Change the [scaleX_] field value.
  /// [scaleXChanged] will be invoked only if the field's value has changed.
  set scaleX(double value) {
    if (scaleX_ == value) {
      return;
    }
    double from = scaleX_;
    scaleX_ = value;
    if (hasValidated) {
      scaleXChanged(from, value);
    }
  }

  void scaleXChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// ScaleY field with key 17.
  static const int scaleYPropertyKey = 17;
  static const double scaleYInitialValue = 1;

  @nonVirtual
  double scaleY_ = scaleYInitialValue;

  @nonVirtual
  double get scaleY => scaleY_;

  /// Change the [scaleY_] field value.
  /// [scaleYChanged] will be invoked only if the field's value has changed.
  set scaleY(double value) {
    if (scaleY_ == value) {
      return;
    }
    double from = scaleY_;
    scaleY_ = value;
    if (hasValidated) {
      scaleYChanged(from, value);
    }
  }

  void scaleYChanged(double from, double to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is TransformComponentBase) {
      rotation_ = source.rotation_;
      scaleX_ = source.scaleX_;
      scaleY_ = source.scaleY_;
    }
  }
}
