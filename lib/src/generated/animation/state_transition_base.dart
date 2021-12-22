/// Core automatically generated
/// lib/src/generated/animation/state_transition_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/animation/state_machine_layer_component.dart';

abstract class StateTransitionBase extends StateMachineLayerComponent {
  static const int typeKey = 65;
  @override
  int get coreType => StateTransitionBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {StateTransitionBase.typeKey, StateMachineLayerComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// StateToId field with key 151.
  static const int stateToIdInitialValue = -1;
  int _stateToId = stateToIdInitialValue;
  static const int stateToIdPropertyKey = 151;

  /// Id of the state this transition originates from.
  int get stateToId => _stateToId;

  /// Change the [_stateToId] field value.
  /// [stateToIdChanged] will be invoked only if the field's value has changed.
  set stateToId(int value) {
    if (_stateToId == value) {
      return;
    }
    int from = _stateToId;
    _stateToId = value;
    if (hasValidated) {
      stateToIdChanged(from, value);
    }
  }

  void stateToIdChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// Flags field with key 152.
  static const int flagsInitialValue = 0;
  int _flags = flagsInitialValue;
  static const int flagsPropertyKey = 152;
  int get flags => _flags;

  /// Change the [_flags] field value.
  /// [flagsChanged] will be invoked only if the field's value has changed.
  set flags(int value) {
    if (_flags == value) {
      return;
    }
    int from = _flags;
    _flags = value;
    if (hasValidated) {
      flagsChanged(from, value);
    }
  }

  void flagsChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// Duration field with key 158.
  static const int durationInitialValue = 0;
  int _duration = durationInitialValue;
  static const int durationPropertyKey = 158;

  /// Duration of the trasition (mix time) in milliseconds or percentage (0-100)
  /// based on flags.
  int get duration => _duration;

  /// Change the [_duration] field value.
  /// [durationChanged] will be invoked only if the field's value has changed.
  set duration(int value) {
    if (_duration == value) {
      return;
    }
    int from = _duration;
    _duration = value;
    if (hasValidated) {
      durationChanged(from, value);
    }
  }

  void durationChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// ExitTime field with key 160.
  static const int exitTimeInitialValue = 0;
  int _exitTime = exitTimeInitialValue;
  static const int exitTimePropertyKey = 160;

  /// Duration in milliseconds that must elapse before allowing the state to
  /// change. If the flags mark this property as being percentage based, the
  /// value is in 0-100% of the outgoing animation's duration
  int get exitTime => _exitTime;

  /// Change the [_exitTime] field value.
  /// [exitTimeChanged] will be invoked only if the field's value has changed.
  set exitTime(int value) {
    if (_exitTime == value) {
      return;
    }
    int from = _exitTime;
    _exitTime = value;
    if (hasValidated) {
      exitTimeChanged(from, value);
    }
  }

  void exitTimeChanged(int from, int to);

  @override
  void copy(covariant StateTransitionBase source) {
    super.copy(source);
    _stateToId = source._stateToId;
    _flags = source._flags;
    _duration = source._duration;
    _exitTime = source._exitTime;
  }
}
