import 'package:rive/src/rive_core/constraints/constraint.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/generated/constraints/translation_constraint_base.dart';
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
      translationB[0] = transformB[4];
      translationB[1] = transformB[5];

      if (!doesCopy) {
        translationB[0] =
            destSpace == TransformSpace.local ? 0 : translationA[0];
      } else {
        translationB[0] *= copyFactor;
        if (offset) {
          translationB[0] += component.x;
        }
      }

      if (!doesCopyY) {
        translationB[1] =
            destSpace == TransformSpace.local ? 0 : translationA[1];
      } else {
        translationB[1] *= copyFactorY;

        if (offset) {
          translationB[1] += component.y;
        }
      }

      if (destSpace == TransformSpace.local) {
        // Destination space is in parent transform coordinates.
        Vec2D.transformMat2D(
            translationB, translationB, parentWorld(component));
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
      Vec2D.transformMat2D(translationB, translationB, invert);
    }
    if (max && translationB[0] > maxValue) {
      translationB[0] = maxValue;
    }
    if (min && translationB[0] < minValue) {
      translationB[0] = minValue;
    }
    if (maxY && translationB[1] > maxValueY) {
      translationB[1] = maxValueY;
    }
    if (minY && translationB[1] < minValueY) {
      translationB[1] = minValueY;
    }
    if (clampLocal) {
      // Transform back to world.
      Vec2D.transformMat2D(translationB, translationB, parentWorld(component));
    }

    var ti = 1 - strength;

    // Just interpolate world translation
    transformA[4] = translationA[0] * ti + translationB[0] * strength;
    transformA[5] = translationA[1] * ti + translationB[1] * strength;
  }
}
