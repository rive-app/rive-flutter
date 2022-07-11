import 'package:flutter/foundation.dart';
import 'package:rive/src/generated/transform_component_base.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/constraints/constraint.dart';
import 'package:rive/src/rive_core/constraints/ik_constraint.dart';
import 'package:rive/src/rive_core/constraints/rotation_constraint.dart';
import 'package:rive/src/rive_core/constraints/scale_constraint.dart';
import 'package:rive/src/rive_core/constraints/transform_constraint.dart';
import 'package:rive/src/rive_core/constraints/translation_constraint.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/rive_core/draw_rules.dart';
import 'package:rive/src/rive_core/drawable.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/shapes/clipping_shape.dart';
import 'package:rive/src/rive_core/world_transform_component.dart';

import 'constraints/distance_constraint.dart';

export 'package:rive/src/generated/transform_component_base.dart';

abstract class TransformComponent extends TransformComponentBase {
  /// Draw rules saved against this transform component, inherited by children.
  DrawRules? _drawRules;

  DrawRules? get drawRules => _drawRules;

  final List<ClippingShape> _clippingShapes = [];
  Iterable<ClippingShape> get clippingShapes => _clippingShapes;

  /// Constraints applied to this TransformComponent.
  final List<Constraint> _constraints = [];
  Iterable<Constraint> get constraints => _constraints;

  bool get isConstrained {
    Component? component = this;
    while (component != null) {
      if (component is TransformComponent && component.constraints.isNotEmpty) {
        return true;
      }
      component = component.parent;
    }
    return false;
  }

  double _renderOpacity = 1;
  double get renderOpacity => _renderOpacity;

  final Mat2D transform = Mat2D();

  Vec2D get translation => Vec2D.fromValues(x, y);
  Vec2D get worldTranslation =>
      Vec2D.fromValues(worldTransform[4], worldTransform[5]);

  double get x;
  double get y;
  set x(double value);
  set y(double value);

  @override
  void update(int dirt) {
    if (dirt & ComponentDirt.transform != 0) {
      updateTransform();
    }
    if (dirt & ComponentDirt.worldTransform != 0) {
      updateWorldTransform();
    }
  }

  void updateTransform() {
    if (rotation != 0) {
      Mat2D.fromRotation(transform, rotation);
    } else {
      Mat2D.setIdentity(transform);
    }
    transform[4] = x;
    transform[5] = y;

    Mat2D.scaleByValues(transform, scaleX, scaleY);
  }

  // TODO: when we have layer effect renderers, this will need to render 1 for
  // layer effects.
  @override
  double get childOpacity => _renderOpacity;

  Vec2D get scale => Vec2D.fromValues(scaleX, scaleY);
  set scale(Vec2D value) {
    scaleX = value.x;
    scaleY = value.y;
  }

  @mustCallSuper
  void updateWorldTransform() {
    _renderOpacity = opacity;
    if (parent is WorldTransformComponent) {
      var parentNode = parent as WorldTransformComponent;
      _renderOpacity *= parentNode.childOpacity;
      Mat2D.multiply(worldTransform, parentNode.worldTransform, transform);
    } else {
      Mat2D.copy(worldTransform, transform);
    }

    if (_constraints.isNotEmpty) {
      for (final constraint in _constraints) {
        constraint.constrain(this);
      }
    }
  }

  void calculateWorldTransform() {
    var parent = this.parent;
    final chain = <TransformComponent>[this];

    while (parent != null) {
      if (parent is TransformComponent) {
        chain.insert(0, parent);
      }
      parent = parent.parent;
    }
    for (final item in chain) {
      item.updateTransform();
      item.updateWorldTransform();
    }
  }

  @override
  void buildDependencies() {
    super.buildDependencies();
    parent?.addDependent(this);
  }

  void markTransformDirty() {
    if (!addDirt(ComponentDirt.transform)) {
      return;
    }
    markWorldTransformDirty();
  }

  @override
  void rotationChanged(double from, double to) {
    markTransformDirty();
  }

  @override
  void scaleXChanged(double from, double to) {
    markTransformDirty();
  }

  @override
  void scaleYChanged(double from, double to) {
    markTransformDirty();
  }

  @override
  void opacityChanged(double from, double to) {
    // Intentionally doesn't call super as this will call
    // markWorldTransformDirty if necessary.
    markTransformDirty();
  }

  @override
  void parentChanged(ContainerComponent? from, ContainerComponent? to) {
    super.parentChanged(from, to);
    markWorldTransformDirty();
  }

  @override
  void childAdded(Component child) {
    super.childAdded(child);
    switch (child.coreType) {
      case DrawRulesBase.typeKey:
        _drawRules = child as DrawRules;

        break;
      case ClippingShapeBase.typeKey:
        _clippingShapes.add(child as ClippingShape);
        addDirt(ComponentDirt.clip, recurse: true);

        break;
      case TransformConstraintBase.typeKey:
      case IKConstraintBase.typeKey:
      case DistanceConstraintBase.typeKey:
      case TranslationConstraintBase.typeKey:
      case RotationConstraintBase.typeKey:
      case ScaleConstraintBase.typeKey:
        _constraints.add(child as Constraint);
        break;
    }
  }

  @override
  void childRemoved(Component child) {
    super.childRemoved(child);
    switch (child.coreType) {
      case DrawRulesBase.typeKey:
        if (_drawRules == child as DrawRules) {
          _drawRules = null;
        }
        break;
      case ClippingShapeBase.typeKey:
        if (_clippingShapes.isNotEmpty) {
          _clippingShapes.remove(child as ClippingShape);
          addDirt(ComponentDirt.clip, recurse: true);
        }
        break;
      case TransformConstraintBase.typeKey:
      case IKConstraintBase.typeKey:
      case DistanceConstraintBase.typeKey:
      case TranslationConstraintBase.typeKey:
      case RotationConstraintBase.typeKey:
      case ScaleConstraintBase.typeKey:
        _constraints.remove(child as Constraint);

        break;
    }
  }

  @override
  void buildDrawOrder(
      List<Drawable> drawables, DrawRules? rules, List<DrawRules> allRules) {
    if (drawRules != null) {
      // ignore: parameter_assignments
      rules = drawRules!;
      allRules.add(rules);
    }
    super.buildDrawOrder(drawables, rules, allRules);
  }
}
