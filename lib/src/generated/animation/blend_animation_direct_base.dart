// Core automatically generated
// lib/src/generated/animation/blend_animation_direct_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
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

  /// --------------------------------------------------------------------------
  /// MixValue field with key 297.
  static const double mixValueInitialValue = 100;
  double _mixValue = mixValueInitialValue;
  static const int mixValuePropertyKey = 297;

  /// Direct mix value for this animation.
  double get mixValue => _mixValue;

  /// Change the [_mixValue] field value.
  /// [mixValueChanged] will be invoked only if the field's value has changed.
  set mixValue(double value) {
    if (_mixValue == value) {
      return;
    }
    double from = _mixValue;
    _mixValue = value;
    if (hasValidated) {
      mixValueChanged(from, value);
    }
  }

  void mixValueChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// BlendSource field with key 298.
  static const int blendSourceInitialValue = 0;
  int _blendSource = blendSourceInitialValue;
  static const int blendSourcePropertyKey = 298;

  /// Source to use when establishing the mix value for the animation. 0 means
  /// look at the input, 1 look at the mixValue.
  int get blendSource => _blendSource;

  /// Change the [_blendSource] field value.
  /// [blendSourceChanged] will be invoked only if the field's value has
  /// changed.
  set blendSource(int value) {
    if (_blendSource == value) {
      return;
    }
    int from = _blendSource;
    _blendSource = value;
    if (hasValidated) {
      blendSourceChanged(from, value);
    }
  }

  void blendSourceChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is BlendAnimationDirectBase) {
      _inputId = source._inputId;
      _mixValue = source._mixValue;
      _blendSource = source._blendSource;
    }
  }
}
