/// Core automatically generated
/// lib/src/generated/animation/nested_linear_animation_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/nested_animation.dart';

abstract class NestedLinearAnimationBase
    extends NestedAnimation<LinearAnimation> {
  static const int typeKey = 97;
  @override
  int get coreType => NestedLinearAnimationBase.typeKey;
  @override
  Set<int> get coreTypes => {
        NestedLinearAnimationBase.typeKey,
        NestedAnimationBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Mix field with key 200.
  static const double mixInitialValue = 1;
  double _mix = mixInitialValue;
  static const int mixPropertyKey = 200;

  /// Value to mix the animation in.
  double get mix => _mix;

  /// Change the [_mix] field value.
  /// [mixChanged] will be invoked only if the field's value has changed.
  set mix(double value) {
    if (_mix == value) {
      return;
    }
    double from = _mix;
    _mix = value;
    if (hasValidated) {
      mixChanged(from, value);
    }
  }

  void mixChanged(double from, double to);

  @override
  void copy(covariant NestedLinearAnimationBase source) {
    super.copy(source);
    _mix = source._mix;
  }
}
