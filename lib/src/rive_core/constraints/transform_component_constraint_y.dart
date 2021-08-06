import 'package:rive/src/generated/constraints/transform_component_constraint_y_base.dart';
export 'package:rive/src/generated/constraints/transform_component_constraint_y_base.dart';

abstract class TransformComponentConstraintY
    extends TransformComponentConstraintYBase {
  @override
  void minValueYChanged(double from, double to) => markConstraintDirty();

  @override
  void maxValueYChanged(double from, double to) => markConstraintDirty();

  @override
  void copyFactorYChanged(double from, double to) => markConstraintDirty();

  @override
  void doesCopyYChanged(bool from, bool to) => markConstraintDirty();

  @override
  void maxYChanged(bool from, bool to) => markConstraintDirty();

  @override
  void minYChanged(bool from, bool to) => markConstraintDirty();
}
