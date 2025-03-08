// Core automatically generated
// lib/src/generated/shapes/straight_vertex_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/shapes/vertex_base.dart';
import 'package:rive/src/rive_core/bones/weight.dart';
import 'package:rive/src/rive_core/shapes/path_vertex.dart';

const _coreTypes = {
  StraightVertexBase.typeKey,
  PathVertexBase.typeKey,
  VertexBase.typeKey,
  ContainerComponentBase.typeKey,
  ComponentBase.typeKey
};

abstract class StraightVertexBase extends PathVertex<Weight> {
  static const int typeKey = 5;
  @override
  int get coreType => StraightVertexBase.typeKey;
  @override
  Set<int> get coreTypes => _coreTypes;

  /// --------------------------------------------------------------------------
  /// Radius field with key 26.
  static const int radiusPropertyKey = 26;
  static const double radiusInitialValue = 0;

  @nonVirtual
  double radius_ = radiusInitialValue;

  /// Radius of the vertex
  @nonVirtual
  double get radius => radius_;

  /// Change the [radius_] field value.
  /// [radiusChanged] will be invoked only if the field's value has changed.
  set radius(double value) {
    if (radius_ == value) {
      return;
    }
    double from = radius_;
    radius_ = value;
    if (hasValidated) {
      radiusChanged(from, value);
    }
  }

  void radiusChanged(double from, double to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is StraightVertexBase) {
      radius_ = source.radius_;
    }
  }
}
