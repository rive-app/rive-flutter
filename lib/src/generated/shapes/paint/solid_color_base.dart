// Core automatically generated
// lib/src/generated/shapes/paint/solid_color_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/component.dart';

abstract class SolidColorBase extends Component {
  static const int typeKey = 18;
  @override
  int get coreType => SolidColorBase.typeKey;
  @override
  Set<int> get coreTypes => {SolidColorBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// ColorValue field with key 37.
  static const int colorValuePropertyKey = 37;
  static const int colorValueInitialValue = 0xFF747474;
  int _colorValue = colorValueInitialValue;
  int get colorValue => _colorValue;

  /// Change the [_colorValue] field value.
  /// [colorValueChanged] will be invoked only if the field's value has changed.
  set colorValue(int value) {
    if (_colorValue == value) {
      return;
    }
    int from = _colorValue;
    _colorValue = value;
    if (hasValidated) {
      colorValueChanged(from, value);
    }
  }

  void colorValueChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is SolidColorBase) {
      _colorValue = source._colorValue;
    }
  }
}
