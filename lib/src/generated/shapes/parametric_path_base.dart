/// Core automatically generated
/// lib/src/generated/shapes/parametric_path_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/node_base.dart';
import 'package:rive/src/generated/transform_component_base.dart';
import 'package:rive/src/generated/world_transform_component_base.dart';
import 'package:rive/src/rive_core/shapes/path.dart';

abstract class ParametricPathBase extends Path {
  static const int typeKey = 15;
  @override
  int get coreType => ParametricPathBase.typeKey;
  @override
  Set<int> get coreTypes => {
        ParametricPathBase.typeKey,
        PathBase.typeKey,
        NodeBase.typeKey,
        TransformComponentBase.typeKey,
        WorldTransformComponentBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Width field with key 20.
  static const double widthInitialValue = 0;
  double _width = widthInitialValue;
  static const int widthPropertyKey = 20;

  /// Width of the parametric path.
  double get width => _width;

  /// Change the [_width] field value.
  /// [widthChanged] will be invoked only if the field's value has changed.
  set width(double value) {
    if (_width == value) {
      return;
    }
    double from = _width;
    _width = value;
    if (hasValidated) {
      widthChanged(from, value);
    }
  }

  void widthChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Height field with key 21.
  static const double heightInitialValue = 0;
  double _height = heightInitialValue;
  static const int heightPropertyKey = 21;

  /// Height of the parametric path.
  double get height => _height;

  /// Change the [_height] field value.
  /// [heightChanged] will be invoked only if the field's value has changed.
  set height(double value) {
    if (_height == value) {
      return;
    }
    double from = _height;
    _height = value;
    if (hasValidated) {
      heightChanged(from, value);
    }
  }

  void heightChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// OriginX field with key 123.
  static const double originXInitialValue = 0.5;
  double _originX = originXInitialValue;
  static const int originXPropertyKey = 123;

  /// Origin x in normalized coordinates (0.5 = center, 0 = left, 1 = right).
  double get originX => _originX;

  /// Change the [_originX] field value.
  /// [originXChanged] will be invoked only if the field's value has changed.
  set originX(double value) {
    if (_originX == value) {
      return;
    }
    double from = _originX;
    _originX = value;
    if (hasValidated) {
      originXChanged(from, value);
    }
  }

  void originXChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// OriginY field with key 124.
  static const double originYInitialValue = 0.5;
  double _originY = originYInitialValue;
  static const int originYPropertyKey = 124;

  /// Origin y in normalized coordinates (0.5 = center, 0 = top, 1 = bottom).
  double get originY => _originY;

  /// Change the [_originY] field value.
  /// [originYChanged] will be invoked only if the field's value has changed.
  set originY(double value) {
    if (_originY == value) {
      return;
    }
    double from = _originY;
    _originY = value;
    if (hasValidated) {
      originYChanged(from, value);
    }
  }

  void originYChanged(double from, double to);

  @override
  void copy(covariant ParametricPathBase source) {
    super.copy(source);
    _width = source._width;
    _height = source._height;
    _originX = source._originX;
    _originY = source._originY;
  }
}
