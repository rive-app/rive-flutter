import 'package:rive/src/generated/constraints/transform_component_constraint_base.dart';
import 'package:rive/src/rive_core/transform_space.dart';
export 'package:rive/src/generated/constraints/transform_component_constraint_base.dart';

abstract class TransformComponentConstraint
    extends TransformComponentConstraintBase {
  TransformSpace get minMaxSpace => TransformSpace.values[minMaxSpaceValue];
  set minMaxSpace(TransformSpace value) => minMaxSpaceValue = value.index;

  @override
  void minMaxSpaceValueChanged(int from, int to) => markConstraintDirty();

  @override
  void minValueChanged(double from, double to) => markConstraintDirty();

  @override
  void maxValueChanged(double from, double to) => markConstraintDirty();

  @override
  void copyFactorChanged(double from, double to) => markConstraintDirty();

  @override
  void doesCopyChanged(bool from, bool to) => markConstraintDirty();

  @override
  void maxChanged(bool from, bool to) => markConstraintDirty();

  @override
  void minChanged(bool from, bool to) => markConstraintDirty();

  @override
  void offsetChanged(bool from, bool to) => markConstraintDirty();
}
