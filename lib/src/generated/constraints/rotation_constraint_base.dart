/// Core automatically generated
/// lib/src/generated/constraints/rotation_constraint_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/constraints/constraint_base.dart';
import 'package:rive/src/generated/constraints/targeted_constraint_base.dart';
import 'package:rive/src/generated/constraints/transform_space_constraint_base.dart';
import 'package:rive/src/rive_core/constraints/transform_component_constraint.dart';

abstract class RotationConstraintBase extends TransformComponentConstraint {
  static const int typeKey = 89;
  @override
  int get coreType => RotationConstraintBase.typeKey;
  @override
  Set<int> get coreTypes => {
        RotationConstraintBase.typeKey,
        TransformComponentConstraintBase.typeKey,
        TransformSpaceConstraintBase.typeKey,
        TargetedConstraintBase.typeKey,
        ConstraintBase.typeKey,
        ComponentBase.typeKey
      };
}
