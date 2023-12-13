import 'dart:math';
import 'dart:ui' as ui;

import 'package:rive/src/generated/constraints/follow_path_constraint_base.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/constraints/constraint.dart';
import 'package:rive/src/rive_core/shapes/path.dart';
import 'package:rive/src/rive_core/shapes/shape.dart';
import 'package:rive/src/rive_core/transform_component.dart';
import 'package:rive/src/rive_core/transform_space.dart';
import 'package:rive_common/math.dart';

export 'package:rive/src/generated/constraints/follow_path_constraint_base.dart';

/// A constraint which transforms its constrained TransformComponent to the
/// targeted path.
class FollowPathConstraint extends FollowPathConstraintBase {
  final ui.Path _worldPath = ui.Path();

  Mat2D get targetTransform {
    if (target is Shape || target is Path) {
      var metrics = _worldPath.computeMetrics().toList(growable: false);
      if (metrics.isEmpty) {
        return Mat2D();
      }
      double totalLength = 0.0;
      for (final metric in metrics) {
        totalLength += metric.length;
      }
      // Normalize distance value to 0-1 since we need to support values
      // <0 and >1
      // Negative values follow path in reverse direction
      var actualDistance = distance % 1;
      // This handles the case where distance is any whole number other than 0.
      // In those cases we want actualDistance to return 1
      if (distance != 0 && actualDistance == 0) {
        actualDistance = 1;
      }
      double distanceUnits = totalLength * actualDistance.clamp(0, 1);
      var itr = metrics.iterator;

      // We already checked it wasn't empty.
      itr.moveNext();
      ui.PathMetric metric;
      do {
        metric = itr.current;
        if (distanceUnits <= metric.length) {
          break;
        }

        distanceUnits -= metric.length;
      } while (itr.moveNext());

      var tangent = metric.getTangentForOffset(distanceUnits);

      if (tangent == null) {
        return Mat2D();
      }

      Vec2D position =
          Vec2D.fromValues(tangent.position.dx, tangent.position.dy);
      Mat2D transformB = Mat2D.clone(target!.worldTransform);

      if (orient) {
        Mat2D.fromRotation(
            transformB, atan2(tangent.vector.dy, tangent.vector.dx));
      }
      final offsetPosition = offset
          ? Vec2D.fromValues(constrainedComponent!.transform[4],
              constrainedComponent!.transform[5])
          : Vec2D();
      transformB[4] = position.x + offsetPosition.x;
      transformB[5] = position.y + offsetPosition.y;
      return transformB;
    } else {
      return target!.worldTransform;
    }
  }

  @override
  void constrain(TransformComponent component) {
    if (target == null || target!.isCollapsed) {
      return;
    }
    // Constrained component world transform
    var transformA = component.worldTransform;
    // Target transform
    var transformB = Mat2D.clone(targetTransform);
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

    var t = strength;
    var ti = 1 - t;

    // If orient is on, use the rotation value we calculated when getting the
    // tanget of the path, otherwise respect constrained component's rotation
    if (!orient) {
      componentsB[4] = componentsA[4] % (pi * 2);
    }
    // Merge x/y position based on strength value
    componentsB[0] = componentsA[0] * ti + componentsB[0] * t;
    componentsB[1] = componentsA[1] * ti + componentsB[1] * t;
    // Maintain scale & skew of constrained component
    componentsB[2] = componentsA[2];
    componentsB[3] = componentsA[3];
    componentsB[5] = componentsA[5];

    Mat2D.compose(component.worldTransform, componentsB);
  }

  @override
  void buildDependencies() {
    if (target is Shape) {
      var shape = target as Shape;
      // Follow path should update after the target's path composer
      shape.pathComposer.addDependent(this);
    } else if (target is Path) {
      var path = target as Path;
      path.addDependent(this);
    }

    if (constrainedComponent != null) {
      // The constrained component should update after follow path
      addDependent(constrainedComponent!, via: this);
    }
  }

  void _resetWorldPath(Set<Path> paths) {
    _worldPath.reset();
    for (final path in paths) {
      _worldPath.addPath(path.uiPath, ui.Offset.zero,
          matrix4: path.pathTransform.mat4);
    }
  }

  @override
  void update(int dirt) {
    final _target = target;
    if (_target is Shape) {
      _resetWorldPath(_target.paths);
    } else if (_target is Path) {
      _resetWorldPath({_target});
    }
  }

  @override
  Component? get targetDependencyParent => target is Shape
      ? (target as Shape)
      : target is Path
          ? (target as Path)
          : null;

  @override
  void distanceChanged(double from, double to) => markConstraintDirty();

  @override
  void orientChanged(bool from, bool to) => markConstraintDirty();

  @override
  void offsetChanged(bool from, bool to) => markConstraintDirty();

  @override
  bool validate() =>
      super.validate() && (target == null || target is Shape || target is Path);
}
