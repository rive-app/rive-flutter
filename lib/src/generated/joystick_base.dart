/// Core automatically generated lib/src/generated/joystick_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/component.dart';

abstract class JoystickBase extends Component {
  static const int typeKey = 148;
  @override
  int get coreType => JoystickBase.typeKey;
  @override
  Set<int> get coreTypes => {JoystickBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// X field with key 299.
  static const double xInitialValue = 0;
  double _x = xInitialValue;
  static const int xPropertyKey = 299;
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
  /// Y field with key 300.
  static const double yInitialValue = 0;
  double _y = yInitialValue;
  static const int yPropertyKey = 300;
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
  /// XId field with key 301.
  static const int xIdInitialValue = -1;
  int _xId = xIdInitialValue;
  static const int xIdPropertyKey = 301;

  /// Identifier used to track the animation used for the x axis of the
  /// joystick.
  int get xId => _xId;

  /// Change the [_xId] field value.
  /// [xIdChanged] will be invoked only if the field's value has changed.
  set xId(int value) {
    if (_xId == value) {
      return;
    }
    int from = _xId;
    _xId = value;
    if (hasValidated) {
      xIdChanged(from, value);
    }
  }

  void xIdChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// XInvert field with key 310.
  static const bool xInvertInitialValue = false;
  bool _xInvert = xInvertInitialValue;
  static const int xInvertPropertyKey = 310;

  /// Whether to invert the application of the x axis.
  bool get xInvert => _xInvert;

  /// Change the [_xInvert] field value.
  /// [xInvertChanged] will be invoked only if the field's value has changed.
  set xInvert(bool value) {
    if (_xInvert == value) {
      return;
    }
    bool from = _xInvert;
    _xInvert = value;
    if (hasValidated) {
      xInvertChanged(from, value);
    }
  }

  void xInvertChanged(bool from, bool to);

  /// --------------------------------------------------------------------------
  /// YId field with key 302.
  static const int yIdInitialValue = -1;
  int _yId = yIdInitialValue;
  static const int yIdPropertyKey = 302;

  /// Identifier used to track the animation used for the y axis of the
  /// joystick.
  int get yId => _yId;

  /// Change the [_yId] field value.
  /// [yIdChanged] will be invoked only if the field's value has changed.
  set yId(int value) {
    if (_yId == value) {
      return;
    }
    int from = _yId;
    _yId = value;
    if (hasValidated) {
      yIdChanged(from, value);
    }
  }

  void yIdChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// YInvert field with key 311.
  static const bool yInvertInitialValue = false;
  bool _yInvert = yInvertInitialValue;
  static const int yInvertPropertyKey = 311;

  /// Whether to invert the application of the y axis.
  bool get yInvert => _yInvert;

  /// Change the [_yInvert] field value.
  /// [yInvertChanged] will be invoked only if the field's value has changed.
  set yInvert(bool value) {
    if (_yInvert == value) {
      return;
    }
    bool from = _yInvert;
    _yInvert = value;
    if (hasValidated) {
      yInvertChanged(from, value);
    }
  }

  void yInvertChanged(bool from, bool to);

  @override
  void copy(covariant JoystickBase source) {
    super.copy(source);
    _x = source._x;
    _y = source._y;
    _xId = source._xId;
    _xInvert = source._xInvert;
    _yId = source._yId;
    _yInvert = source._yInvert;
  }
}
