import 'package:rive/src/generated/constraints/targeted_constraint_base.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/world_transform_component.dart';

export 'package:rive/src/generated/constraints/targeted_constraint_base.dart';

/// A [Constraint] which uses an external target to help influence the computed
/// transform.
abstract class TargetedConstraint extends TargetedConstraintBase {
  WorldTransformComponent? _target;
  WorldTransformComponent? get target => _target;
  set target(WorldTransformComponent? value) {
    if (_target == value) {
      return;
    }

    _target = value;
  }

  @override
  void targetIdChanged(int from, int to) => target = context.resolve(to);

  /// The dependency parent this constraint will be dependent on. We allow
  /// overriding this as some constraints may want to use a helper component
  /// (like the ShapeComposer of the Shape).
  Component? get targetDependencyParent => _target;

  @override
  void buildDependencies() {
    super.buildDependencies();
    // Targeted constraints must have their constrainedComponent update after
    // the target.
    if (constrainedComponent != null) {
      targetDependencyParent?.addDependent(constrainedComponent!, via: this);
    }
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    target = context.resolve(targetId);
  }
}
