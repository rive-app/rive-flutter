/// Core automatically generated
/// lib/src/generated/text/text_style_axis_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/component.dart';

abstract class TextStyleAxisBase extends Component {
  static const int typeKey = 144;
  @override
  int get coreType => TextStyleAxisBase.typeKey;
  @override
  Set<int> get coreTypes => {TextStyleAxisBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Tag field with key 289.
  static const int tagInitialValue = 0;
  int _tag = tagInitialValue;
  static const int tagPropertyKey = 289;
  int get tag => _tag;

  /// Change the [_tag] field value.
  /// [tagChanged] will be invoked only if the field's value has changed.
  set tag(int value) {
    if (_tag == value) {
      return;
    }
    int from = _tag;
    _tag = value;
    if (hasValidated) {
      tagChanged(from, value);
    }
  }

  void tagChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// AxisValue field with key 288.
  static const double axisValueInitialValue = 0;
  double _axisValue = axisValueInitialValue;
  static const int axisValuePropertyKey = 288;
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
  void copy(covariant TextStyleAxisBase source) {
    super.copy(source);
    _tag = source._tag;
    _axisValue = source._axisValue;
  }
}
