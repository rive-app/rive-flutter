// Core automatically generated lib/src/generated/shapes/vertex_base.dart.
// Do not modify manually.

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
  static const int xPropertyKey = 24;
  static const double xInitialValue = 0;

  double x_ = xInitialValue;

  /// X value for the translation of the vertex.
  @nonVirtual
  double get x => x_;

  /// Change the [x_] field value.
  /// [xChanged] will be invoked only if the field's value has changed.
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
  /// Y field with key 25.
  static const int yPropertyKey = 25;
  static const double yInitialValue = 0;

  double y_ = yInitialValue;

  /// Y value for the translation of the vertex.
  @nonVirtual
  double get y => y_;

  /// Change the [y_] field value.
  /// [yChanged] will be invoked only if the field's value has changed.
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
    if (source is VertexBase) {
      x_ = source.x_;
      y_ = source.y_;
    }
  }
}
