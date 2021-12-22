/// Core automatically generated
/// lib/src/generated/animation/blend_animation_direct_base.dart.
/// Do not modify manually.

import 'package:rive/src/rive_core/animation/blend_animation.dart';

abstract class BlendAnimationDirectBase extends BlendAnimation {
  static const int typeKey = 77;
  @override
  int get coreType => BlendAnimationDirectBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {BlendAnimationDirectBase.typeKey, BlendAnimationBase.typeKey};

  /// --------------------------------------------------------------------------
  /// InputId field with key 168.
  static const int inputIdInitialValue = -1;
  int _inputId = inputIdInitialValue;
  static const int inputIdPropertyKey = 168;

  /// Id of the input that drives the direct mix value for this animation.
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
  void copy(covariant BlendAnimationDirectBase source) {
    super.copy(source);
    _inputId = source._inputId;
  }
}
