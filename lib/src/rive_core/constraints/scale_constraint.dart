import 'package:rive/src/generated/constraints/scale_constraint_base.dart';
import 'package:rive/src/rive_core/constraints/constraint.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/transform_components.dart';
import 'package:rive/src/rive_core/transform_component.dart';
import 'package:rive/src/rive_core/transform_space.dart';

export 'package:rive/src/generated/constraints/scale_constraint_base.dart';

/// A constraint copies the scale from the target component to the
/// constrained component in world or local space and applies copy/min/max
/// rules.
class ScaleConstraint extends ScaleConstraintBase {
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
        componentsB.scaleX =
            destSpace == TransformSpace.local ? 1 : componentsA.scaleX;
      } else {
        componentsB.scaleX = componentsB.scaleX * copyFactor;
        if (offset) {
          componentsB.scaleX = componentsB.scaleX * component.scaleX;
        }
      }

      if (!doesCopyY) {
        componentsB.scaleY =
            destSpace == TransformSpace.local ? 1 : componentsA.scaleY;
      } else {
        componentsB.scaleY = componentsB.scaleY * copyFactorY;
        if (offset) {
          componentsB.scaleY = componentsB.scaleY * component.scaleY;
        }
      }

      if (destSpace == TransformSpace.local) {
        // Destination space is in parent transform coordinates. Recompose the
        // parent local transform and get it in world, then decompose the world
        // for interpolation.

        Mat2D.compose(transformB, componentsB);
        Mat2D.multiply(transformB, parentWorld(component), transformB);
        Mat2D.decompose(transformB, componentsB);
      }
    }

    bool clamplocal = minMaxSpace == TransformSpace.local;
    if (clamplocal) {
      // Apply min max in local space, so transform to local coordinates first.
      Mat2D.compose(transformB, componentsB);
      var inverse = Mat2D();
      if (!Mat2D.invert(inverse, parentWorld(component))) {
        return;
      }
      Mat2D.multiply(transformB, inverse, transformB);
      Mat2D.decompose(transformB, componentsB);
    }
    if (max && componentsB.scaleX > maxValue) {
      componentsB.scaleX = maxValue;
    }
    if (min && componentsB.scaleX < minValue) {
      componentsB.scaleX = minValue;
    }
    if (maxY && componentsB.scaleY > maxValueY) {
      componentsB.scaleY = maxValueY;
    }
    if (minY && componentsB.scaleY < minValueY) {
      componentsB.scaleY = minValueY;
    }
    if (clamplocal) {
      // Transform back to world.
      Mat2D.compose(transformB, componentsB);
      Mat2D.multiply(transformB, parentWorld(component), transformB);
      Mat2D.decompose(transformB, componentsB);
    }

    var ti = 1 - strength;

    componentsB.rotation = componentsA.rotation;
    componentsB.x = componentsA.x;
    componentsB.y = componentsA.y;
    componentsB.scaleX =
        componentsA.scaleX * ti + componentsB.scaleX * strength;
    componentsB.scaleY =
        componentsA.scaleY * ti + componentsB.scaleY * strength;
    componentsB.skew = componentsA.skew;

    Mat2D.compose(component.worldTransform, componentsB);
  }
}
