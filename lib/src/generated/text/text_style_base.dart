/// Core automatically generated lib/src/generated/text/text_style_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/container_component.dart';

abstract class TextStyleBase extends ContainerComponent {
  static const int typeKey = 137;
  @override
  int get coreType => TextStyleBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TextStyleBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// FontSize field with key 274.
  static const double fontSizeInitialValue = 12;
  double _fontSize = fontSizeInitialValue;
  static const int fontSizePropertyKey = 274;
  double get fontSize => _fontSize;

  /// Change the [_fontSize] field value.
  /// [fontSizeChanged] will be invoked only if the field's value has changed.
  set fontSize(double value) {
    if (_fontSize == value) {
      return;
    }
    double from = _fontSize;
    _fontSize = value;
    if (hasValidated) {
      fontSizeChanged(from, value);
    }
  }

  void fontSizeChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// FontAssetId field with key 279.
  static const int fontAssetIdInitialValue = -1;
  int _fontAssetId = fontAssetIdInitialValue;
  static const int fontAssetIdPropertyKey = 279;
  int get fontAssetId => _fontAssetId;

  /// Change the [_fontAssetId] field value.
  /// [fontAssetIdChanged] will be invoked only if the field's value has
  /// changed.
  set fontAssetId(int value) {
    if (_fontAssetId == value) {
      return;
    }
    int from = _fontAssetId;
    _fontAssetId = value;
    if (hasValidated) {
      fontAssetIdChanged(from, value);
    }
  }

  void fontAssetIdChanged(int from, int to);

  @override
  void copy(covariant TextStyleBase source) {
    super.copy(source);
    _fontSize = source._fontSize;
    _fontAssetId = source._fontAssetId;
  }
}
