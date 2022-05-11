import 'package:rive/src/generated/constraints/translation_constraint_base.dart';
import 'package:rive/src/rive_core/constraints/constraint.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/transform_component.dart';
import 'package:rive/src/rive_core/transform_space.dart';

export 'package:rive/src/generated/constraints/translation_constraint_base.dart';

/// A constraint copies the translation from the target component to the
/// constrained component in world or local space and applies copy/min/max
/// rules.
class TranslationConstraint extends TranslationConstraintBase {
  @override
  void constrain(TransformComponent component) {
    var transformA = component.worldTransform;
    var translationA = Vec2D.fromValues(transformA[4], transformA[5]);
    var translationB = Vec2D();
    if (target == null) {
      Vec2D.copy(translationB, translationA);
    } else {
      var transformB = Mat2D.clone(target!.worldTransform);
      if (sourceSpace == TransformSpace.local) {
        var inverse = Mat2D();
        if (!Mat2D.invert(inverse, parentWorld(target!))) {
          return;
        }
        Mat2D.multiply(transformB, inverse, transformB);
      }
      translationB.x = transformB[4];
      translationB.y = transformB[5];

      if (!doesCopy) {
        translationB.x = destSpace == TransformSpace.local ? 0 : translationA.x;
      } else {
        translationB.x *= copyFactor;
        if (offset) {
          translationB.x += component.x;
        }
      }

      if (!doesCopyY) {
        translationB.y = destSpace == TransformSpace.local ? 0 : translationA.y;
      } else {
        translationB.y *= copyFactorY;

        if (offset) {
          translationB.y += component.y;
        }
      }

      if (destSpace == TransformSpace.local) {
        // Destination space is in parent transform coordinates.
        translationB.apply(parentWorld(component));
      }
    }

    bool clampLocal = minMaxSpace == TransformSpace.local;
    if (clampLocal) {
      // Apply min max in local space, so transform to local coordinates first.
      var invert = Mat2D();
      if (!Mat2D.invert(invert, parentWorld(component))) {
        return;
      }
      // Get our target world coordinates in parent local.
      translationB.apply(invert);
    }
    if (max && translationB.x > maxValue) {
      translationB.x = maxValue;
    }
    if (min && translationB.x < minValue) {
      translationB.x = minValue;
    }
    if (maxY && translationB.y > maxValueY) {
      translationB.y = maxValueY;
    }
    if (minY && translationB.y < minValueY) {
      translationB.y = minValueY;
    }
    if (clampLocal) {
      // Transform back to world.
      translationB.apply(parentWorld(component));
    }

    var ti = 1 - strength;

    // Just interpolate world translation
    transformA[4] = translationA.x * ti + translationB.x * strength;
    transformA[5] = translationA.y * ti + translationB.y * strength;
  }
}
