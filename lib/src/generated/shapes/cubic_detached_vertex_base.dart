// Core automatically generated
// lib/src/generated/shapes/cubic_detached_vertex_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/shapes/path_vertex_base.dart';
import 'package:rive/src/generated/shapes/vertex_base.dart';
import 'package:rive/src/rive_core/shapes/cubic_vertex.dart';

abstract class CubicDetachedVertexBase extends CubicVertex {
  static const int typeKey = 6;
  @override
  int get coreType => CubicDetachedVertexBase.typeKey;
  @override
  Set<int> get coreTypes => {
        CubicDetachedVertexBase.typeKey,
        CubicVertexBase.typeKey,
        PathVertexBase.typeKey,
        VertexBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// InRotation field with key 84.
  static const int inRotationPropertyKey = 84;
  static const double inRotationInitialValue = 0;
  double inRotation_ = inRotationInitialValue;

  /// The in point's angle.
  @nonVirtual
  double get inRotation => inRotation_;

  /// Change the [inRotation_] field value.
  /// [inRotationChanged] will be invoked only if the field's value has changed.
  @nonVirtual
  set inRotation(double value) {
    if (inRotation_ == value) {
      return;
    }
    double from = inRotation_;
    inRotation_ = value;
    if (hasValidated) {
      inRotationChanged(from, value);
    }
  }

  void inRotationChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// InDistance field with key 85.
  static const int inDistancePropertyKey = 85;
  static const double inDistanceInitialValue = 0;
  double inDistance_ = inDistanceInitialValue;

  /// The in point's distance from the translation of the point.
  @nonVirtual
  double get inDistance => inDistance_;

  /// Change the [inDistance_] field value.
  /// [inDistanceChanged] will be invoked only if the field's value has changed.
  @nonVirtual
  set inDistance(double value) {
    if (inDistance_ == value) {
      return;
    }
    double from = inDistance_;
    inDistance_ = value;
    if (hasValidated) {
      inDistanceChanged(from, value);
    }
  }

  void inDistanceChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// OutRotation field with key 86.
  static const int outRotationPropertyKey = 86;
  static const double outRotationInitialValue = 0;
  double outRotation_ = outRotationInitialValue;

  /// The out point's angle.
  @nonVirtual
  double get outRotation => outRotation_;

  /// Change the [outRotation_] field value.
  /// [outRotationChanged] will be invoked only if the field's value has
  /// changed.
  @nonVirtual
  set outRotation(double value) {
    if (outRotation_ == value) {
      return;
    }
    double from = outRotation_;
    outRotation_ = value;
    if (hasValidated) {
      outRotationChanged(from, value);
    }
  }

  void outRotationChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// OutDistance field with key 87.
  static const int outDistancePropertyKey = 87;
  static const double outDistanceInitialValue = 0;
  double outDistance_ = outDistanceInitialValue;

  /// The out point's distance from the translation of the point.
  @nonVirtual
  double get outDistance => outDistance_;

  /// Change the [outDistance_] field value.
  /// [outDistanceChanged] will be invoked only if the field's value has
  /// changed.
  @nonVirtual
  set outDistance(double value) {
    if (outDistance_ == value) {
      return;
    }
    double from = outDistance_;
    outDistance_ = value;
    if (hasValidated) {
      outDistanceChanged(from, value);
    }
  }

  void outDistanceChanged(double from, double to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is CubicDetachedVertexBase) {
      inRotation_ = source.inRotation_;
      inDistance_ = source.inDistance_;
      outRotation_ = source.outRotation_;
      outDistance_ = source.outDistance_;
    }
  }
}
