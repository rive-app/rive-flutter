/// Core automatically generated
/// lib/src/generated/transform_component_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/world_transform_component.dart';

abstract class TransformComponentBase extends WorldTransformComponent {
  static const int typeKey = 38;
  @override
  int get coreType => TransformComponentBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TransformComponentBase.typeKey,
        WorldTransformComponentBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Rotation field with key 15.
  static const double rotationInitialValue = 0;
  double _rotation = rotationInitialValue;
  static const int rotationPropertyKey = 15;
  double get rotation => _rotation;

  /// Change the [_rotation] field value.
  /// [rotationChanged] will be invoked only if the field's value has changed.
  set rotation(double value) {
    if (_rotation == value) {
      return;
    }
    double from = _rotation;
    _rotation = value;
    if (hasValidated) {
      rotationChanged(from, value);
    }
  }

  void rotationChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// ScaleX field with key 16.
  static const double scaleXInitialValue = 1;
  double _scaleX = scaleXInitialValue;
  static const int scaleXPropertyKey = 16;
  double get scaleX => _scaleX;

  /// Change the [_scaleX] field value.
  /// [scaleXChanged] will be invoked only if the field's value has changed.
  set scaleX(double value) {
    if (_scaleX == value) {
      return;
    }
    double from = _scaleX;
    _scaleX = value;
    if (hasValidated) {
      scaleXChanged(from, value);
    }
  }

  void scaleXChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// ScaleY field with key 17.
  static const double scaleYInitialValue = 1;
  double _scaleY = scaleYInitialValue;
  static const int scaleYPropertyKey = 17;
  double get scaleY => _scaleY;

  /// Change the [_scaleY] field value.
  /// [scaleYChanged] will be invoked only if the field's value has changed.
  set scaleY(double value) {
    if (_scaleY == value) {
      return;
    }
    double from = _scaleY;
    _scaleY = value;
    if (hasValidated) {
      scaleYChanged(from, value);
    }
  }

  void scaleYChanged(double from, double to);

  @override
  void copy(covariant TransformComponentBase source) {
    super.copy(source);
    _rotation = source._rotation;
    _scaleX = source._scaleX;
    _scaleY = source._scaleY;
  }
}
