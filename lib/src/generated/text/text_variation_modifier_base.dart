/// Core automatically generated
/// lib/src/generated/text/text_variation_modifier_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/text/text_modifier_base.dart';
import 'package:rive/src/rive_core/text/text_shape_modifier.dart';

abstract class TextVariationModifierBase extends TextShapeModifier {
  static const int typeKey = 162;
  @override
  int get coreType => TextVariationModifierBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TextVariationModifierBase.typeKey,
        TextShapeModifierBase.typeKey,
        TextModifierBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// AxisTag field with key 320.
  static const int axisTagInitialValue = 0;
  int _axisTag = axisTagInitialValue;
  static const int axisTagPropertyKey = 320;
  int get axisTag => _axisTag;

  /// Change the [_axisTag] field value.
  /// [axisTagChanged] will be invoked only if the field's value has changed.
  set axisTag(int value) {
    if (_axisTag == value) {
      return;
    }
    int from = _axisTag;
    _axisTag = value;
    if (hasValidated) {
      axisTagChanged(from, value);
    }
  }

  void axisTagChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// AxisValue field with key 321.
  static const double axisValueInitialValue = 0;
  double _axisValue = axisValueInitialValue;
  static const int axisValuePropertyKey = 321;
  double get axisValue => _axisValue;

  /// Change the [_axisValue] field value.
  /// [axisValueChanged] will be invoked only if the field's value has changed.
  set axisValue(double value) {
    if (_axisValue == value) {
      return;
    }
    double from = _axisValue;
    _axisValue = value;
    if (hasValidated) {
      axisValueChanged(from, value);
    }
  }

  void axisValueChanged(double from, double to);

  @override
  void copy(covariant TextVariationModifierBase source) {
    super.copy(source);
    _axisTag = source._axisTag;
    _axisValue = source._axisValue;
  }
}
