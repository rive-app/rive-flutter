/// Core automatically generated
/// lib/src/generated/shapes/straight_vertex_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/shapes/vertex_base.dart';
import 'package:rive/src/rive_core/bones/weight.dart';
import 'package:rive/src/rive_core/shapes/path_vertex.dart';

abstract class StraightVertexBase extends PathVertex<Weight> {
  static const int typeKey = 5;
  @override
  int get coreType => StraightVertexBase.typeKey;
  @override
  Set<int> get coreTypes => {
        StraightVertexBase.typeKey,
        PathVertexBase.typeKey,
        VertexBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Radius field with key 26.
  static const double radiusInitialValue = 0;
  double _radius = radiusInitialValue;
  static const int radiusPropertyKey = 26;

  /// Radius of the vertex
  double get radius => _radius;

  /// Change the [_radius] field value.
  /// [radiusChanged] will be invoked only if the field's value has changed.
  set radius(double value) {
    if (_radius == value) {
      return;
    }
    double from = _radius;
    _radius = value;
    if (hasValidated) {
      radiusChanged(from, value);
    }
  }

  void radiusChanged(double from, double to);

  @override
  void copy(covariant StraightVertexBase source) {
    super.copy(source);
    _radius = source._radius;
  }
}
