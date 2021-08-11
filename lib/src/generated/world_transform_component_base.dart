/// Core automatically generated
/// lib/src/generated/world_transform_component_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/container_component.dart';

abstract class WorldTransformComponentBase extends ContainerComponent {
  static const int typeKey = 91;
  @override
  int get coreType => WorldTransformComponentBase.typeKey;
  @override
  Set<int> get coreTypes => {
        WorldTransformComponentBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// Opacity field with key 18.
  static const double opacityInitialValue = 1;
  double _opacity = opacityInitialValue;
  static const int opacityPropertyKey = 18;
  double get opacity => _opacity;

  /// Change the [_opacity] field value.
  /// [opacityChanged] will be invoked only if the field's value has changed.
  set opacity(double value) {
    if (_opacity == value) {
      return;
    }
    double from = _opacity;
    _opacity = value;
    if (hasValidated) {
      opacityChanged(from, value);
    }
  }

  void opacityChanged(double from, double to);

  @override
  void copy(covariant WorldTransformComponentBase source) {
    super.copy(source);
    _opacity = source._opacity;
  }
}
