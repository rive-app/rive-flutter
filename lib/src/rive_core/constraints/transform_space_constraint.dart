import 'package:rive/src/generated/constraints/transform_space_constraint_base.dart';
import 'package:rive/src/rive_core/transform_space.dart';
import 'package:rive_common/math.dart';

export 'package:rive/src/generated/constraints/transform_space_constraint_base.dart';

abstract class TransformSpaceConstraint extends TransformSpaceConstraintBase {
  final TransformComponents componentsA = TransformComponents();
  final TransformComponents componentsB = TransformComponents();

  TransformSpace get destSpace => TransformSpace.values[destSpaceValue];
  set destSpace(TransformSpace value) => destSpaceValue = value.index;

  TransformSpace get sourceSpace => TransformSpace.values[sourceSpaceValue];
  set sourceSpace(TransformSpace value) => sourceSpaceValue = value.index;

  @override
  void destSpaceValueChanged(int from, int to) => markConstraintDirty();

  @override
  void sourceSpaceValueChanged(int from, int to) => markConstraintDirty();
}
