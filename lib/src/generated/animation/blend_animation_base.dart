/// Core automatically generated
/// lib/src/generated/animation/blend_animation_base.dart.
/// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class BlendAnimationBase<T extends CoreContext> extends Core<T> {
  static const int typeKey = 74;
  @override
  int get coreType => BlendAnimationBase.typeKey;
  @override
  Set<int> get coreTypes => {BlendAnimationBase.typeKey};

  /// --------------------------------------------------------------------------
  /// AnimationId field with key 165.
  static const int animationIdInitialValue = -1;
  int _animationId = animationIdInitialValue;
  static const int animationIdPropertyKey = 165;

  /// Id of the animation this BlendAnimation references.
  int get animationId => _animationId;

  /// Change the [_animationId] field value.
  /// [animationIdChanged] will be invoked only if the field's value has
  /// changed.
  set animationId(int value) {
    if (_animationId == value) {
      return;
    }
    int from = _animationId;
    _animationId = value;
    if (hasValidated) {
      animationIdChanged(from, value);
    }
  }

  void animationIdChanged(int from, int to);

  @override
  void copy(covariant BlendAnimationBase source) {
    _animationId = source._animationId;
  }
}
