// Core automatically generated
// lib/src/generated/animation/listener_fire_event_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/listener_action.dart';

abstract class ListenerFireEventBase extends ListenerAction {
  static const int typeKey = 168;
  @override
  int get coreType => ListenerFireEventBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {ListenerFireEventBase.typeKey, ListenerActionBase.typeKey};

  /// --------------------------------------------------------------------------
  /// EventId field with key 389.
  static const int eventIdInitialValue = -1;
  int _eventId = eventIdInitialValue;
  static const int eventIdPropertyKey = 389;

  /// Id of the Event referenced.
  int get eventId => _eventId;

  /// Change the [_eventId] field value.
  /// [eventIdChanged] will be invoked only if the field's value has changed.
  set eventId(int value) {
    if (_eventId == value) {
      return;
    }
    int from = _eventId;
    _eventId = value;
    if (hasValidated) {
      eventIdChanged(from, value);
    }
  }

  void eventIdChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is ListenerFireEventBase) {
      _eventId = source._eventId;
    }
  }
}
