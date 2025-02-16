import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:rive/src/generated/layout_component_base.dart';
import 'package:rive/src/rive_core/animation/keyframe_interpolator.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/bounds_provider.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/rive_core/layout/layout_component_style.dart';
import 'package:rive/src/rive_core/node.dart';
import 'package:rive/src/rive_core/shapes/paint/shape_paint_mutator.dart';
import 'package:rive/src/rive_core/shapes/shape_paint_container.dart';
import 'package:rive/src/rive_core/world_transform_component.dart';
import 'package:rive_common/layout_engine.dart';
import 'package:rive_common/math.dart';

export 'package:rive/src/generated/layout_component_base.dart';

extension ComponentExtension on Component {
  LayoutComponent? get layoutParent {
    var p = parent;
    while (p != null) {
      if (p is LayoutComponent) {
        return p;
      }
      p = p.parent;
    }
    return artboard;
  }
}

class LayoutAnimationData {
  double elapsedSeconds = 0;
  AABB fromBounds;
  AABB toBounds;
  LayoutAnimationData(this.fromBounds, this.toBounds);
}

class LayoutComponent extends LayoutComponentBase with ShapePaintContainer {
  bool _forceUpdateLayoutBounds = false;

  LayoutComponentStyle? _style;
  LayoutComponentStyle? get style => _style;
  set style(LayoutComponentStyle? style) {
    _style = style;
    styleId = style?.id ?? Core.missingId;
    if (style != null) {
      setupStyle(style);
    }
  }

  // Layout Engine provides these
  final LayoutStyle _layoutStyle = LayoutStyle.make();
  LayoutStyle get layoutStyle => _layoutStyle;
  final LayoutNode _layoutNode = LayoutNode.make();
  LayoutNode get layoutNode => _layoutNode;

  LayoutAnimationData animationData = LayoutAnimationData(AABB(), AABB());

  KeyFrameInterpolator? _inheritedInterpolator;
  LayoutStyleInterpolation? _inheritedInterpolation;
  double _inheritedInterpolationTime = 0;

  LayoutAnimationStyle get animationStyle =>
      style?.animationStyle ?? LayoutAnimationStyle.none;

  KeyFrameInterpolator? get interpolator {
    switch (style?.animationStyle) {
      case LayoutAnimationStyle.inherit:
        return _inheritedInterpolator ?? style?.interpolator;
      case LayoutAnimationStyle.custom:
        return style?.interpolator;
      default:
        return null;
    }
  }

  LayoutStyleInterpolation get interpolation {
    var defaultStyle = LayoutStyleInterpolation.hold;
    switch (style?.animationStyle) {
      case LayoutAnimationStyle.inherit:
        return _inheritedInterpolation ?? style?.interpolation ?? defaultStyle;
      case LayoutAnimationStyle.custom:
        return style?.interpolation ?? defaultStyle;
      default:
        return defaultStyle;
    }
  }

  double get interpolationTime {
    switch (style?.animationStyle) {
      case LayoutAnimationStyle.inherit:
        return _inheritedInterpolationTime;
      case LayoutAnimationStyle.custom:
        return style?.interpolationTime ?? 0;
      default:
        return 0;
    }
  }

  void cascadeAnimationStyle(
      LayoutStyleInterpolation inheritedInterpolation,
      KeyFrameInterpolator? inheritedInterpolator,
      double inheritedInterpolationTime) {
    if (style?.animationStyle == LayoutAnimationStyle.inherit) {
      setInheritedInterpolation(inheritedInterpolation, inheritedInterpolator,
          inheritedInterpolationTime);
    } else {
      clearInheritedInterpolation();
    }
    forEachChild((child) {
      if (child is LayoutComponent) {
        child.cascadeAnimationStyle(
            interpolation, interpolator, interpolationTime);
      }
      return false;
    });
  }

  // Parent layout component can push their interpolation into the child layout
  // which may be more performant than having the child look up the tree
  void setInheritedInterpolation(LayoutStyleInterpolation interpolation,
      KeyFrameInterpolator? interpolator, double interpolationTime) {
    _inheritedInterpolation = interpolation;
    _inheritedInterpolator = interpolator;
    _inheritedInterpolationTime = interpolationTime;
  }

  void clearInheritedInterpolation() {
    _inheritedInterpolation = null;
    _inheritedInterpolator = null;
    _inheritedInterpolationTime = 0;
  }

  bool get animates {
    return style?.positionType == LayoutPosition.relative &&
        style?.animationStyle != LayoutAnimationStyle.none &&
        interpolation != LayoutStyleInterpolation.hold &&
        interpolationTime > 0;
  }

  @override
  void onPaintMutatorChanged(ShapePaintMutator mutator) {
    // The transform affects stroke property may have changed as we have a new
    // mutator.
    paintChanged();
  }

  @override
  void onStrokesChanged() => paintChanged();

  @override
  void onFillsChanged() => paintChanged();

  void paintChanged() {
    addDirt(ComponentDirt.path);

    // Add world transform dirt to the direct dependents (don't recurse) as
    // things like ClippingShape directly depend on their referenced Shape. This
    // allows them to recompute any stored values which can change when the
    // transformAffectsStroke property changes (whether the path is in world
    // space or not). Consider using a different dirt type if this pattern is
    // repeated.
    for (final d in dependents) {
      d.addDirt(ComponentDirt.worldTransform);
    }
  }

  void markLayoutNodeDirty() {
    _layoutNode.markDirty();
    artboard?.markLayoutDirty(this);
  }

  void markLayoutStyleDirty() {
    clearInheritedInterpolation();
    addDirt(ComponentDirt.layoutStyle);
    if (this != artboard) {
      artboard?.markLayoutStyleDirty();
    }
  }

  @override
  bool isValidParent(Component parent) => parent is LayoutComponent;

  @override
  void changeArtboard(Artboard? value) {
    super.changeArtboard(value);
    artboard?.markLayoutDirty(this);
    if (parent is LayoutComponent) {
      (parent as LayoutComponent).syncLayoutChildren();
    }
  }

  @override
  void clipChanged(bool from, bool to) => markLayoutNodeDirty();

  @override
  void heightChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void widthChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void styleIdChanged(int from, int to) {
    style = context.resolve(to);
    markLayoutStyleDirty();
    markLayoutNodeDirty();
  }

  bool advance(double elapsedSeconds) {
    return _applyInterpolation(elapsedSeconds);
  }

  bool _applyInterpolation(double elapsedSeconds) {
    if (!animates || style == null || animationData.toBounds == layoutBounds) {
      return false;
    }
    if (animationData.elapsedSeconds >= interpolationTime) {
      _layoutLocation =
          Offset(animationData.toBounds.left, animationData.toBounds.top);
      _layoutSize =
          Size(animationData.toBounds.width, animationData.toBounds.height);
      animationData.elapsedSeconds = 0;
      markWorldTransformDirty();
      return false;
    }
    double f = 1;
    if (interpolationTime > 0) {
      f = animationData.elapsedSeconds / interpolationTime;
    }

    bool needsAdvance = false;
    var left = _layoutLocation.dx;
    var top = _layoutLocation.dy;
    var width = _layoutSize.width;
    var height = _layoutSize.height;
    if (animationData.toBounds.left != left ||
        animationData.toBounds.top != top) {
      if (interpolation == LayoutStyleInterpolation.linear) {
        left = animationData.fromBounds.left +
            f * (animationData.toBounds.left - animationData.fromBounds.left);
        top = animationData.fromBounds.top +
            f * (animationData.toBounds.top - animationData.fromBounds.top);
      } else {
        if (interpolator != null) {
          left = interpolator!.transformValue(
              animationData.fromBounds.left, animationData.toBounds.left, f);
          top = interpolator!.transformValue(
              animationData.fromBounds.top, animationData.toBounds.top, f);
        }
      }
      needsAdvance = true;
      _layoutLocation = Offset(left, top);
      markWorldTransformDirty();
    }
    if (animationData.toBounds.width != width ||
        animationData.toBounds.height != height) {
      if (interpolation == LayoutStyleInterpolation.linear) {
        width = animationData.fromBounds.width +
            f * (animationData.toBounds.width - animationData.fromBounds.width);
        height = animationData.fromBounds.height +
            f *
                (animationData.toBounds.height -
                    animationData.fromBounds.height);
      } else {
        if (interpolator != null) {
          width = interpolator!.transformValue(
              animationData.fromBounds.width, animationData.toBounds.width, f);
          height = interpolator!.transformValue(animationData.fromBounds.height,
              animationData.toBounds.height, f);
        }
      }
      needsAdvance = true;
      _layoutSize = Size(width, height);
      markWorldTransformDirty();
    }

    animationData.elapsedSeconds += elapsedSeconds;
    if (needsAdvance) {
      markLayoutNodeDirty();
    }
    return needsAdvance;
  }

  @override
  void update(int dirt) {
    if (dirt & ComponentDirt.worldTransform != 0) {
      Mat2D parentWorld = parent is WorldTransformComponent
          ? (parent as WorldTransformComponent).worldTransform
          : Mat2D();

      var transform = Mat2D();
      transform[4] = _layoutLocation.dx;
      transform[5] = _layoutLocation.dy;

      Mat2D.multiply(worldTransform, parentWorld, transform);
    }
  }

  void syncStyle() {
    if (_style == null) {
      return;
    }
    _syncStyle(_style!);
  }

  void _syncStyle(LayoutComponentStyle style) {
    bool setIntrinsicWidth = false;
    bool setIntrinsicHeight = false;
    if (style.intrinsicallySized &&
        (style.widthUnits == LayoutUnit.auto ||
            style.heightUnits == LayoutUnit.auto)) {
      bool foundIntrinsicSize = false;
      Size intrinsicSize = Size.zero;
      forEachChild((child) {
        if (child is LayoutComponent) {
          return false;
        }
        if (child is Sizable) {
          var minSize = Size(
            style.minWidthUnits == LayoutUnit.point ? style.minWidth : 0,
            style.minHeightUnits == LayoutUnit.point ? style.minHeight : 0,
          );
          var maxSize = Size(
            style.maxWidthUnits == LayoutUnit.point
                ? style.maxWidth
                : double.infinity,
            style.maxHeightUnits == LayoutUnit.point
                ? style.maxHeight
                : double.infinity,
          );

          var size = (child as Sizable).computeIntrinsicSize(minSize, maxSize);
          intrinsicSize = Size(max(intrinsicSize.width, size.width),
              max(intrinsicSize.height, size.height));
          foundIntrinsicSize = true;
        }
        return true;
      });
      if (foundIntrinsicSize) {
        if (style.widthUnits == LayoutUnit.auto) {
          setIntrinsicWidth = true;
          layoutStyle.setDimension(LayoutDimension.width,
              LayoutValue(unit: LayoutUnit.point, value: intrinsicSize.width));
        }
        if (style.heightUnits == LayoutUnit.auto) {
          setIntrinsicHeight = true;
          layoutStyle.setDimension(LayoutDimension.height,
              LayoutValue(unit: LayoutUnit.point, value: intrinsicSize.height));
        }
      }
    }
    if (!setIntrinsicWidth) {
      layoutStyle.setDimension(LayoutDimension.width,
          LayoutValue(unit: style.widthUnits, value: width));
    }
    if (!setIntrinsicHeight) {
      layoutStyle.setDimension(LayoutDimension.height,
          LayoutValue(unit: style.heightUnits, value: height));
    }

    final isRow = [
      LayoutFlexDirection.row,
      LayoutFlexDirection.rowReverse,
    ].contains(layoutParent?.style?.flexDirection);
    switch (style.widthScaleType) {
      case ScaleType.fixed:
        if (isRow) {
          layoutStyle.flexGrow = 0;
        }
        break;
      case ScaleType.fill:
        isRow
            ? layoutStyle.flexGrow = 1
            : layoutStyle.alignSelf = LayoutAlign.stretch;
        break;
      case ScaleType.hug:
        isRow
            ? layoutStyle.flexGrow = 0
            : layoutStyle.alignSelf = LayoutAlign.auto;
        break;
      default:
        break;
    }
    final isColumn = [
      LayoutFlexDirection.column,
      LayoutFlexDirection.columnReverse,
    ].contains(layoutParent?.style?.flexDirection);
    switch (style.heightScaleType) {
      case ScaleType.fixed:
        if (isColumn) {
          layoutStyle.flexGrow = 0;
        }
        break;
      case ScaleType.fill:
        isColumn
            ? layoutStyle.flexGrow = 1
            : layoutStyle.alignSelf = LayoutAlign.stretch;
        break;
      case ScaleType.hug:
        isColumn
            ? layoutStyle.flexGrow = 0
            : layoutStyle.alignSelf = LayoutAlign.auto;
        break;
      default:
        break;
    }

    final isRowForAlignment = [
      LayoutFlexDirection.row,
      LayoutFlexDirection.rowReverse,
    ].contains(style.flexDirection);
    switch (style.alignmentType) {
      case LayoutAlignmentType.topLeft:
      case LayoutAlignmentType.topCenter:
      case LayoutAlignmentType.topRight:
      case LayoutAlignmentType.spaceBetweenStart:
        if (isRowForAlignment) {
          layoutStyle.alignItems = LayoutAlign.flexStart;
        } else {
          layoutStyle.justifyContent = LayoutJustify.flexStart;
        }
        break;
      case LayoutAlignmentType.centerLeft:
      case LayoutAlignmentType.center:
      case LayoutAlignmentType.centerRight:
      case LayoutAlignmentType.spaceBetweenCenter:
        if (isRowForAlignment) {
          layoutStyle.alignItems = LayoutAlign.center;
        } else {
          layoutStyle.justifyContent = LayoutJustify.center;
        }
        break;
      case LayoutAlignmentType.bottomLeft:
      case LayoutAlignmentType.bottomCenter:
      case LayoutAlignmentType.bottomRight:
      case LayoutAlignmentType.spaceBetweenEnd:
        if (isRowForAlignment) {
          layoutStyle.alignItems = LayoutAlign.flexEnd;
        } else {
          layoutStyle.justifyContent = LayoutJustify.flexEnd;
        }
        break;
    }
    switch (style.alignmentType) {
      case LayoutAlignmentType.topLeft:
      case LayoutAlignmentType.centerLeft:
      case LayoutAlignmentType.bottomLeft:
        if (isRowForAlignment) {
          layoutStyle.justifyContent = LayoutJustify.flexStart;
        } else {
          layoutStyle.alignItems = LayoutAlign.flexStart;
        }
        break;
      case LayoutAlignmentType.topCenter:
      case LayoutAlignmentType.center:
      case LayoutAlignmentType.bottomCenter:
        if (isRowForAlignment) {
          layoutStyle.justifyContent = LayoutJustify.center;
        } else {
          layoutStyle.alignItems = LayoutAlign.center;
        }
        break;
      case LayoutAlignmentType.topRight:
      case LayoutAlignmentType.centerRight:
      case LayoutAlignmentType.bottomRight:
        if (isRowForAlignment) {
          layoutStyle.justifyContent = LayoutJustify.flexEnd;
        } else {
          layoutStyle.alignItems = LayoutAlign.flexEnd;
        }
        break;
      case LayoutAlignmentType.spaceBetweenStart:
      case LayoutAlignmentType.spaceBetweenCenter:
      case LayoutAlignmentType.spaceBetweenEnd:
        layoutStyle.justifyContent = LayoutJustify.spaceBetween;
        break;
    }

    layoutStyle.setMinDimension(LayoutDimension.width,
        LayoutValue(unit: style.minWidthUnits, value: style.minWidth));
    layoutStyle.setMinDimension(LayoutDimension.height,
        LayoutValue(unit: style.minHeightUnits, value: style.minHeight));
    layoutStyle.setMaxDimension(LayoutDimension.width,
        LayoutValue(unit: style.maxWidthUnits, value: style.maxWidth));
    layoutStyle.setMaxDimension(LayoutDimension.height,
        LayoutValue(unit: style.maxHeightUnits, value: style.maxHeight));

    layoutStyle.setGap(
        LayoutGutter.column,
        LayoutValue(
            unit: style.gapHorizontalUnits, value: style.gapHorizontal));
    layoutStyle.setGap(LayoutGutter.row,
        LayoutValue(unit: style.gapVerticalUnits, value: style.gapVertical));

    layoutStyle.setBorder(LayoutEdge.left,
        LayoutValue(unit: style.borderLeftUnits, value: style.borderLeft));
    layoutStyle.setBorder(LayoutEdge.top,
        LayoutValue(unit: style.borderTopUnits, value: style.borderTop));
    layoutStyle.setBorder(LayoutEdge.right,
        LayoutValue(unit: style.borderRightUnits, value: style.borderRight));
    layoutStyle.setBorder(LayoutEdge.bottom,
        LayoutValue(unit: style.borderBottomUnits, value: style.borderBottom));

    layoutStyle.setMargin(LayoutEdge.left,
        LayoutValue(unit: style.marginLeftUnits, value: style.marginLeft));
    layoutStyle.setMargin(LayoutEdge.top,
        LayoutValue(unit: style.marginTopUnits, value: style.marginTop));
    layoutStyle.setMargin(LayoutEdge.right,
        LayoutValue(unit: style.marginRightUnits, value: style.marginRight));
    layoutStyle.setMargin(LayoutEdge.bottom,
        LayoutValue(unit: style.marginBottomUnits, value: style.marginBottom));

    layoutStyle.setPadding(LayoutEdge.left,
        LayoutValue(unit: style.paddingLeftUnits, value: style.paddingLeft));
    layoutStyle.setPadding(LayoutEdge.top,
        LayoutValue(unit: style.paddingTopUnits, value: style.paddingTop));
    layoutStyle.setPadding(LayoutEdge.right,
        LayoutValue(unit: style.paddingRightUnits, value: style.paddingRight));
    layoutStyle.setPadding(
        LayoutEdge.bottom,
        LayoutValue(
            unit: style.paddingBottomUnits, value: style.paddingBottom));

    layoutStyle.setPosition(LayoutEdge.left,
        LayoutValue(unit: style.positionLeftUnits, value: style.positionLeft));
    layoutStyle.setPosition(LayoutEdge.top,
        LayoutValue(unit: style.positionTopUnits, value: style.positionTop));
    layoutStyle.setPosition(
        LayoutEdge.right,
        LayoutValue(
            unit: style.positionRightUnits, value: style.positionRight));
    layoutStyle.setPosition(
        LayoutEdge.bottom,
        LayoutValue(
            unit: style.positionBottomUnits, value: style.positionBottom));

    layoutStyle.display = style.display;
    layoutStyle.positionType = style.positionType;
    layoutStyle.flex = style.flex;
    //layoutStyle.flexGrow = style.flexGrow;
    //layoutStyle.flexShrink = style.flexShrink;
    //layoutStyle.flexBasis = style.flexBasis;
    layoutStyle.flexDirection = style.flexDirection;
    layoutStyle.flexWrap = style.flexWrap;
    //layoutStyle.alignItems = style.alignItems;
    //layoutStyle.alignContent = style.alignContent;
    //layoutStyle.alignSelf = style.alignSelf;
    //layoutStyle.justifyContent = style.justifyContent;

    layoutNode.setStyle(layoutStyle);
  }

  void syncLayoutChildren() {
    final layoutChildren = children.whereType<LayoutComponent>().toList();
    layoutNode.clearChildren();
    final length = layoutChildren.length;
    for (var i = 0; i < length; i++) {
      layoutNode.insertChild(layoutChildren[i].layoutNode, i);
    }
  }

  @override
  void onAdded() {
    super.onAdded();
    markLayoutStyleDirty();
    markLayoutNodeDirty();
    syncLayoutChildren();
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    markLayoutStyleDirty();
    markLayoutNodeDirty();
    style = context.resolve(styleId);
  }

  void setupStyle(LayoutComponentStyle style) {
    appendChild(style);
    style.valueChanged.addListener(styleValueChanged);
    style.interpolationChanged.addListener(styleInterpolationChanged);
  }

  Offset _layoutLocation = Offset.zero;
  Size _layoutSize = Size.zero;

  bool hasLayoutMeasurements() {
    return _layoutLocation != Offset.zero || _layoutSize != Size.zero;
  }

  AABB get localBounds {
    return AABB.fromValues(
      0,
      0,
      _layoutSize.width,
      _layoutSize.height,
    );
  }

  AABB get layoutBounds {
    return AABB.fromValues(
      _layoutLocation.dx,
      _layoutLocation.dy,
      _layoutLocation.dx + _layoutSize.width,
      _layoutLocation.dy + _layoutSize.height,
    );
  }

  AABB get worldBounds {
    return AABB.fromValues(
      worldTransform[4],
      worldTransform[5],
      worldTransform[4] + _layoutSize.width,
      worldTransform[5] + _layoutSize.height,
    );
  }

  @override
  AABB get constraintBounds => localBounds;

  void propagateSize() {
    // add option for this.
    if (artboard == this) {
      return;
    }
    forEachChild((child) {
      // Don't propagate down to children of nested layout components
      // or groups
      if (child is LayoutComponent || child.coreType == NodeBase.typeKey) {
        return false;
      }
      if (child is Sizable) {
        (child as Sizable).controlSize(animates && _layoutSize == Size.zero
            ? Size(animationData.toBounds.width, animationData.toBounds.height)
            : _layoutSize);
      }
      return true;
    });
  }

  void updateLayoutBounds() {
    final newLayoutBounds = AABB.fromValues(
        layoutNode.layout.left,
        layoutNode.layout.top,
        layoutNode.layout.left + layoutNode.layout.width,
        layoutNode.layout.top + layoutNode.layout.height);
    if (animates) {
      if (!AABB.areEqual(animationData.toBounds, newLayoutBounds) ||
          _forceUpdateLayoutBounds) {
        // This is where we want to set the start/end data for the animation
        // As we advance the animation, update _layoutLocation and _layoutSize
        animationData.fromBounds = layoutBounds;
        animationData.toBounds = newLayoutBounds;
        propagateSize();
        markWorldTransformDirty();
      }
    } else if (!AABB.areEqual(layoutBounds, newLayoutBounds) ||
        _forceUpdateLayoutBounds) {
      _layoutLocation = Offset(newLayoutBounds.left, newLayoutBounds.top);
      _layoutSize = Size(newLayoutBounds.width, newLayoutBounds.height);
      propagateSize();
      markWorldTransformDirty();
    }
    _forceUpdateLayoutBounds = false;
  }

  void styleValueChanged() {
    markLayoutNodeDirty();
  }

  // Only changes to layout animation styles mark style dirty
  // In the future we may want other styles to cascade down to child layouts
  void styleInterpolationChanged() {
    markLayoutStyleDirty();
  }

  void _removeLayoutNode() {
    markLayoutStyleDirty();
    var parent = this.parent;
    if (parent is LayoutComponent) {
      parent.markLayoutNodeDirty();
    }
  }

  @override
  void onRemoved() {
    _style?.valueChanged.removeListener(styleValueChanged);
    _style?.interpolationChanged.removeListener(styleInterpolationChanged);
    _removeLayoutNode();
    super.onRemoved();
  }

  @override
  void buildDependencies() {
    super.buildDependencies();
    parent?.addDependent(this);
  }
}
