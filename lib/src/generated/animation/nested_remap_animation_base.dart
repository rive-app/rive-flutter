/// Core automatically generated
/// lib/src/generated/animation/nested_remap_animation_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/generated/nested_animation_base.dart';
import 'package:rive/src/rive_core/animation/nested_linear_animation.dart';

abstract class NestedRemapAnimationBase extends NestedLinearAnimation {
  static const int typeKey = 98;
  @override
  int get coreType => NestedRemapAnimationBase.typeKey;
  @override
  Set<int> get coreTypes => {
        NestedRemapAnimationBase.typeKey,
        NestedLinearAnimationBase.typeKey,
        NestedAnimationBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Time field with key 202.
  static const double timeInitialValue = 0.0;
  double _time = timeInitialValue;
  static const int timePropertyKey = 202;

  /// Time value in seconds for the nested linear animation.
  double get time => _time;

  /// Change the [_time] field value.
  /// [timeChanged] will be invoked only if the field's value has changed.
  set time(double value) {
    if (_time == value) {
      return;
    }
    double from = _time;
    _time = value;
    if (hasValidated) {
      timeChanged(from, value);
    }
  }

  void timeChanged(double from, double to);

  @override
  void copy(covariant NestedRemapAnimationBase source) {
    super.copy(source);
    _time = source._time;
  }
}
