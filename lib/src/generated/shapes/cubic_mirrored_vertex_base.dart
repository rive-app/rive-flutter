// Core automatically generated
// lib/src/generated/shapes/cubic_mirrored_vertex_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/shapes/path_vertex_base.dart';
import 'package:rive/src/generated/shapes/vertex_base.dart';
import 'package:rive/src/rive_core/shapes/cubic_vertex.dart';

const _coreTypes = {
  CubicMirroredVertexBase.typeKey,
  CubicVertexBase.typeKey,
  PathVertexBase.typeKey,
  VertexBase.typeKey,
  ContainerComponentBase.typeKey,
  ComponentBase.typeKey
};

abstract class CubicMirroredVertexBase extends CubicVertex {
  static const int typeKey = 35;
  @override
  int get coreType => CubicMirroredVertexBase.typeKey;
  @override
  Set<int> get coreTypes => _coreTypes;

  /// --------------------------------------------------------------------------
  /// Rotation field with key 82.
  static const int rotationPropertyKey = 82;
  static const double rotationInitialValue = 0;

  @nonVirtual
  double rotation_ = rotationInitialValue;

  /// The control points' angle.
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
  /// Distance field with key 83.
  static const int distancePropertyKey = 83;
  static const double distanceInitialValue = 0;

  @nonVirtual
  double distance_ = distanceInitialValue;

  /// The control points' distance from the translation of the point.
  @nonVirtual
  double get distance => distance_;

  /// Change the [distance_] field value.
  /// [distanceChanged] will be invoked only if the field's value has changed.
  set distance(double value) {
    if (distance_ == value) {
      return;
    }
    double from = distance_;
    distance_ = value;
    if (hasValidated) {
      distanceChanged(from, value);
    }
  }

  void distanceChanged(double from, double to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is CubicMirroredVertexBase) {
      rotation_ = source.rotation_;
      distance_ = source.distance_;
    }
  }
}
