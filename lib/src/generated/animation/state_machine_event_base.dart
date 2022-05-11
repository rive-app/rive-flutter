/// Core automatically generated
/// lib/src/generated/animation/state_machine_event_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/animation/state_machine_component.dart';

abstract class StateMachineEventBase extends StateMachineComponent {
  static const int typeKey = 114;
  @override
  int get coreType => StateMachineEventBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {StateMachineEventBase.typeKey, StateMachineComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// TargetId field with key 224.
  static const int targetIdInitialValue = 0;
  int _targetId = targetIdInitialValue;
  static const int targetIdPropertyKey = 224;

  /// Identifier used to track the object use as a target fo this event.
  int get targetId => _targetId;

  /// Change the [_targetId] field value.
  /// [targetIdChanged] will be invoked only if the field's value has changed.
  set targetId(int value) {
    if (_targetId == value) {
      return;
    }
    int from = _targetId;
    _targetId = value;
    if (hasValidated) {
      targetIdChanged(from, value);
    }
  }

  void targetIdChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// EventTypeValue field with key 225.
  static const int eventTypeValueInitialValue = 0;
  int _eventTypeValue = eventTypeValueInitialValue;
  static const int eventTypeValuePropertyKey = 225;

  /// Event type (hover, click, etc).
  int get eventTypeValue => _eventTypeValue;

  /// Change the [_eventTypeValue] field value.
  /// [eventTypeValueChanged] will be invoked only if the field's value has
  /// changed.
  set eventTypeValue(int value) {
    if (_eventTypeValue == value) {
      return;
    }
    int from = _eventTypeValue;
    _eventTypeValue = value;
    if (hasValidated) {
      eventTypeValueChanged(from, value);
    }
  }

  void eventTypeValueChanged(int from, int to);

  @override
  void copy(covariant StateMachineEventBase source) {
    super.copy(source);
    _targetId = source._targetId;
    _eventTypeValue = source._eventTypeValue;
  }
}
