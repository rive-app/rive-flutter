import 'package:rive/src/generated/constraints/targeted_constraint_base.dart';
import 'package:rive/src/rive_core/transform_component.dart';
export 'package:rive/src/generated/constraints/targeted_constraint_base.dart';

/// A [Constraint] which uses an external target to help influence the computed
/// transform.
abstract class TargetedConstraint extends TargetedConstraintBase {
  TransformComponent? _target;
  TransformComponent? get target => _target;
  set target(TransformComponent? value) {
    if (_target == value) {
      return;
    }

    _target = value;
  }

  @override
  void targetIdChanged(int from, int to) => target = context.resolve(to);

  @override
  void buildDependencies() {
    super.buildDependencies();
    // Targeted constraints must have their constrainedComponent update after
    // the target.
    if (constrainedComponent != null) {
      _target?.addDependent(constrainedComponent!, via: this);
    }
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    target = context.resolve(targetId);
  }

}
