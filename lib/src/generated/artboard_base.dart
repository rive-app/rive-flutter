/// Core automatically generated lib/src/generated/artboard_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/container_component.dart';

abstract class ArtboardBase extends ContainerComponent {
  static const int typeKey = 1;
  @override
  int get coreType => ArtboardBase.typeKey;
  @override
  Set<int> get coreTypes => {
        ArtboardBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Width field with key 7.
  static const double widthInitialValue = 0;
  double _width = widthInitialValue;
  static const int widthPropertyKey = 7;

  /// Width of the artboard.
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
  /// Height field with key 8.
  static const double heightInitialValue = 0;
  double _height = heightInitialValue;
  static const int heightPropertyKey = 8;

  /// Height of the artboard.
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
  /// X field with key 9.
  static const double xInitialValue = 0;
  double _x = xInitialValue;
  static const int xPropertyKey = 9;

  /// X coordinate in editor world space.
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
  /// Y field with key 10.
  static const double yInitialValue = 0;
  double _y = yInitialValue;
  static const int yPropertyKey = 10;

  /// Y coordinate in editor world space.
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
  /// OriginX field with key 11.
  static const double originXInitialValue = 0;
  double _originX = originXInitialValue;
  static const int originXPropertyKey = 11;

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
  /// OriginY field with key 12.
  static const double originYInitialValue = 0;
  double _originY = originYInitialValue;
  static const int originYPropertyKey = 12;

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
}
