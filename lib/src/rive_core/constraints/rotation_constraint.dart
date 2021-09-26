import 'dart:math';

import 'package:rive/src/generated/constraints/rotation_constraint_base.dart';
import 'package:rive/src/rive_core/constraints/constraint.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/transform_components.dart';
import 'package:rive/src/rive_core/transform_component.dart';
import 'package:rive/src/rive_core/transform_space.dart';

export 'package:rive/src/generated/constraints/rotation_constraint_base.dart';

/// A constraint copies the rotation from the target component to the
/// constrained component in world or local space and applies copy/min/max
/// rules.
class RotationConstraint extends RotationConstraintBase {
  @override
  void constrain(TransformComponent component) {
    var transformA = component.worldTransform;
    var transformB = Mat2D();
    Mat2D.decompose(transformA, componentsA);
    if (target == null) {
      Mat2D.copy(transformB, transformA);
      TransformComponents.copy(componentsB, componentsA);
    } else {
      Mat2D.copy(transformB, target!.worldTransform);
      if (sourceSpace == TransformSpace.local) {
        var inverse = Mat2D();

        if (!Mat2D.invert(inverse, parentWorld(target!))) {
          return;
        }
        Mat2D.multiply(transformB, inverse, transformB);
      }

      Mat2D.decompose(transformB, componentsB);

      if (!doesCopy) {
        componentsB.rotation =
            destSpace == TransformSpace.local ? 0 : componentsA.rotation;
      } else {
        componentsB.rotation = componentsB.rotation * copyFactor;
        if (offset) {
          componentsB.rotation = componentsB.rotation + component.rotation;
        }
      }

      if (destSpace == TransformSpace.local) {
        // Destination space is in parent transform coordinates. Recompose the
        // parent local transform and get it in world, then decompose the world
        // for interpolation.

        Mat2D.compose(transformB, componentsB);
        var grandParentWorld = parentWorld(component);
        Mat2D.multiply(transformB, grandParentWorld, transformB);
        Mat2D.decompose(transformB, componentsB);
      }
    }
    bool clampLocal = minMaxSpace == TransformSpace.local;
    if (clampLocal) {
      // Apply min max in local space, so transform to local coordinates first.
      Mat2D.compose(transformB, componentsB);
      Mat2D inverse = Mat2D();
      if (!Mat2D.invert(inverse, parentWorld(component))) {
        return;
      }
      Mat2D.multiply(transformB, inverse, transformB);
      Mat2D.decompose(transformB, componentsB);
    }
    if (this.max && componentsB.rotation > maxValue) {
      componentsB.rotation = maxValue;
    }
    if (this.min && componentsB.rotation < minValue) {
      componentsB.rotation = minValue;
    }
    if (clampLocal) {
      // Transform back to world.
      Mat2D.compose(transformB, componentsB);
      Mat2D.multiply(transformB, parentWorld(component), transformB);
      Mat2D.decompose(transformB, componentsB);
    }

    var pi2 = pi * 2;
    var angleA = componentsA.rotation % pi2;
    var angleB = componentsB.rotation % pi2;
    var diff = angleB - angleA;

    if (diff > pi) {
      diff -= pi2;
    } else if (diff < -pi) {
      diff += pi2;
    }

    componentsB.rotation = componentsA.rotation + diff * strength;
    componentsB.x = componentsA.x;
    componentsB.y = componentsA.y;
    componentsB.scaleX = componentsA.scaleX;
    componentsB.scaleY = componentsA.scaleY;
    componentsB.skew = componentsA.skew;

    Mat2D.compose(component.worldTransform, componentsB);
  }
}
