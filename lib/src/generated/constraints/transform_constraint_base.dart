/// Core automatically generated
/// lib/src/generated/constraints/transform_constraint_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/constraints/constraint_base.dart';
import 'package:rive/src/generated/constraints/targeted_constraint_base.dart';
import 'package:rive/src/rive_core/constraints/transform_space_constraint.dart';

abstract class TransformConstraintBase extends TransformSpaceConstraint {
  static const int typeKey = 83;
  @override
  int get coreType => TransformConstraintBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TransformConstraintBase.typeKey,
        TransformSpaceConstraintBase.typeKey,
        TargetedConstraintBase.typeKey,
        ConstraintBase.typeKey,
        ComponentBase.typeKey
      };
}
