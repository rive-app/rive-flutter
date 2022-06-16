/// Core automatically generated lib/src/generated/nested_animation_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/container_component.dart';

abstract class NestedAnimationBase extends ContainerComponent {
  static const int typeKey = 93;
  @override
  int get coreType => NestedAnimationBase.typeKey;
  @override
  Set<int> get coreTypes => {
        NestedAnimationBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// AnimationId field with key 198.
  static const int animationIdInitialValue = -1;
  int _animationId = animationIdInitialValue;
  static const int animationIdPropertyKey = 198;

  /// Identifier used to track the animation in the nested artboard.
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
  void copy(covariant NestedAnimationBase source) {
    super.copy(source);
    _animationId = source._animationId;
  }
}
