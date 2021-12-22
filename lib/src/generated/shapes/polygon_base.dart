/// Core automatically generated lib/src/generated/shapes/polygon_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/node_base.dart';
import 'package:rive/src/generated/shapes/path_base.dart';
import 'package:rive/src/generated/transform_component_base.dart';
import 'package:rive/src/generated/world_transform_component_base.dart';
import 'package:rive/src/rive_core/shapes/parametric_path.dart';

abstract class PolygonBase extends ParametricPath {
  static const int typeKey = 51;
  @override
  int get coreType => PolygonBase.typeKey;
  @override
  Set<int> get coreTypes => {
        PolygonBase.typeKey,
        ParametricPathBase.typeKey,
        PathBase.typeKey,
        NodeBase.typeKey,
        TransformComponentBase.typeKey,
        WorldTransformComponentBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Points field with key 125.
  static const int pointsInitialValue = 5;
  int _points = pointsInitialValue;
  static const int pointsPropertyKey = 125;

  /// The number of points for the polygon.
  int get points => _points;

  /// Change the [_points] field value.
  /// [pointsChanged] will be invoked only if the field's value has changed.
  set points(int value) {
    if (_points == value) {
      return;
    }
    int from = _points;
    _points = value;
    if (hasValidated) {
      pointsChanged(from, value);
    }
  }

  void pointsChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// CornerRadius field with key 126.
  static const double cornerRadiusInitialValue = 0;
  double _cornerRadius = cornerRadiusInitialValue;
  static const int cornerRadiusPropertyKey = 126;

  /// The corner radius.
  double get cornerRadius => _cornerRadius;

  /// Change the [_cornerRadius] field value.
  /// [cornerRadiusChanged] will be invoked only if the field's value has
  /// changed.
  set cornerRadius(double value) {
    if (_cornerRadius == value) {
      return;
    }
    double from = _cornerRadius;
    _cornerRadius = value;
    if (hasValidated) {
      cornerRadiusChanged(from, value);
    }
  }

  void cornerRadiusChanged(double from, double to);

  @override
  void copy(covariant PolygonBase source) {
    super.copy(source);
    _points = source._points;
    _cornerRadius = source._cornerRadius;
  }
}
