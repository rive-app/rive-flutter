// Core automatically generated lib/src/generated/artboard_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/world_transform_component_base.dart';
import 'package:rive/src/rive_core/layout_component.dart';

abstract class ArtboardBase extends LayoutComponent {
  static const int typeKey = 1;
  @override
  int get coreType => ArtboardBase.typeKey;
  @override
  Set<int> get coreTypes => {
        ArtboardBase.typeKey,
        LayoutComponentBase.typeKey,
        WorldTransformComponentBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// X field with key 9.
  static const int xPropertyKey = 9;
  static const double xInitialValue = 0;
  double _x = xInitialValue;

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
  static const int yPropertyKey = 10;
  static const double yInitialValue = 0;
  double _y = yInitialValue;

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
  static const int originXPropertyKey = 11;
  static const double originXInitialValue = 0;
  double _originX = originXInitialValue;

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
  static const int originYPropertyKey = 12;
  static const double originYInitialValue = 0;
  double _originY = originYInitialValue;

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
  /// DefaultStateMachineId field with key 236.
  static const int defaultStateMachineIdPropertyKey = 236;
  static const int defaultStateMachineIdInitialValue = -1;
  int _defaultStateMachineId = defaultStateMachineIdInitialValue;

  /// The default StateMachine attached to this artboard automatically when it
  /// is initialized.
  int get defaultStateMachineId => _defaultStateMachineId;

  /// Change the [_defaultStateMachineId] field value.
  /// [defaultStateMachineIdChanged] will be invoked only if the field's value
  /// has changed.
  set defaultStateMachineId(int value) {
    if (_defaultStateMachineId == value) {
      return;
    }
    int from = _defaultStateMachineId;
    _defaultStateMachineId = value;
    if (hasValidated) {
      defaultStateMachineIdChanged(from, value);
    }
  }

  void defaultStateMachineIdChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is ArtboardBase) {
      _x = source._x;
      _y = source._y;
      _originX = source._originX;
      _originY = source._originY;
      _defaultStateMachineId = source._defaultStateMachineId;
    }
  }
}
