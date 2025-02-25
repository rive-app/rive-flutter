// Core automatically generated
// lib/src/generated/shapes/cubic_asymmetric_vertex_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/shapes/path_vertex_base.dart';
import 'package:rive/src/generated/shapes/vertex_base.dart';
import 'package:rive/src/rive_core/shapes/cubic_vertex.dart';

const _coreTypes = {
  CubicAsymmetricVertexBase.typeKey,
  CubicVertexBase.typeKey,
  PathVertexBase.typeKey,
  VertexBase.typeKey,
  ContainerComponentBase.typeKey,
  ComponentBase.typeKey
};

abstract class CubicAsymmetricVertexBase extends CubicVertex {
  static const int typeKey = 34;
  @override
  int get coreType => CubicAsymmetricVertexBase.typeKey;
  @override
  Set<int> get coreTypes => _coreTypes;

  /// --------------------------------------------------------------------------
  /// Rotation field with key 79.
  static const int rotationPropertyKey = 79;
  static const double rotationInitialValue = 0;
  double rotation_ = rotationInitialValue;

  /// The control points' angle.
  @nonVirtual
  double get rotation => rotation_;

  /// Change the [rotation_] field value.
  /// [rotationChanged] will be invoked only if the field's value has changed.
  @nonVirtual
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
  /// InDistance field with key 80.
  static const int inDistancePropertyKey = 80;
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
  /// OutDistance field with key 81.
  static const int outDistancePropertyKey = 81;
  static const double outDistanceInitialValue = 0;
  double _outDistance = outDistanceInitialValue;

  /// The out point's distance from the translation of the point.
  double get outDistance => _outDistance;

  /// Change the [_outDistance] field value.
  /// [outDistanceChanged] will be invoked only if the field's value has
  /// changed.
  set outDistance(double value) {
    if (_outDistance == value) {
      return;
    }
    double from = _outDistance;
    _outDistance = value;
    if (hasValidated) {
      outDistanceChanged(from, value);
    }
  }

  void outDistanceChanged(double from, double to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is CubicAsymmetricVertexBase) {
      rotation_ = source.rotation_;
      inDistance_ = source.inDistance_;
      _outDistance = source._outDistance;
    }
  }
}
