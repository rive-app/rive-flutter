/// Core automatically generated
/// lib/src/generated/shapes/cubic_mirrored_vertex_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/shapes/cubic_vertex_base.dart';
import 'package:rive/src/generated/shapes/path_vertex_base.dart';
import 'package:rive/src/rive_core/shapes/cubic_vertex.dart';

abstract class CubicMirroredVertexBase extends CubicVertex {
  static const int typeKey = 35;
  @override
  int get coreType => CubicMirroredVertexBase.typeKey;
  @override
  Set<int> get coreTypes => {
        CubicMirroredVertexBase.typeKey,
        CubicVertexBase.typeKey,
        PathVertexBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Rotation field with key 82.
  double _rotation = 0;
  static const int rotationPropertyKey = 82;

  /// The control points' angle.
  double get rotation => _rotation;

  /// Change the [_rotation] field value.
  /// [rotationChanged] will be invoked only if the field's value has changed.
  set rotation(double value) {
    if (_rotation == value) {
      return;
    }
    double from = _rotation;
    _rotation = value;
    rotationChanged(from, value);
  }

  void rotationChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Distance field with key 83.
  double _distance = 0;
  static const int distancePropertyKey = 83;

  /// The control points' distance from the translation of the point.
  double get distance => _distance;

  /// Change the [_distance] field value.
  /// [distanceChanged] will be invoked only if the field's value has changed.
  set distance(double value) {
    if (_distance == value) {
      return;
    }
    double from = _distance;
    _distance = value;
    distanceChanged(from, value);
  }

  void distanceChanged(double from, double to);
}
