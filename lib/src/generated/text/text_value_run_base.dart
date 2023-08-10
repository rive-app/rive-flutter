// Core automatically generated
// lib/src/generated/text/text_value_run_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/component.dart';

abstract class TextValueRunBase extends Component {
  static const int typeKey = 135;
  @override
  int get coreType => TextValueRunBase.typeKey;
  @override
  Set<int> get coreTypes => {TextValueRunBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// StyleId field with key 272.
  static const int styleIdInitialValue = -1;
  int _styleId = styleIdInitialValue;
  static const int styleIdPropertyKey = 272;

  /// The id of the style to be applied to this run.
  int get styleId => _styleId;

  /// Change the [_styleId] field value.
  /// [styleIdChanged] will be invoked only if the field's value has changed.
  set styleId(int value) {
    if (_styleId == value) {
      return;
    }
    int from = _styleId;
    _styleId = value;
    if (hasValidated) {
      styleIdChanged(from, value);
    }
  }

  void styleIdChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// Text field with key 268.
  static const String textInitialValue = '';
  String _text = textInitialValue;
  static const int textPropertyKey = 268;

  /// The text string value.
  String get text => _text;

  /// Change the [_text] field value.
  /// [textChanged] will be invoked only if the field's value has changed.
  set text(String value) {
    if (_text == value) {
      return;
    }
    String from = _text;
    _text = value;
    if (hasValidated) {
      textChanged(from, value);
    }
  }

  void textChanged(String from, String to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is TextValueRunBase) {
      _styleId = source._styleId;
      _text = source._text;
    }
  }
}
