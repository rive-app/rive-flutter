// Core automatically generated
// lib/src/generated/text/text_style_feature_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/component.dart';

abstract class TextStyleFeatureBase extends Component {
  static const int typeKey = 164;
  @override
  int get coreType => TextStyleFeatureBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {TextStyleFeatureBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Tag field with key 356.
  static const int tagPropertyKey = 356;
  static const int tagInitialValue = 0;
  int _tag = tagInitialValue;
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
  /// FeatureValue field with key 357.
  static const int featureValuePropertyKey = 357;
  static const int featureValueInitialValue = 1;
  int _featureValue = featureValueInitialValue;
  int get featureValue => _featureValue;

  /// Change the [_featureValue] field value.
  /// [featureValueChanged] will be invoked only if the field's value has
  /// changed.
  set featureValue(int value) {
    if (_featureValue == value) {
      return;
    }
    int from = _featureValue;
    _featureValue = value;
    if (hasValidated) {
      featureValueChanged(from, value);
    }
  }

  void featureValueChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is TextStyleFeatureBase) {
      _tag = source._tag;
      _featureValue = source._featureValue;
    }
  }
}
