/// Core automatically generated
/// lib/src/generated/animation/listener_input_change_base.dart.
/// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class ListenerInputChangeBase<T extends CoreContext> extends Core<T> {
  static const int typeKey = 116;
  @override
  int get coreType => ListenerInputChangeBase.typeKey;
  @override
  Set<int> get coreTypes => {ListenerInputChangeBase.typeKey};

  /// --------------------------------------------------------------------------
  /// InputId field with key 227.
  static const int inputIdInitialValue = -1;
  int _inputId = inputIdInitialValue;
  static const int inputIdPropertyKey = 227;

  /// Id of the StateMachineInput referenced.
  int get inputId => _inputId;

  /// Change the [_inputId] field value.
  /// [inputIdChanged] will be invoked only if the field's value has changed.
  set inputId(int value) {
    if (_inputId == value) {
      return;
    }
    int from = _inputId;
    _inputId = value;
    if (hasValidated) {
      inputIdChanged(from, value);
    }
  }

  void inputIdChanged(int from, int to);

  @override
  void copy(covariant ListenerInputChangeBase source) {
    _inputId = source._inputId;
  }
}
