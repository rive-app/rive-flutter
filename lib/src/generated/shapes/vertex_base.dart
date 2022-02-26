/// Core automatically generated lib/src/generated/shapes/vertex_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/container_component.dart';

abstract class VertexBase extends ContainerComponent {
  static const int typeKey = 107;
  @override
  int get coreType => VertexBase.typeKey;
  @override
  Set<int> get coreTypes => {
        VertexBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// X field with key 24.
  static const double xInitialValue = 0;
  double _x = xInitialValue;
  static const int xPropertyKey = 24;

  /// X value for the translation of the vertex.
  double get x => _x;

  /// Change the [_x] field value.
  /// [xChanged] will be invoked only if the field's value has changed.
  set x(double value) {
    if (_x == value) {
      return;
    }
    double from = _x;
    _x = value;
    if (hasValidated) {
      xChanged(from, value);
    }
  }

  void xChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Y field with key 25.
  static const double yInitialValue = 0;
  double _y = yInitialValue;
  static const int yPropertyKey = 25;

  /// Y value for the translation of the vertex.
  double get y => _y;

  /// Change the [_y] field value.
  /// [yChanged] will be invoked only if the field's value has changed.
  set y(double value) {
    if (_y == value) {
      return;
    }
    double from = _y;
    _y = value;
    if (hasValidated) {
      yChanged(from, value);
    }
  }

  void yChanged(double from, double to);

  @override
  void copy(covariant VertexBase source) {
    super.copy(source);
    _x = source._x;
    _y = source._y;
  }
}
