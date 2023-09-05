// Core automatically generated lib/src/generated/open_url_event_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/event.dart';

abstract class OpenUrlEventBase extends Event {
  static const int typeKey = 131;
  @override
  int get coreType => OpenUrlEventBase.typeKey;
  @override
  Set<int> get coreTypes => {
        OpenUrlEventBase.typeKey,
        EventBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Url field with key 248.
  static const int urlPropertyKey = 248;
  static const String urlInitialValue = '';
  String _url = urlInitialValue;

  /// URL to open.
  String get url => _url;

  /// Change the [_url] field value.
  /// [urlChanged] will be invoked only if the field's value has changed.
  set url(String value) {
    if (_url == value) {
      return;
    }
    String from = _url;
    _url = value;
    if (hasValidated) {
      urlChanged(from, value);
    }
  }

  void urlChanged(String from, String to);

  /// --------------------------------------------------------------------------
  /// TargetValue field with key 249.
  static const int targetValuePropertyKey = 249;
  static const int targetValueInitialValue = 0;
  int _targetValue = targetValueInitialValue;

  /// Backing value for the target enum.
  int get targetValue => _targetValue;

  /// Change the [_targetValue] field value.
  /// [targetValueChanged] will be invoked only if the field's value has
  /// changed.
  set targetValue(int value) {
    if (_targetValue == value) {
      return;
    }
    int from = _targetValue;
    _targetValue = value;
    if (hasValidated) {
      targetValueChanged(from, value);
    }
  }

  void targetValueChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is OpenUrlEventBase) {
      _url = source._url;
      _targetValue = source._targetValue;
    }
  }
}
