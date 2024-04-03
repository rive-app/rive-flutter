import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:rive/src/generated/layout_component_base.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/bounds_provider.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/rive_core/layout/layout_component_style.dart';
import 'package:rive/src/rive_core/world_transform_component.dart';
import 'package:rive_common/layout_engine.dart';
import 'package:rive_common/math.dart';

export 'package:rive/src/generated/layout_component_base.dart';

class LayoutComponent extends LayoutComponentBase {
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

  void markLayoutNodeDirty() {
    _layoutNode.markDirty();
    artboard?.markLayoutDirty(this);
  }

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
    markLayoutNodeDirty();
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
    layoutStyle.flexGrow = style.flexGrow;
    layoutStyle.flexShrink = style.flexShrink;
    //layoutStyle.flexBasis = style.flexBasis;
    layoutStyle.flexDirection = style.flexDirection;
    layoutStyle.flexWrap = style.flexWrap;
    layoutStyle.alignItems = style.alignItems;
    layoutStyle.alignContent = style.alignContent;
    layoutStyle.alignSelf = style.alignSelf;
    layoutStyle.justifyContent = style.justifyContent;

    layoutNode.setStyle(layoutStyle);
  }

  void syncLayoutChildren() {
    final layoutChildren = children.whereType<LayoutComponent>();
    layoutNode.clearChildren();
    for (var i = 0; i < layoutChildren.length; i++) {
      layoutNode.insertChild(layoutChildren.elementAt(i).layoutNode, i);
    }
  }

  @override
  void onAdded() {
    super.onAdded();
    syncLayoutChildren();
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    style = context.resolve(styleId);
  }

  void createLayoutStyle() {
    var newStyle = LayoutComponentStyle();
    context.addObject(newStyle);
    style = newStyle;
  }

  void setupStyle(LayoutComponentStyle style) {
    appendChild(style);
    style.valueChanged.addListener(styleValueChanged);
  }

  Offset _layoutLocation = Offset.zero;
  Size _layoutSize = Size.zero;

  AABB get localBounds {
    return AABB.fromValues(
      0,
      0,
      _layoutSize.width,
      _layoutSize.height,
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
      if (child is LayoutComponent) {
        return false;
      }
      if (child is Sizable) {
        (child as Sizable).controlSize(_layoutSize);
      }
      return true;
    });
  }

  void updateLayoutBounds() {
    final layout = layoutNode.layout;
    if (_layoutLocation.dx != layout.left ||
        _layoutLocation.dy != layout.top ||
        _layoutSize.width != layout.width ||
        _layoutSize.height != layout.height) {
      _layoutLocation = Offset(layout.left, layout.top);
      _layoutSize = Size(layout.width, layout.height);
      propagateSize();
      markWorldTransformDirty();
    }
  }

  void styleValueChanged() {
    markLayoutNodeDirty();
  }

  void _removeLayoutNode() {
    var parent = this.parent;
    if (parent is LayoutComponent) {
      parent.markLayoutNodeDirty();
    }
  }

  @override
  void onRemoved() {
    _style?.valueChanged.removeListener(styleValueChanged);
    _removeLayoutNode();
    super.onRemoved();
  }

  @override
  void buildDependencies() {
    super.buildDependencies();
    parent?.addDependent(this);
  }

  @override
  String get defaultName => 'Layout Component';
}

Mat2D _computeAlignment(
    BoxFit fit, Alignment alignment, AABB frame, AABB content) {
  double contentWidth = content[2] - content[0];
  double contentHeight = content[3] - content[1];

  if (contentWidth == 0 || contentHeight == 0) {
    return Mat2D();
  }

  double x =
      -1 * content[0] - contentWidth / 2.0 - (alignment.x * contentWidth / 2.0);
  double y = -1 * content[1] -
      contentHeight / 2.0 -
      (alignment.y * contentHeight / 2.0);

  double scaleX = 1.0, scaleY = 1.0;

  switch (fit) {
    case BoxFit.fill:
      scaleX = frame.width / contentWidth;
      scaleY = frame.height / contentHeight;
      break;
    case BoxFit.contain:
      double minScale =
          min(frame.width / contentWidth, frame.height / contentHeight);
      scaleX = scaleY = minScale;
      break;
    case BoxFit.cover:
      double maxScale =
          max(frame.width / contentWidth, frame.height / contentHeight);
      scaleX = scaleY = maxScale;
      break;
    case BoxFit.fitHeight:
      double minScale = frame.height / contentHeight;
      scaleX = scaleY = minScale;
      break;
    case BoxFit.fitWidth:
      double minScale = frame.width / contentWidth;
      scaleX = scaleY = minScale;
      break;
    case BoxFit.none:
      scaleX = scaleY = 1.0;
      break;
    case BoxFit.scaleDown:
      double minScale =
          min(frame.width / contentWidth, frame.height / contentHeight);
      scaleX = scaleY = minScale < 1.0 ? minScale : 1.0;
      break;
  }

  Mat2D translation = Mat2D();

  translation[4] =
      frame[0] + frame.width / 2.0 + (alignment.x * frame.width / 2.0);
  translation[5] =
      frame[1] + frame.height / 2.0 + (alignment.y * frame.height / 2.0);

  return Mat2D.multiply(
      Mat2D(),
      Mat2D.multiply(Mat2D(), translation, Mat2D.fromScale(scaleX, scaleY)),
      Mat2D.fromTranslate(x, y));
}
