/// Core automatically generated
/// lib/src/generated/shapes/paint/radial_gradient_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/shapes/paint/linear_gradient.dart';

abstract class RadialGradientBase extends LinearGradient {
  static const int typeKey = 17;
  @override
  int get coreType => RadialGradientBase.typeKey;
  @override
  Set<int> get coreTypes => {
        RadialGradientBase.typeKey,
        LinearGradientBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };
}
