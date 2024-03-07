// Core automatically generated
// lib/src/generated/animation/state_machine_fire_event_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class StateMachineFireEventBase<T extends CoreContext>
    extends Core<T> {
  static const int typeKey = 169;
  @override
  int get coreType => StateMachineFireEventBase.typeKey;
  @override
  Set<int> get coreTypes => {StateMachineFireEventBase.typeKey};

  /// --------------------------------------------------------------------------
  /// EventId field with key 392.
  static const int eventIdPropertyKey = 392;
  static const int eventIdInitialValue = -1;
  int _eventId = eventIdInitialValue;

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

  /// --------------------------------------------------------------------------
  /// OccursValue field with key 393.
  static const int occursValuePropertyKey = 393;
  static const int occursValueInitialValue = 0;
  int _occursValue = occursValueInitialValue;

  /// When the event fires.
  int get occursValue => _occursValue;

  /// Change the [_occursValue] field value.
  /// [occursValueChanged] will be invoked only if the field's value has
  /// changed.
  set occursValue(int value) {
    if (_occursValue == value) {
      return;
    }
    int from = _occursValue;
    _occursValue = value;
    if (hasValidated) {
      occursValueChanged(from, value);
    }
  }

  void occursValueChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is StateMachineFireEventBase) {
      _eventId = source._eventId;
      _occursValue = source._occursValue;
    }
  }
}
