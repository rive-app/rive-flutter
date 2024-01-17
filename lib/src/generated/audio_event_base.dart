// Core automatically generated lib/src/generated/audio_event_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/event.dart';

abstract class AudioEventBase extends Event {
  static const int typeKey = 407;
  @override
  int get coreType => AudioEventBase.typeKey;
  @override
  Set<int> get coreTypes => {
        AudioEventBase.typeKey,
        EventBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// AssetId field with key 408.
  static const int assetIdPropertyKey = 408;
  static const int assetIdInitialValue = -1;
  int _assetId = assetIdInitialValue;

  /// Audio asset to play when event fires
  int get assetId => _assetId;

  /// Change the [_assetId] field value.
  /// [assetIdChanged] will be invoked only if the field's value has changed.
  set assetId(int value) {
    if (_assetId == value) {
      return;
    }
    int from = _assetId;
    _assetId = value;
    if (hasValidated) {
      assetIdChanged(from, value);
    }
  }

  void assetIdChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is AudioEventBase) {
      _assetId = source._assetId;
    }
  }
}
