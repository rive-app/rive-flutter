// Core automatically generated lib/src/generated/text/text_style_base.dart.
// Do not modify manually.

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
  static const int fontSizePropertyKey = 274;
  static const double fontSizeInitialValue = 12;
  double _fontSize = fontSizeInitialValue;
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
  /// LineHeight field with key 370.
  static const int lineHeightPropertyKey = 370;
  static const double lineHeightInitialValue = -1.0;
  double _lineHeight = lineHeightInitialValue;
  double get lineHeight => _lineHeight;

  /// Change the [_lineHeight] field value.
  /// [lineHeightChanged] will be invoked only if the field's value has changed.
  set lineHeight(double value) {
    if (_lineHeight == value) {
      return;
    }
    double from = _lineHeight;
    _lineHeight = value;
    if (hasValidated) {
      lineHeightChanged(from, value);
    }
  }

  void lineHeightChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// LetterSpacing field with key 390.
  static const int letterSpacingPropertyKey = 390;
  static const double letterSpacingInitialValue = 0.0;
  double _letterSpacing = letterSpacingInitialValue;
  double get letterSpacing => _letterSpacing;

  /// Change the [_letterSpacing] field value.
  /// [letterSpacingChanged] will be invoked only if the field's value has
  /// changed.
  set letterSpacing(double value) {
    if (_letterSpacing == value) {
      return;
    }
    double from = _letterSpacing;
    _letterSpacing = value;
    if (hasValidated) {
      letterSpacingChanged(from, value);
    }
  }

  void letterSpacingChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// FontAssetId field with key 279.
  static const int fontAssetIdPropertyKey = 279;
  static const int fontAssetIdInitialValue = -1;
  int _fontAssetId = fontAssetIdInitialValue;
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
  void copy(Core source) {
    super.copy(source);
    if (source is TextStyleBase) {
      _fontSize = source._fontSize;
      _lineHeight = source._lineHeight;
      _letterSpacing = source._letterSpacing;
      _fontAssetId = source._fontAssetId;
    }
  }
}
