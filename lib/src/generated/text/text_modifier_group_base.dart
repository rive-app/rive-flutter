// Core automatically generated
// lib/src/generated/text/text_modifier_group_base.dart.
// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/container_component.dart';

abstract class TextModifierGroupBase extends ContainerComponent {
  static const int typeKey = 159;
  @override
  int get coreType => TextModifierGroupBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TextModifierGroupBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// ModifierFlags field with key 335.
  static const int modifierFlagsPropertyKey = 335;
  static const int modifierFlagsInitialValue = 0;
  int _modifierFlags = modifierFlagsInitialValue;
  int get modifierFlags => _modifierFlags;

  /// Change the [_modifierFlags] field value.
  /// [modifierFlagsChanged] will be invoked only if the field's value has
  /// changed.
  set modifierFlags(int value) {
    if (_modifierFlags == value) {
      return;
    }
    int from = _modifierFlags;
    _modifierFlags = value;
    if (hasValidated) {
      modifierFlagsChanged(from, value);
    }
  }

  void modifierFlagsChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// OriginX field with key 328.
  static const int originXPropertyKey = 328;
  static const double originXInitialValue = 0;
  double _originX = originXInitialValue;
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
  /// OriginY field with key 329.
  static const int originYPropertyKey = 329;
  static const double originYInitialValue = 0;
  double _originY = originYInitialValue;
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

  /// --------------------------------------------------------------------------
  /// Opacity field with key 324.
  static const int opacityPropertyKey = 324;
  static const double opacityInitialValue = 1;
  double _opacity = opacityInitialValue;
  double get opacity => _opacity;

  /// Change the [_opacity] field value.
  /// [opacityChanged] will be invoked only if the field's value has changed.
  set opacity(double value) {
    if (_opacity == value) {
      return;
    }
    double from = _opacity;
    _opacity = value;
    if (hasValidated) {
      opacityChanged(from, value);
    }
  }

  void opacityChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// X field with key 322.
  static const int xPropertyKey = 322;
  static const double xInitialValue = 0;
  double _x = xInitialValue;
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
  /// Y field with key 323.
  static const int yPropertyKey = 323;
  static const double yInitialValue = 0;
  double _y = yInitialValue;
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

  /// --------------------------------------------------------------------------
  /// Rotation field with key 332.
  static const int rotationPropertyKey = 332;
  static const double rotationInitialValue = 0;
  double _rotation = rotationInitialValue;
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
  /// ScaleX field with key 330.
  static const int scaleXPropertyKey = 330;
  static const double scaleXInitialValue = 1;
  double _scaleX = scaleXInitialValue;
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
  /// ScaleY field with key 331.
  static const int scaleYPropertyKey = 331;
  static const double scaleYInitialValue = 1;
  double _scaleY = scaleYInitialValue;
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
  void copy(Core source) {
    super.copy(source);
    if (source is TextModifierGroupBase) {
      _modifierFlags = source._modifierFlags;
      _originX = source._originX;
      _originY = source._originY;
      _opacity = source._opacity;
      _x = source._x;
      _y = source._y;
      _rotation = source._rotation;
      _scaleX = source._scaleX;
      _scaleY = source._scaleY;
    }
  }
}
