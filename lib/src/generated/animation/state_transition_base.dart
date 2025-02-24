// Core automatically generated
// lib/src/generated/animation/state_transition_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/state_machine_layer_component.dart';

const _coreTypes = <int>{StateTransitionBase.typeKey, StateMachineLayerComponentBase.typeKey};

abstract class StateTransitionBase extends StateMachineLayerComponent {
  static const int typeKey = 65;
  @override
  int get coreType => StateTransitionBase.typeKey;
  @override
  Set<int> get coreTypes => _coreTypes;

  /// --------------------------------------------------------------------------
  /// StateToId field with key 151.
  static const int stateToIdPropertyKey = 151;
  static const int stateToIdInitialValue = -1;
  int _stateToId = stateToIdInitialValue;

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
  static const int flagsPropertyKey = 152;
  static const int flagsInitialValue = 0;
  int _flags = flagsInitialValue;
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
  static const int durationPropertyKey = 158;
  static const int durationInitialValue = 0;
  int _duration = durationInitialValue;

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
  static const int exitTimePropertyKey = 160;
  static const int exitTimeInitialValue = 0;
  int _exitTime = exitTimeInitialValue;

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

  /// --------------------------------------------------------------------------
  /// InterpolationType field with key 349.
  static const int interpolationTypePropertyKey = 349;
  static const int interpolationTypeInitialValue = 1;
  int _interpolationType = interpolationTypeInitialValue;

  /// The type of interpolation index in Interpolation applied to this state
  /// transition ('linear' by default).
  int get interpolationType => _interpolationType;

  /// Change the [_interpolationType] field value.
  /// [interpolationTypeChanged] will be invoked only if the field's value has
  /// changed.
  set interpolationType(int value) {
    if (_interpolationType == value) {
      return;
    }
    int from = _interpolationType;
    _interpolationType = value;
    if (hasValidated) {
      interpolationTypeChanged(from, value);
    }
  }

  void interpolationTypeChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// InterpolatorId field with key 350.
  static const int interpolatorIdPropertyKey = 350;
  static const int interpolatorIdInitialValue = -1;
  int _interpolatorId = interpolatorIdInitialValue;

  /// The id of the custom interpolator used when interpolation is Cubic.
  int get interpolatorId => _interpolatorId;

  /// Change the [_interpolatorId] field value.
  /// [interpolatorIdChanged] will be invoked only if the field's value has
  /// changed.
  set interpolatorId(int value) {
    if (_interpolatorId == value) {
      return;
    }
    int from = _interpolatorId;
    _interpolatorId = value;
    if (hasValidated) {
      interpolatorIdChanged(from, value);
    }
  }

  void interpolatorIdChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// RandomWeight field with key 537.
  static const int randomWeightPropertyKey = 537;
  static const int randomWeightInitialValue = 1;
  int _randomWeight = randomWeightInitialValue;

  /// Weight of the transition in the overall random options
  int get randomWeight => _randomWeight;

  /// Change the [_randomWeight] field value.
  /// [randomWeightChanged] will be invoked only if the field's value has
  /// changed.
  set randomWeight(int value) {
    if (_randomWeight == value) {
      return;
    }
    int from = _randomWeight;
    _randomWeight = value;
    if (hasValidated) {
      randomWeightChanged(from, value);
    }
  }

  void randomWeightChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is StateTransitionBase) {
      _stateToId = source._stateToId;
      _flags = source._flags;
      _duration = source._duration;
      _exitTime = source._exitTime;
      _interpolationType = source._interpolationType;
      _interpolatorId = source._interpolatorId;
      _randomWeight = source._randomWeight;
    }
  }
}
