/// Core automatically generated lib/src/generated/shapes/rectangle_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/node_base.dart';
import 'package:rive/src/generated/shapes/path_base.dart';
import 'package:rive/src/generated/transform_component_base.dart';
import 'package:rive/src/generated/world_transform_component_base.dart';
import 'package:rive/src/rive_core/shapes/parametric_path.dart';

abstract class RectangleBase extends ParametricPath {
  static const int typeKey = 7;
  @override
  int get coreType => RectangleBase.typeKey;
  @override
  Set<int> get coreTypes => {
        RectangleBase.typeKey,
        ParametricPathBase.typeKey,
        PathBase.typeKey,
        NodeBase.typeKey,
        TransformComponentBase.typeKey,
        WorldTransformComponentBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// LinkCornerRadius field with key 164.
  static const bool linkCornerRadiusInitialValue = true;
  bool _linkCornerRadius = linkCornerRadiusInitialValue;
  static const int linkCornerRadiusPropertyKey = 164;

  /// Whether the TL corner radius defines all the radiuses
  bool get linkCornerRadius => _linkCornerRadius;

  /// Change the [_linkCornerRadius] field value.
  /// [linkCornerRadiusChanged] will be invoked only if the field's value has
  /// changed.
  set linkCornerRadius(bool value) {
    if (_linkCornerRadius == value) {
      return;
    }
    bool from = _linkCornerRadius;
    _linkCornerRadius = value;
    if (hasValidated) {
      linkCornerRadiusChanged(from, value);
    }
  }

  void linkCornerRadiusChanged(bool from, bool to);

  /// --------------------------------------------------------------------------
  /// CornerRadiusTL field with key 31.
  static const double cornerRadiusTLInitialValue = 0;
  double _cornerRadiusTL = cornerRadiusTLInitialValue;
  static const int cornerRadiusTLPropertyKey = 31;

  /// Top left radius of the corners of this rectangle
  double get cornerRadiusTL => _cornerRadiusTL;

  /// Change the [_cornerRadiusTL] field value.
  /// [cornerRadiusTLChanged] will be invoked only if the field's value has
  /// changed.
  set cornerRadiusTL(double value) {
    if (_cornerRadiusTL == value) {
      return;
    }
    double from = _cornerRadiusTL;
    _cornerRadiusTL = value;
    if (hasValidated) {
      cornerRadiusTLChanged(from, value);
    }
  }

  void cornerRadiusTLChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// CornerRadiusTR field with key 161.
  static const double cornerRadiusTRInitialValue = 0;
  double _cornerRadiusTR = cornerRadiusTRInitialValue;
  static const int cornerRadiusTRPropertyKey = 161;

  /// Top right radius of the corners of this rectangle
  double get cornerRadiusTR => _cornerRadiusTR;

  /// Change the [_cornerRadiusTR] field value.
  /// [cornerRadiusTRChanged] will be invoked only if the field's value has
  /// changed.
  set cornerRadiusTR(double value) {
    if (_cornerRadiusTR == value) {
      return;
    }
    double from = _cornerRadiusTR;
    _cornerRadiusTR = value;
    if (hasValidated) {
      cornerRadiusTRChanged(from, value);
    }
  }

  void cornerRadiusTRChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// CornerRadiusBL field with key 162.
  static const double cornerRadiusBLInitialValue = 0;
  double _cornerRadiusBL = cornerRadiusBLInitialValue;
  static const int cornerRadiusBLPropertyKey = 162;

  /// Bottom left radius of the corners of this rectangle
  double get cornerRadiusBL => _cornerRadiusBL;

  /// Change the [_cornerRadiusBL] field value.
  /// [cornerRadiusBLChanged] will be invoked only if the field's value has
  /// changed.
  set cornerRadiusBL(double value) {
    if (_cornerRadiusBL == value) {
      return;
    }
    double from = _cornerRadiusBL;
    _cornerRadiusBL = value;
    if (hasValidated) {
      cornerRadiusBLChanged(from, value);
    }
  }

  void cornerRadiusBLChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// CornerRadiusBR field with key 163.
  static const double cornerRadiusBRInitialValue = 0;
  double _cornerRadiusBR = cornerRadiusBRInitialValue;
  static const int cornerRadiusBRPropertyKey = 163;

  /// Bottom right radius of the corners of this rectangle
  double get cornerRadiusBR => _cornerRadiusBR;

  /// Change the [_cornerRadiusBR] field value.
  /// [cornerRadiusBRChanged] will be invoked only if the field's value has
  /// changed.
  set cornerRadiusBR(double value) {
    if (_cornerRadiusBR == value) {
      return;
    }
    double from = _cornerRadiusBR;
    _cornerRadiusBR = value;
    if (hasValidated) {
      cornerRadiusBRChanged(from, value);
    }
  }

  void cornerRadiusBRChanged(double from, double to);

  @override
  void copy(covariant RectangleBase source) {
    super.copy(source);
    _linkCornerRadius = source._linkCornerRadius;
    _cornerRadiusTL = source._cornerRadiusTL;
    _cornerRadiusTR = source._cornerRadiusTR;
    _cornerRadiusBL = source._cornerRadiusBL;
    _cornerRadiusBR = source._cornerRadiusBR;
  }
}
