// Core automatically generated
// lib/src/generated/shapes/paint/gradient_stop_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/component.dart';

const _coreTypes = {GradientStopBase.typeKey, ComponentBase.typeKey};

abstract class GradientStopBase extends Component {
  static const int typeKey = 19;
  @override
  int get coreType => GradientStopBase.typeKey;
  @override
  Set<int> get coreTypes => _coreTypes;

  /// --------------------------------------------------------------------------
  /// ColorValue field with key 38.
  static const int colorValuePropertyKey = 38;
  static const int colorValueInitialValue = 0xFFFFFFFF;

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

  /// --------------------------------------------------------------------------
  /// Position field with key 39.
  static const int positionPropertyKey = 39;
  static const double positionInitialValue = 0;

  @nonVirtual
  double position_ = positionInitialValue;
  @nonVirtual
  double get position => position_;

  /// Change the [position_] field value.
  /// [positionChanged] will be invoked only if the field's value has changed.
  set position(double value) {
    if (position_ == value) {
      return;
    }
    double from = position_;
    position_ = value;
    if (hasValidated) {
      positionChanged(from, value);
    }
  }

  void positionChanged(double from, double to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is GradientStopBase) {
      colorValue_ = source.colorValue_;
      position_ = source.position_;
    }
  }
}
