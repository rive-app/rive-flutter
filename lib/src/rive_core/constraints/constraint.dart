import 'package:rive/src/generated/constraints/constraint_base.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/transform_component.dart';
import 'package:rive/src/rive_core/world_transform_component.dart';

export 'package:rive/src/generated/constraints/constraint_base.dart';

/// A specialized [Component] which can be parented to any [TransformComponent]
/// providing rules for how to constrain its transform space.
abstract class Constraint extends ConstraintBase {
  /// Returns the [TransformComponent] which this [Constraint] is applied to.
  TransformComponent? get constrainedComponent =>
      parent is TransformComponent ? parent as TransformComponent : null;

  @override
  void strengthChanged(double from, double to) =>
      constrainedComponent?.markTransformDirty();

  @override
  bool validate() => super.validate() && parent is TransformComponent;

  void constrain(TransformComponent component);

  @override
  void buildDependencies() {
    super.buildDependencies();

    parent!.addDependent(this);
  }

  @override
  void update(int dirt) {}

  void markConstraintDirty() => constrainedComponent?.markTransformDirty();

  @override
  void onDirty(int mask) => markConstraintDirty();
}

/// Get the parent's world transform. Takes into consideration when the parent
/// is an artboard.
Mat2D parentWorld(TransformComponent component) {
  var parent = component.parent;
  if (parent is WorldTransformComponent) {
    return parent.worldTransform;
  }
  return Mat2D();
}
