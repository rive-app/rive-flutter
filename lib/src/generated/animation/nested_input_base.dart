/// Core automatically generated
/// lib/src/generated/animation/nested_input_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/component.dart';

abstract class NestedInputBase extends Component {
  static const int typeKey = 121;
  @override
  int get coreType => NestedInputBase.typeKey;
  @override
  Set<int> get coreTypes => {NestedInputBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// InputId field with key 237.
  static const int inputIdInitialValue = -1;
  int _inputId = inputIdInitialValue;
  static const int inputIdPropertyKey = 237;

  /// Identifier used to track the actual backing state machine input.
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
  void copy(covariant NestedInputBase source) {
    super.copy(source);
    _inputId = source._inputId;
  }
}
