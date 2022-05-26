import 'dart:ui';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/nested_artboard_base.dart';
import 'package:rive/src/rive_core/animation/nested_remap_animation.dart';
import 'package:rive/src/rive_core/animation/nested_simple_animation.dart';
import 'package:rive/src/rive_core/animation/nested_state_machine.dart';
import 'package:rive/src/rive_core/backboard.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/aabb.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/nested_animation.dart';

export 'package:rive/src/generated/nested_artboard_base.dart';

/// Represents the nested Artboard that'll actually be mounted and placed into
/// the [NestedArtboard] component.
abstract class MountedArtboard {
  void draw(Canvas canvas);
  Mat2D get worldTransform;
  set worldTransform(Mat2D value);
  AABB get bounds;
  double get renderOpacity;
  set renderOpacity(double value);
  bool advance(double seconds);
  void dispose();
}

class NestedArtboard extends NestedArtboardBase {
  /// [NestedAnimation]s applied to this [NestedArtboard].
  final List<NestedAnimation> _animations = [];
  Iterable<NestedAnimation> get animations => _animations;

  bool get hasNestedStateMachine =>
      _animations.any((animation) => animation is NestedStateMachine);

  /// Used by nested animations/state machines to let the nesting artboard know
  /// it needs to redraw/advance time.
  void markNeedsAdvance() => context.markNeedsAdvance();

  MountedArtboard? _mountedArtboard;
  MountedArtboard? get mountedArtboard => _mountedArtboard;
  set mountedArtboard(MountedArtboard? value) {
    if (value == _mountedArtboard) {
      return;
    }
    _mountedArtboard?.dispose();
    _mountedArtboard = value;
    _updateMountedTransform();
    _mountedArtboard?.renderOpacity = renderOpacity;
    _mountedArtboard?.advance(0);
    addDirt(ComponentDirt.paint);
  }

  @override
  void onRemoved() {
    super.onRemoved();
    _mountedArtboard?.dispose();
  }

  @override
  void artboardIdChanged(int from, int to) {}


  @override
  void childAdded(Component child) {
    super.childAdded(child);
    switch (child.coreType) {
      case NestedRemapAnimationBase.typeKey:
      case NestedSimpleAnimationBase.typeKey:
      case NestedStateMachineBase.typeKey:
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
      case NestedStateMachineBase.typeKey:
        _animations.remove(child as NestedAnimation);

        break;
    }
  }

  void _updateMountedTransform() {
    var mountedArtboard = _mountedArtboard;
    if (mountedArtboard != null) {
      mountedArtboard.worldTransform = worldTransform;
    }
  }

  /// Convert a world position to local for the mounted artboard.
  Vec2D? worldToLocal(Vec2D position) {
    var mounted = mountedArtboard;
    if (mounted == null) {
      return null;
    }
    var toMountedArtboard = Mat2D();
    if (!Mat2D.invert(toMountedArtboard, mounted.worldTransform)) {
      return null;
    }
    return Vec2D.transformMat2D(Vec2D(), position, toMountedArtboard);
  }

  @override
  void updateWorldTransform() {
    super.updateWorldTransform();
    _updateMountedTransform();
  }

  bool advance(double elapsedSeconds) {
    if (mountedArtboard == null) {
      return false;
    }

    bool keepGoing = false;
    for (final animation in _animations) {
      if (animation.isEnabled) {
        if (animation.advance(elapsedSeconds, mountedArtboard!)) {
          keepGoing = true;
        }
      }
    }
    if (mountedArtboard!.advance(elapsedSeconds)) {
      keepGoing = true;
    }
    return keepGoing;
  }

  @override
  void update(int dirt) {
    super.update(dirt);
    // RenderOpacity gets updated with the worldTransform (accumulates through
    // hierarchy), so if we see worldTransform is dirty, update our internal
    // render opacities.
    if (dirt & ComponentDirt.worldTransform != 0) {
      mountedArtboard?.renderOpacity = renderOpacity;
    }
  }

  @override
  void draw(Canvas canvas) {
    bool clipped = clip(canvas);
    mountedArtboard?.draw(canvas);

    if (clipped) {
      canvas.restore();
    }
  }

  @override
  bool import(ImportStack stack) {
    var backboardImporter =
        stack.latest<BackboardImporter>(BackboardBase.typeKey);
    if (backboardImporter != null) {
      backboardImporter.addNestedArtboard(this);
    }

    return super.import(stack);
  }
}
