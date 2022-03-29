import 'package:rive/src/generated/constraints/distance_constraint_base.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/transform_component.dart';

export 'package:rive/src/generated/constraints/distance_constraint_base.dart';

/// [DistanceConstraint]'s logical distancing method.
enum DistanceConstraintMode { closer, further, exact }

const _distanceEpsilon = 0.001;

/// A constraint which transaltes its constrained component in world space to a
/// certain distance from the [target] based on [mode].
class DistanceConstraint extends DistanceConstraintBase {
  @override
  void constrain(TransformComponent component) {
    if (target == null) {
      return;
    }
    var targetTranslation = target!.worldTranslation;
    var ourTranslation = component.worldTranslation;

    var toTarget = ourTranslation - targetTranslation;
    var currentDistance = toTarget.length();
    switch (mode) {
      case DistanceConstraintMode.closer:
        if (currentDistance < distance) {
          return;
        }
        break;
      case DistanceConstraintMode.further:
        if (currentDistance > distance) {
          return;
        }
        break;
      case DistanceConstraintMode.exact:
        break;
    }
    if (currentDistance < _distanceEpsilon) {
      return;
    }

    Vec2D.scale(toTarget, toTarget, 1.0 / currentDistance);
    Vec2D.scale(toTarget, toTarget, distance);

    var world = component.worldTransform;

    var position = targetTranslation + toTarget;
    Vec2D.lerp(position, ourTranslation, position, strength);
    world[4] = position.x;
    world[5] = position.y;
  }

  @override
  void distanceChanged(double from, double to) => markConstraintDirty();

  @override
  void modeValueChanged(int from, int to) => markConstraintDirty();

  DistanceConstraintMode get mode => DistanceConstraintMode.values[modeValue];
  set mode(DistanceConstraintMode value) => modeValue = value.index;
}
