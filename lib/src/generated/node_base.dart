/// Core automatically generated lib/src/generated/node_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/world_transform_component_base.dart';
import 'package:rive/src/rive_core/transform_component.dart';

abstract class NodeBase extends TransformComponent {
  static const int typeKey = 2;
  @override
  int get coreType => NodeBase.typeKey;
  @override
  Set<int> get coreTypes => {
        NodeBase.typeKey,
        TransformComponentBase.typeKey,
        WorldTransformComponentBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// X field with key 13.
  static const double xInitialValue = 0;
  double _x = xInitialValue;
  static const int xPropertyKey = 13;
  @override
  double get x => _x;

  /// Change the [_x] field value.
  /// [xChanged] will be invoked only if the field's value has changed.
  @override
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
  /// Y field with key 14.
  static const double yInitialValue = 0;
  double _y = yInitialValue;
  static const int yPropertyKey = 14;
  @override
  double get y => _y;

  /// Change the [_y] field value.
  /// [yChanged] will be invoked only if the field's value has changed.
  @override
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
  void copy(covariant NodeBase source) {
    super.copy(source);
    _x = source._x;
    _y = source._y;
  }
}
