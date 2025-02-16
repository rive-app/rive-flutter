// Core automatically generated lib/src/generated/node_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
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
  static const int xPropertyKey = 13;
  static const double xInitialValue = 0;
  double x_ = xInitialValue;
  @override
  @nonVirtual
  double get x => x_;

  /// Change the [x_] field value.
  /// [xChanged] will be invoked only if the field's value has changed.
  @override
  @nonVirtual
  set x(double value) {
    if (x_ == value) {
      return;
    }
    double from = x_;
    x_ = value;
    if (hasValidated) {
      xChanged(from, value);
    }
  }

  void xChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Y field with key 14.
  static const int yPropertyKey = 14;
  static const double yInitialValue = 0;
  double y_ = yInitialValue;
  @override
  @nonVirtual
  double get y => y_;

  /// Change the [y_] field value.
  /// [yChanged] will be invoked only if the field's value has changed.
  @override
  @nonVirtual
  set y(double value) {
    if (y_ == value) {
      return;
    }
    double from = y_;
    y_ = value;
    if (hasValidated) {
      yChanged(from, value);
    }
  }

  void yChanged(double from, double to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is NodeBase) {
      x_ = source.x_;
      y_ = source.y_;
    }
  }
}
