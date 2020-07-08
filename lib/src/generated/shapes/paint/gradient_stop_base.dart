/// Core automatically generated
/// lib/src/generated/shapes/paint/gradient_stop_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/rive_core/component.dart';

abstract class GradientStopBase extends Component {
  static const int typeKey = 19;
  @override
  int get coreType => GradientStopBase.typeKey;
  @override
  Set<int> get coreTypes => {GradientStopBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// ColorValue field with key 38.
  int _colorValue = 0xFFFFFFFF;
  static const int colorValuePropertyKey = 38;
  int get colorValue => _colorValue;

  /// Change the [_colorValue] field value.
  /// [colorValueChanged] will be invoked only if the field's value has changed.
  set colorValue(int value) {
    if (_colorValue == value) {
      return;
    }
    int from = _colorValue;
    _colorValue = value;
    colorValueChanged(from, value);
  }

  void colorValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// Position field with key 39.
  double _position = 0;
  static const int positionPropertyKey = 39;
  double get position => _position;

  /// Change the [_position] field value.
  /// [positionChanged] will be invoked only if the field's value has changed.
  set position(double value) {
    if (_position == value) {
      return;
    }
    double from = _position;
    _position = value;
    positionChanged(from, value);
  }

  void positionChanged(double from, double to);
}
