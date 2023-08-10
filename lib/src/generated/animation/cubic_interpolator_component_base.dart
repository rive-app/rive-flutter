// Core automatically generated
// lib/src/generated/animation/cubic_interpolator_component_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/component.dart';

abstract class CubicInterpolatorComponentBase extends Component {
  static const int typeKey = 163;
  @override
  int get coreType => CubicInterpolatorComponentBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {CubicInterpolatorComponentBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// X1 field with key 337.
  static const double x1InitialValue = 0.42;
  double _x1 = x1InitialValue;
  static const int x1PropertyKey = 337;
  double get x1 => _x1;

  /// Change the [_x1] field value.
  /// [x1Changed] will be invoked only if the field's value has changed.
  set x1(double value) {
    if (_x1 == value) {
      return;
    }
    double from = _x1;
    _x1 = value;
    if (hasValidated) {
      x1Changed(from, value);
    }
  }

  void x1Changed(double from, double to);

  /// --------------------------------------------------------------------------
  /// Y1 field with key 338.
  static const double y1InitialValue = 0;
  double _y1 = y1InitialValue;
  static const int y1PropertyKey = 338;
  double get y1 => _y1;

  /// Change the [_y1] field value.
  /// [y1Changed] will be invoked only if the field's value has changed.
  set y1(double value) {
    if (_y1 == value) {
      return;
    }
    double from = _y1;
    _y1 = value;
    if (hasValidated) {
      y1Changed(from, value);
    }
  }

  void y1Changed(double from, double to);

  /// --------------------------------------------------------------------------
  /// X2 field with key 339.
  static const double x2InitialValue = 0.58;
  double _x2 = x2InitialValue;
  static const int x2PropertyKey = 339;
  double get x2 => _x2;

  /// Change the [_x2] field value.
  /// [x2Changed] will be invoked only if the field's value has changed.
  set x2(double value) {
    if (_x2 == value) {
      return;
    }
    double from = _x2;
    _x2 = value;
    if (hasValidated) {
      x2Changed(from, value);
    }
  }

  void x2Changed(double from, double to);

  /// --------------------------------------------------------------------------
  /// Y2 field with key 340.
  static const double y2InitialValue = 1;
  double _y2 = y2InitialValue;
  static const int y2PropertyKey = 340;
  double get y2 => _y2;

  /// Change the [_y2] field value.
  /// [y2Changed] will be invoked only if the field's value has changed.
  set y2(double value) {
    if (_y2 == value) {
      return;
    }
    double from = _y2;
    _y2 = value;
    if (hasValidated) {
      y2Changed(from, value);
    }
  }

  void y2Changed(double from, double to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is CubicInterpolatorComponentBase) {
      _x1 = source._x1;
      _y1 = source._y1;
      _x2 = source._x2;
      _y2 = source._y2;
    }
  }
}
