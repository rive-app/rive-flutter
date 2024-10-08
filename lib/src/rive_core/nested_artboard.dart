import 'dart:math';
import 'dart:ui';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/nested_artboard_base.dart';
import 'package:rive/src/rive_core/animation/nested_remap_animation.dart';
import 'package:rive/src/rive_core/animation/nested_simple_animation.dart';
import 'package:rive/src/rive_core/animation/nested_state_machine.dart';
import 'package:rive/src/rive_core/backboard.dart';
import 'package:rive/src/rive_core/bounds_provider.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/data_bind/data_bind.dart';
import 'package:rive/src/rive_core/data_bind/data_context.dart';
import 'package:rive/src/rive_core/nested_animation.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance.dart';
import 'package:rive_common/math.dart';
import 'package:rive_common/utilities.dart';

export 'package:rive/src/generated/nested_artboard_base.dart';

enum NestedArtboardFitType {
  // ignore: lines_longer_than_80_chars
  fill, // Default value - scales to fill available view without maintaining aspect ratio
  contain,
  cover,
  fitWidth,
  fitHeight,
  resizeArtboard,
  none,
}

enum NestedArtboardAlignmentType {
  center, // Default value
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

/// Represents the nested Artboard that'll actually be mounted and placed into
/// the [NestedArtboard] component.
abstract class MountedArtboard {
  void draw(Canvas canvas);
  Mat2D get worldTransform;
  set worldTransform(Mat2D value);
  AABB get bounds;
  double get renderOpacity;
  set renderOpacity(double value);
  bool advance(double seconds, {bool nested});
  set artboardWidth(double width);
  double get artboardWidth;
  set artboardHeight(double height);
  double get artboardHeight;
  double get originalArtboardWidth;
  double get originalArtboardHeight;
  void artboardWidthOverride(double width, int widthUnitValue, bool isRow);
  void artboardHeightOverride(double height, int heightUnitValue, bool isRow);
  void artboardWidthIntrinsicallySizeOverride(bool intrinsic);
  void artboardHeightIntrinsicallySizeOverride(bool intrinsic);
  void dispose();
  void setDataContextFromInstance(ViewModelInstance viewModelInstance,
      DataContext? dataContextValue, bool isRoot);
  void internalDataContext(DataContext dataContextValue,
      DataContext? parentDataContext, bool isRoot);
  void populateDataBinds(List<DataBind> globalDataBinds);
}

class NestedArtboard extends NestedArtboardBase implements Sizable {
  /// [NestedAnimation]s applied to this [NestedArtboard].
  final List<NestedAnimation> _animations = [];
  Iterable<NestedAnimation> get animations => _animations;

  List<int> dataBindPath = [];

  NestedArtboardFitType get fitType => NestedArtboardFitType.values[fit];
  NestedArtboardAlignmentType get alignmentType =>
      NestedArtboardAlignmentType.values[alignment];

  bool get hasNestedStateMachine =>
      _animations.any((animation) => animation is NestedStateMachine);

  List<NestedStateMachine> get nestedStateMachines =>
      _animations.whereType<NestedStateMachine>().toList(growable: false);

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

    if (cachedSize != null) {
      controlSize(cachedSize!);
    }
  }

  @override
  void onRemoved() {
    super.onRemoved();
    _mountedArtboard?.dispose();
  }

  @override
  void artboardIdChanged(int from, int to) {}

  @override
  void dataBindPathIdsChanged(List<int> from, List<int> to) {}

  @override
  void fitChanged(int from, int to) {
    _updateMountedTransform();
  }

  @override
  void alignmentChanged(int from, int to) {
    _updateMountedTransform();
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    var reader = BinaryReader.fromList(dataBindPathIds);
    while (!reader.isEOF) {
      dataBindPath.add(reader.readVarUint());
    }
  }

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

  // When used with layouts, we cache the size of the NestedArtboard
  // because the mountedArtboard gets replaced when changes are made to the
  // NestedArtboard's artboard, and we need to maintain size when that happens
  Size? cachedSize;

  @override
  Size computeIntrinsicSize(Size min, Size max) {
    final bounds = mountedArtboard?.bounds;
    if (bounds == null) {
      return min;
    }
    return Size(bounds.width * scaleX, bounds.height * scaleY);
  }

  @override
  void controlSize(Size size) {
    cachedSize = size;
    if (mountedArtboard == null) {
      return;
    }
    // Since NestedArtboards only use scale, not width/height, we have to do
    // a bit of a conversion here. There may be a better way.

    scaleX = size.width / mountedArtboard!.originalArtboardWidth;
    scaleY = size.height / mountedArtboard!.originalArtboardHeight;

    updateTransform();
    updateWorldTransform();
  }

  void _updateMountedTransform() {
    var mountedArtboard = _mountedArtboard;
    if (mountedArtboard != null) {
      Mat2D transform = Mat2D();
      Mat2D.copy(transform, worldTransform);
      if (fitType == NestedArtboardFitType.resizeArtboard) {
        // resizeArtboard is a special case because we actually change the
        // width/height of the RuntimeArtboard rather than scaling it
        mountedArtboard.artboardWidth =
            scaleX * mountedArtboard.originalArtboardWidth;
        mountedArtboard.artboardHeight =
            scaleY * mountedArtboard.originalArtboardHeight;
        double computedScaleX = scaleX == 0 ? 0 : (1 / scaleX);
        double computedScaleY = scaleY == 0 ? 0 : (1 / scaleY);
        Mat2D.scaleByValues(transform, computedScaleX, computedScaleY);
      } else {
        // For all others we scale
        mountedArtboard.artboardWidth = mountedArtboard.originalArtboardWidth;
        mountedArtboard.artboardHeight = mountedArtboard.originalArtboardHeight;
        double? scaleMultiplier;
        switch (fitType) {
          case NestedArtboardFitType.cover:
            scaleMultiplier = max(scaleX, scaleY);
            break;
          case NestedArtboardFitType.contain:
            scaleMultiplier = min(scaleX, scaleY);
            break;
          case NestedArtboardFitType.fitWidth:
            scaleMultiplier = scaleX;
            break;
          case NestedArtboardFitType.fitHeight:
            scaleMultiplier = scaleY;
            break;
          case NestedArtboardFitType.none:
            scaleMultiplier = 1;
            break;
          default:
            break;
        }
        if (scaleMultiplier != null) {
          double computedScaleX =
              scaleX == 0 ? 0 : (1 / scaleX) * scaleMultiplier;
          double computedScaleY =
              scaleY == 0 ? 0 : (1 / scaleY) * scaleMultiplier;
          Mat2D.scaleByValues(transform, computedScaleX, computedScaleY);
          // Only do alignment if we are not using fit type Fill
          double translateX = 0;
          double translateY = 0;
          double artboardWidth = mountedArtboard.originalArtboardWidth;
          double artboardHeight = mountedArtboard.originalArtboardHeight;
          // Adjust x position if we're aligned center or right
          if (alignmentType == NestedArtboardAlignmentType.topCenter ||
              alignmentType == NestedArtboardAlignmentType.center ||
              alignmentType == NestedArtboardAlignmentType.bottomCenter) {
            translateX =
                (artboardWidth * scaleX - artboardWidth * scaleMultiplier) / 2;
          } else if (alignmentType == NestedArtboardAlignmentType.topRight ||
              alignmentType == NestedArtboardAlignmentType.centerRight ||
              alignmentType == NestedArtboardAlignmentType.bottomRight) {
            translateX =
                artboardWidth * scaleX - artboardWidth * scaleMultiplier;
          }
          // Adjust y position if we're aligned center or bottom
          if (alignmentType == NestedArtboardAlignmentType.centerLeft ||
              alignmentType == NestedArtboardAlignmentType.center ||
              alignmentType == NestedArtboardAlignmentType.centerRight) {
            translateY =
                (artboardHeight * scaleY - artboardHeight * scaleMultiplier) /
                    2;
          } else if (alignmentType == NestedArtboardAlignmentType.bottomLeft ||
              alignmentType == NestedArtboardAlignmentType.bottomCenter ||
              alignmentType == NestedArtboardAlignmentType.bottomRight) {
            translateY =
                artboardHeight * scaleY - artboardHeight * scaleMultiplier;
          }
          if (translateX != 0) {
            transform[4] += translateX;
          }
          if (translateY != 0) {
            transform[5] += translateY;
          }
        }
      }
      mountedArtboard.worldTransform = transform;
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
    if (mountedArtboard == null || isCollapsed) {
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
