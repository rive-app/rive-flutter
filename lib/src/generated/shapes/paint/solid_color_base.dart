// Core automatically generated
// lib/src/generated/shapes/paint/solid_color_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/component.dart';

const _coreTypes = {SolidColorBase.typeKey, ComponentBase.typeKey};

abstract class SolidColorBase extends Component {
  static const int typeKey = 18;
  @override
  int get coreType => SolidColorBase.typeKey;
  @override
  Set<int> get coreTypes => _coreTypes;

  /// --------------------------------------------------------------------------
  /// ColorValue field with key 37.
  static const int colorValuePropertyKey = 37;
  static const int colorValueInitialValue = 0xFF747474;

  @nonVirtual
  int colorValue_ = colorValueInitialValue;
  @nonVirtual
  int get colorValue => colorValue_;

  /// Change the [colorValue_] field value.
  /// [colorValueChanged] will be invoked only if the field's value has changed.
  set colorValue(int value) {
    if (colorValue_ == value) {
      return;
    }
    int from = colorValue_;
    colorValue_ = value;
    if (hasValidated) {
      colorValueChanged(from, value);
    }
  }

  void colorValueChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is SolidColorBase) {
      colorValue_ = source.colorValue_;
    }
  }
}
