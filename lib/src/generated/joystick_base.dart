// Core automatically generated lib/src/generated/joystick_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
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
  /// PosX field with key 303.
  static const double posXInitialValue = 0;
  double _posX = posXInitialValue;
  static const int posXPropertyKey = 303;
  double get posX => _posX;

  /// Change the [_posX] field value.
  /// [posXChanged] will be invoked only if the field's value has changed.
  set posX(double value) {
    if (_posX == value) {
      return;
    }
    double from = _posX;
    _posX = value;
    if (hasValidated) {
      posXChanged(from, value);
    }
  }

  void posXChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// PosY field with key 304.
  static const double posYInitialValue = 0;
  double _posY = posYInitialValue;
  static const int posYPropertyKey = 304;
  double get posY => _posY;

  /// Change the [_posY] field value.
  /// [posYChanged] will be invoked only if the field's value has changed.
  set posY(double value) {
    if (_posY == value) {
      return;
    }
    double from = _posY;
    _posY = value;
    if (hasValidated) {
      posYChanged(from, value);
    }
  }

  void posYChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// OriginX field with key 307.
  static const double originXInitialValue = 0.5;
  double _originX = originXInitialValue;
  static const int originXPropertyKey = 307;

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
  /// OriginY field with key 308.
  static const double originYInitialValue = 0.5;
  double _originY = originYInitialValue;
  static const int originYPropertyKey = 308;

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

  /// --------------------------------------------------------------------------
  /// Width field with key 305.
  static const double widthInitialValue = 100;
  double _width = widthInitialValue;
  static const int widthPropertyKey = 305;
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
  /// Height field with key 306.
  static const double heightInitialValue = 100;
  double _height = heightInitialValue;
  static const int heightPropertyKey = 306;
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
  /// JoystickFlags field with key 312.
  static const int joystickFlagsInitialValue = 0;
  int _joystickFlags = joystickFlagsInitialValue;
  static const int joystickFlagsPropertyKey = 312;
  int get joystickFlags => _joystickFlags;

  /// Change the [_joystickFlags] field value.
  /// [joystickFlagsChanged] will be invoked only if the field's value has
  /// changed.
  set joystickFlags(int value) {
    if (_joystickFlags == value) {
      return;
    }
    int from = _joystickFlags;
    _joystickFlags = value;
    if (hasValidated) {
      joystickFlagsChanged(from, value);
    }
  }

  void joystickFlagsChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// HandleSourceId field with key 313.
  static const int handleSourceIdInitialValue = -1;
  int _handleSourceId = handleSourceIdInitialValue;
  static const int handleSourceIdPropertyKey = 313;

  /// Identifier used to track the custom handle source of the joystick.
  int get handleSourceId => _handleSourceId;

  /// Change the [_handleSourceId] field value.
  /// [handleSourceIdChanged] will be invoked only if the field's value has
  /// changed.
  set handleSourceId(int value) {
    if (_handleSourceId == value) {
      return;
    }
    int from = _handleSourceId;
    _handleSourceId = value;
    if (hasValidated) {
      handleSourceIdChanged(from, value);
    }
  }

  void handleSourceIdChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is JoystickBase) {
      _x = source._x;
      _y = source._y;
      _posX = source._posX;
      _posY = source._posY;
      _originX = source._originX;
      _originY = source._originY;
      _width = source._width;
      _height = source._height;
      _xId = source._xId;
      _yId = source._yId;
      _joystickFlags = source._joystickFlags;
      _handleSourceId = source._handleSourceId;
    }
  }
}
