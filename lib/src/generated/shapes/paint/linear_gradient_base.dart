/// Core automatically generated
/// lib/src/generated/shapes/paint/linear_gradient_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/container_component.dart';

abstract class LinearGradientBase extends ContainerComponent {
  static const int typeKey = 22;
  @override
  int get coreType => LinearGradientBase.typeKey;
  @override
  Set<int> get coreTypes => {
        LinearGradientBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// StartX field with key 42.
  static const double startXInitialValue = 0;
  double _startX = startXInitialValue;
  static const int startXPropertyKey = 42;
  double get startX => _startX;

  /// Change the [_startX] field value.
  /// [startXChanged] will be invoked only if the field's value has changed.
  set startX(double value) {
    if (_startX == value) {
      return;
    }
    double from = _startX;
    _startX = value;
    if (hasValidated) {
      startXChanged(from, value);
    }
  }

  void startXChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// StartY field with key 33.
  static const double startYInitialValue = 0;
  double _startY = startYInitialValue;
  static const int startYPropertyKey = 33;
  double get startY => _startY;

  /// Change the [_startY] field value.
  /// [startYChanged] will be invoked only if the field's value has changed.
  set startY(double value) {
    if (_startY == value) {
      return;
    }
    double from = _startY;
    _startY = value;
    if (hasValidated) {
      startYChanged(from, value);
    }
  }

  void startYChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// EndX field with key 34.
  static const double endXInitialValue = 0;
  double _endX = endXInitialValue;
  static const int endXPropertyKey = 34;
  double get endX => _endX;

  /// Change the [_endX] field value.
  /// [endXChanged] will be invoked only if the field's value has changed.
  set endX(double value) {
    if (_endX == value) {
      return;
    }
    double from = _endX;
    _endX = value;
    if (hasValidated) {
      endXChanged(from, value);
    }
  }

  void endXChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// EndY field with key 35.
  static const double endYInitialValue = 0;
  double _endY = endYInitialValue;
  static const int endYPropertyKey = 35;
  double get endY => _endY;

  /// Change the [_endY] field value.
  /// [endYChanged] will be invoked only if the field's value has changed.
  set endY(double value) {
    if (_endY == value) {
      return;
    }
    double from = _endY;
    _endY = value;
    if (hasValidated) {
      endYChanged(from, value);
    }
  }

  void endYChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Opacity field with key 46.
  static const double opacityInitialValue = 1;
  double _opacity = opacityInitialValue;
  static const int opacityPropertyKey = 46;
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

  @override
  void copy(covariant LinearGradientBase source) {
    super.copy(source);
    _startX = source._startX;
    _startY = source._startY;
    _endX = source._endX;
    _endY = source._endY;
    _opacity = source._opacity;
  }
}
