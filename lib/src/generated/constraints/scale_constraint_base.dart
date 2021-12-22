/// Core automatically generated
/// lib/src/generated/constraints/scale_constraint_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/constraints/constraint_base.dart';
import 'package:rive/src/generated/constraints/targeted_constraint_base.dart';
import 'package:rive/src/generated/constraints/transform_component_constraint_base.dart';
import 'package:rive/src/generated/constraints/transform_space_constraint_base.dart';
import 'package:rive/src/rive_core/constraints/transform_component_constraint_y.dart';

abstract class ScaleConstraintBase extends TransformComponentConstraintY {
  static const int typeKey = 88;
  @override
  int get coreType => ScaleConstraintBase.typeKey;
  @override
  Set<int> get coreTypes => {
        ScaleConstraintBase.typeKey,
        TransformComponentConstraintYBase.typeKey,
        TransformComponentConstraintBase.typeKey,
        TransformSpaceConstraintBase.typeKey,
        TargetedConstraintBase.typeKey,
        ConstraintBase.typeKey,
        ComponentBase.typeKey
      };
}
