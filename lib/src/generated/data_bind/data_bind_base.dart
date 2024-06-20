// Core automatically generated
// lib/src/generated/data_bind/data_bind_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/component.dart';

abstract class DataBindBase extends Component {
  static const int typeKey = 446;
  @override
  int get coreType => DataBindBase.typeKey;
  @override
  Set<int> get coreTypes => {DataBindBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// TargetId field with key 585.
  static const int targetIdPropertyKey = 585;
  static const int targetIdInitialValue = -1;
  int _targetId = targetIdInitialValue;

  /// Identifier used to track the object that is targetted.
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
  /// PropertyKey field with key 586.
  static const int propertyKeyPropertyKey = 586;
  static const int propertyKeyInitialValue = CoreContext.invalidPropertyKey;
  int _propertyKey = propertyKeyInitialValue;

  /// The property that is targeted.
  int get propertyKey => _propertyKey;

  /// Change the [_propertyKey] field value.
  /// [propertyKeyChanged] will be invoked only if the field's value has
  /// changed.
  set propertyKey(int value) {
    if (_propertyKey == value) {
      return;
    }
    int from = _propertyKey;
    _propertyKey = value;
    if (hasValidated) {
      propertyKeyChanged(from, value);
    }
  }

  void propertyKeyChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// ModeValue field with key 587.
  static const int modeValuePropertyKey = 587;
  static const int modeValueInitialValue = 0;
  int _modeValue = modeValueInitialValue;

  /// Backing enum value for the binding mode.
  int get modeValue => _modeValue;

  /// Change the [_modeValue] field value.
  /// [modeValueChanged] will be invoked only if the field's value has changed.
  set modeValue(int value) {
    if (_modeValue == value) {
      return;
    }
    int from = _modeValue;
    _modeValue = value;
    if (hasValidated) {
      modeValueChanged(from, value);
    }
  }

  void modeValueChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is DataBindBase) {
      _targetId = source._targetId;
      _propertyKey = source._propertyKey;
      _modeValue = source._modeValue;
    }
  }
}
