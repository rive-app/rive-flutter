import 'dart:ui';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/nested_artboard_base.dart';
import 'package:rive/src/rive_core/animation/nested_remap_animation.dart';
import 'package:rive/src/rive_core/animation/nested_simple_animation.dart';
import 'package:rive/src/rive_core/backboard.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/aabb.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/nested_animation.dart';

export 'package:rive/src/generated/nested_artboard_base.dart';

/// Represents the nested Artboard that'll actually be mounted and placed into
/// the [NestedArtboard] component.
abstract class MountedArtboard {
  void draw(Canvas canvas);
  Mat2D get worldTransform;
  set worldTransform(Mat2D value);
  AABB get bounds;
}

class NestedArtboard extends NestedArtboardBase {
  /// [NestedAnimation]s applied to this [NestedArtboard].
  final List<NestedAnimation> _animations = [];
  Iterable<NestedAnimation> get animations => _animations;

  MountedArtboard? _mountedArtboard;
  MountedArtboard? get mountedArtboard => _mountedArtboard;
  set mountedArtboard(MountedArtboard? value) {
    if (value == _mountedArtboard) {
      return;
    }
    _mountedArtboard = value;
    _mountedArtboard?.worldTransform = worldTransform;
    addDirt(ComponentDirt.paint);
  }

  @override
  void artboardIdChanged(int from, int to) {}


  @override
  void childAdded(Component child) {
    super.childAdded(child);
    switch (child.coreType) {
      case NestedRemapAnimationBase.typeKey:
      case NestedSimpleAnimationBase.typeKey:
        _animations.add(child as NestedAnimation);
        break;
    }
  }

  @override
  void childRemoved(Component child) {
    super.childRemoved(child);
    switch (child.coreType) {
      case NestedRemapAnimationBase.typeKey:
      case NestedSimpleAnimationBase.typeKey:
        _animations.remove(child as NestedAnimation);

        break;
    }
  }

  @override
  void updateWorldTransform() {
    super.updateWorldTransform();
    _mountedArtboard?.worldTransform = worldTransform;
  }

  void advance(double elapsedSeconds) {
    if (mountedArtboard == null) {
      return;
    }
    for (final animation in _animations) {
      if (animation.isEnabled) {
        animation.advance(elapsedSeconds, mountedArtboard!);
      }
    }
  }

  @override
  void draw(Canvas canvas) => mountedArtboard?.draw(canvas);

  @override
  bool import(ImportStack stack) {
    var backboardImporter =
        stack.latest<BackboardImporter>(BackboardBase.typeKey);
    if (backboardImporter == null) {
      return false;
    }
    backboardImporter.addNestedArtboard(this);

    return super.import(stack);
  }
}
