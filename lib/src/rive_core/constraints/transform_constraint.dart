import 'dart:math';

import 'package:rive/src/generated/constraints/transform_constraint_base.dart';
import 'package:rive/src/rive_core/constraints/constraint.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/transform_component.dart';
import 'package:rive/src/rive_core/transform_space.dart';

export 'package:rive/src/generated/constraints/transform_constraint_base.dart';

/// A constraint copies the transform from the target component to the
/// constrained component in world or local space.
class TransformConstraint extends TransformConstraintBase {
  @override
  void constrain(TransformComponent component) {
    if (target == null) {
      return;
    }
    var transformA = component.worldTransform;
    var transformB = Mat2D.clone(target!.worldTransform);
    if (sourceSpace == TransformSpace.local) {
      var targetParentWorld = parentWorld(target!);

      var inverse = Mat2D();
      if (!Mat2D.invert(inverse, targetParentWorld)) {
        return;
      }
      Mat2D.multiply(transformB, inverse, transformB);
    }
    if (destSpace == TransformSpace.local && component.parent != null) {
      var targetParentWorld = parentWorld(component);
      Mat2D.multiply(transformB, targetParentWorld, transformB);
    }

    Mat2D.decompose(transformA, componentsA);
    Mat2D.decompose(transformB, componentsB);

    var angleA = componentsA[4] % (pi * 2);
    var angleB = componentsB[4] % (pi * 2);
    var diff = angleB - angleA;
    if (diff > pi) {
      diff -= pi * 2;
    } else if (diff < -pi) {
      diff += pi * 2;
    }

    var t = strength;
    var ti = 1 - t;

    componentsB[4] = angleA + diff * t;
    componentsB[0] = componentsA[0] * ti + componentsB[0] * t;
    componentsB[1] = componentsA[1] * ti + componentsB[1] * t;
    componentsB[2] = componentsA[2] * ti + componentsB[2] * t;
    componentsB[3] = componentsA[3] * ti + componentsB[3] * t;
    componentsB[5] = componentsA[5] * ti + componentsB[5] * t;

    Mat2D.compose(component.worldTransform, componentsB);
  }
}
