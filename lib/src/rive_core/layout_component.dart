import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart';
import 'package:rive/src/generated/layout_component_base.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/bounds_provider.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/layout/grid_track_sizing_group.dart';
import 'package:rive/src/rive_core/layout/track_sizing_function.dart';
import 'package:rive/src/rive_core/world_transform_component.dart';
import 'package:rive_common/math.dart';
import 'package:rive_common/rive_taffy.dart';

export 'package:rive/src/generated/layout_component_base.dart';

class LayoutComponent extends LayoutComponentBase {
  // ---- Flags 0
  static const BitFieldLoc displayBits = BitFieldLoc(0, 1);
  static const BitFieldLoc positionBits = BitFieldLoc(2, 2);

  static const BitFieldLoc flexDirectionBits = BitFieldLoc(3, 4);
  static const BitFieldLoc gapWidthTypeBits = BitFieldLoc(5, 5);
  static const BitFieldLoc gapHeightTypeBits = BitFieldLoc(6, 6);
  static const BitFieldLoc widthTypeBits = BitFieldLoc(7, 8);
  static const BitFieldLoc heightTypeBits = BitFieldLoc(9, 10);
  static const BitFieldLoc maxWidthTypeBits = BitFieldLoc(11, 12);
  static const BitFieldLoc maxHeightTypeBits = BitFieldLoc(13, 14);
  static const BitFieldLoc minWidthTypeBits = BitFieldLoc(15, 16);
  static const BitFieldLoc minHeightTypeBits = BitFieldLoc(17, 18);

  static const BitFieldLoc marginLeftTypeBits = BitFieldLoc(19, 20);
  static const BitFieldLoc marginRightTypeBits = BitFieldLoc(21, 22);
  static const BitFieldLoc marginTopTypeBits = BitFieldLoc(23, 24);
  static const BitFieldLoc marginBottomTypeBits = BitFieldLoc(25, 26);

  static const BitFieldLoc intrinsicallySizedBits = BitFieldLoc(27, 27);
  static const BitFieldLoc alignItemsBits = BitFieldLoc(28, 30);

  // ---- Flags 1
  static const BitFieldLoc alignSelfBits = BitFieldLoc(0, 2);
  static const BitFieldLoc justifyItemsBits = BitFieldLoc(3, 5);
  static const BitFieldLoc justifySelfBits = BitFieldLoc(6, 8);
  static const BitFieldLoc gridAutoFlowBits = BitFieldLoc(9, 10);
  static const BitFieldLoc gridRowStartTypeBits = BitFieldLoc(11, 12);
  static const BitFieldLoc gridRowEndTypeBits = BitFieldLoc(13, 14);
  static const BitFieldLoc gridColumnStartTypeBits = BitFieldLoc(15, 16);
  static const BitFieldLoc gridColumnEndTypeBits = BitFieldLoc(17, 18);
  static const BitFieldLoc alignContentBits = BitFieldLoc(19, 22);
  static const BitFieldLoc justifyContentBits = BitFieldLoc(23, 26);
  static const BitFieldLoc flexWrapBits = BitFieldLoc(27, 28);

  // ---- Flags 2
  static const BitFieldLoc paddingLeftTypeBits = BitFieldLoc(0, 1);
  static const BitFieldLoc paddingRightTypeBits = BitFieldLoc(2, 3);
  static const BitFieldLoc paddingTopTypeBits = BitFieldLoc(4, 5);
  static const BitFieldLoc paddingBottomTypeBits = BitFieldLoc(6, 7);
  static const BitFieldLoc insetLeftTypeBits = BitFieldLoc(8, 9);
  static const BitFieldLoc insetRightTypeBits = BitFieldLoc(10, 11);
  static const BitFieldLoc insetTopTypeBits = BitFieldLoc(12, 13);
  static const BitFieldLoc insetBottomTypeBits = BitFieldLoc(14, 15);

  List<GridTrackSizingGroup> get gridTemplateRowSizingFunctions =>
      _gridTemplateRowSizing;
  List<GridTrackSizingGroup> get gridTemplateColumnSizingFunctions =>
      _gridTemplateColumnSizing;
  List<GridTrackSizingGroup> get gridAutoRowSizingFunctions =>
      _gridAutoRowSizing;
  List<GridTrackSizingGroup> get gridAutoColumnSizingFunctions =>
      _gridAutoColumnSizing;

  final List<GridTrackSizingGroup> _gridTemplateRowSizing = [];
  final List<GridTrackSizingGroup> _gridTemplateColumnSizing = [];
  final List<GridTrackSizingGroup> _gridAutoRowSizing = [];
  final List<GridTrackSizingGroup> _gridAutoColumnSizing = [];

  TaffyFlexDirection get flexDirection =>
      TaffyFlexDirection.values[flexDirectionBits.read(layoutFlags0)];
  set flexDirection(TaffyFlexDirection value) =>
      layoutFlags0 = flexDirectionBits.write(layoutFlags0, value.index);

  TaffyFlexWrap get flexWrap =>
      TaffyFlexWrap.values[flexWrapBits.read(layoutFlags1)];
  set flexWrap(TaffyFlexWrap value) =>
      layoutFlags1 = flexWrapBits.write(layoutFlags1, value.index);

  TaffyAlignItems get alignItems =>
      TaffyAlignItems.values[alignItemsBits.read(layoutFlags0)];
  set alignItems(TaffyAlignItems value) =>
      layoutFlags0 = alignItemsBits.write(layoutFlags0, value.index);

  TaffyAlignItems get alignSelf =>
      TaffyAlignItems.values[alignSelfBits.read(layoutFlags1)];
  set alignSelf(TaffyAlignItems value) =>
      layoutFlags1 = alignSelfBits.write(layoutFlags1, value.index);

  TaffyAlignItems get justifyItems =>
      TaffyAlignItems.values[justifyItemsBits.read(layoutFlags1)];
  set justifyItems(TaffyAlignItems value) =>
      layoutFlags1 = justifyItemsBits.write(layoutFlags1, value.index);

  TaffyAlignItems get justifySelf =>
      TaffyAlignItems.values[justifySelfBits.read(layoutFlags1)];
  set justifySelf(TaffyAlignItems value) =>
      layoutFlags1 = justifySelfBits.write(layoutFlags1, value.index);

  TaffyAlignContent get justifyContent =>
      TaffyAlignContent.values[justifyContentBits.read(layoutFlags1)];
  set justifyContent(TaffyAlignContent value) =>
      layoutFlags1 = justifyContentBits.write(layoutFlags1, value.index);

  TaffyAlignContent get alignContent =>
      TaffyAlignContent.values[alignContentBits.read(layoutFlags1)];
  set alignContent(TaffyAlignContent value) =>
      layoutFlags1 = alignContentBits.write(layoutFlags1, value.index);

  TaffyGridPlacementTag get gridRowStartType =>
      TaffyGridPlacementTag.values[gridRowStartTypeBits.read(layoutFlags1)];
  set gridRowStartType(TaffyGridPlacementTag value) =>
      layoutFlags1 = gridRowStartTypeBits.write(layoutFlags1, value.index);

  TaffyGridPlacementTag get gridRowEndType =>
      TaffyGridPlacementTag.values[gridRowEndTypeBits.read(layoutFlags1)];
  set gridRowEndType(TaffyGridPlacementTag value) =>
      layoutFlags1 = gridRowEndTypeBits.write(layoutFlags1, value.index);

  TaffyGridPlacementTag get gridColumnStartType =>
      TaffyGridPlacementTag.values[gridColumnStartTypeBits.read(layoutFlags1)];
  set gridColumnStartType(TaffyGridPlacementTag value) =>
      layoutFlags1 = gridColumnStartTypeBits.write(layoutFlags1, value.index);

  TaffyGridPlacementTag get gridColumnEndType =>
      TaffyGridPlacementTag.values[gridColumnEndTypeBits.read(layoutFlags1)];
  set gridColumnEndType(TaffyGridPlacementTag value) =>
      layoutFlags1 = gridColumnEndTypeBits.write(layoutFlags1, value.index);

  TaffyGridAutoFlow get gridAutoFlow =>
      TaffyGridAutoFlow.values[gridAutoFlowBits.read(layoutFlags1)];
  set gridAutoFlow(TaffyGridAutoFlow value) =>
      layoutFlags1 = gridAutoFlowBits.write(layoutFlags1, value.index);

  TaffyDisplay get display =>
      TaffyDisplay.values[displayBits.read(layoutFlags0)];
  set display(TaffyDisplay value) =>
      layoutFlags0 = displayBits.write(layoutFlags0, value.index);

  TaffyPosition get position =>
      TaffyPosition.values[positionBits.read(layoutFlags0)];
  set position(TaffyPosition value) =>
      layoutFlags0 = positionBits.write(layoutFlags0, value.index);

  TaffyDimensionTag get marginLeftType =>
      TaffyDimensionTag.values[marginLeftTypeBits.read(layoutFlags0)];

  set marginLeftType(TaffyDimensionTag value) =>
      layoutFlags0 = marginLeftTypeBits.write(layoutFlags0, value.index);

  TaffyDimensionTag get marginRightType =>
      TaffyDimensionTag.values[marginRightTypeBits.read(layoutFlags0)];

  set marginRightType(TaffyDimensionTag value) =>
      layoutFlags0 = marginRightTypeBits.write(layoutFlags0, value.index);

  TaffyDimensionTag get marginTopType =>
      TaffyDimensionTag.values[marginTopTypeBits.read(layoutFlags0)];

  set marginTopType(TaffyDimensionTag value) =>
      layoutFlags0 = marginTopTypeBits.write(layoutFlags0, value.index);

  TaffyDimensionTag get marginBottomType =>
      TaffyDimensionTag.values[marginBottomTypeBits.read(layoutFlags0)];

  set marginBottomType(TaffyDimensionTag value) =>
      layoutFlags0 = marginBottomTypeBits.write(layoutFlags0, value.index);

  TaffyDimensionTag get paddingLeftType =>
      TaffyDimensionTag.values[paddingLeftTypeBits.read(layoutFlags2)];

  set paddingLeftType(TaffyDimensionTag value) =>
      layoutFlags2 = paddingLeftTypeBits.write(layoutFlags2, value.index);

  TaffyDimensionTag get paddingRightType =>
      TaffyDimensionTag.values[paddingRightTypeBits.read(layoutFlags2)];

  set paddingRightType(TaffyDimensionTag value) =>
      layoutFlags2 = paddingRightTypeBits.write(layoutFlags2, value.index);

  TaffyDimensionTag get paddingTopType =>
      TaffyDimensionTag.values[paddingTopTypeBits.read(layoutFlags2)];

  set paddingTopType(TaffyDimensionTag value) =>
      layoutFlags2 = paddingTopTypeBits.write(layoutFlags2, value.index);

  TaffyDimensionTag get paddingBottomType =>
      TaffyDimensionTag.values[paddingBottomTypeBits.read(layoutFlags2)];

  set paddingBottomType(TaffyDimensionTag value) =>
      layoutFlags2 = paddingBottomTypeBits.write(layoutFlags2, value.index);

  TaffyDimensionTag get insetLeftType =>
      TaffyDimensionTag.values[insetLeftTypeBits.read(layoutFlags2)];

  set insetLeftType(TaffyDimensionTag value) =>
      layoutFlags2 = insetLeftTypeBits.write(layoutFlags2, value.index);

  TaffyDimensionTag get insetRightType =>
      TaffyDimensionTag.values[insetRightTypeBits.read(layoutFlags2)];

  set insetRightType(TaffyDimensionTag value) =>
      layoutFlags2 = insetRightTypeBits.write(layoutFlags2, value.index);

  TaffyDimensionTag get insetTopType =>
      TaffyDimensionTag.values[insetTopTypeBits.read(layoutFlags2)];

  set insetTopType(TaffyDimensionTag value) =>
      layoutFlags2 = insetTopTypeBits.write(layoutFlags2, value.index);

  TaffyDimensionTag get insetBottomType =>
      TaffyDimensionTag.values[insetBottomTypeBits.read(layoutFlags2)];

  set insetBottomType(TaffyDimensionTag value) =>
      layoutFlags2 = insetBottomTypeBits.write(layoutFlags2, value.index);

  TaffyDimensionTag get gapWidthType =>
      TaffyDimensionTag.values[gapWidthTypeBits.read(layoutFlags0)];

  set gapWidthType(TaffyDimensionTag value) {
    // Can't be set to auto, for simplicity we use the same enum here.
    assert(value != TaffyDimensionTag.auto);
    layoutFlags0 = gapWidthTypeBits.write(layoutFlags0, value.index);
  }

  TaffyDimensionTag get gapHeightType =>
      TaffyDimensionTag.values[gapHeightTypeBits.read(layoutFlags0)];

  set gapHeightType(TaffyDimensionTag value) {
    // Can't be set to auto, for simplicity we use the same enum here.
    assert(value != TaffyDimensionTag.auto);
    layoutFlags0 = gapHeightTypeBits.write(layoutFlags0, value.index);
  }

  TaffyDimensionTag get widthType =>
      TaffyDimensionTag.values[widthTypeBits.read(layoutFlags0)];

  set widthType(TaffyDimensionTag value) =>
      layoutFlags0 = widthTypeBits.write(layoutFlags0, value.index);

  TaffyDimensionTag get heightType =>
      TaffyDimensionTag.values[heightTypeBits.read(layoutFlags0)];

  set heightType(TaffyDimensionTag value) =>
      layoutFlags0 = heightTypeBits.write(layoutFlags0, value.index);

  TaffyDimensionTag get minWidthType =>
      TaffyDimensionTag.values[minWidthTypeBits.read(layoutFlags0)];

  set minWidthType(TaffyDimensionTag value) =>
      layoutFlags0 = minWidthTypeBits.write(layoutFlags0, value.index);

  TaffyDimensionTag get minHeightType =>
      TaffyDimensionTag.values[minHeightTypeBits.read(layoutFlags0)];

  set minHeightType(TaffyDimensionTag value) =>
      layoutFlags0 = minHeightTypeBits.write(layoutFlags0, value.index);

  TaffyDimensionTag get maxWidthType =>
      TaffyDimensionTag.values[maxWidthTypeBits.read(layoutFlags0)];

  set maxWidthType(TaffyDimensionTag value) =>
      layoutFlags0 = maxWidthTypeBits.write(layoutFlags0, value.index);

  TaffyDimensionTag get maxHeightType =>
      TaffyDimensionTag.values[maxHeightTypeBits.read(layoutFlags0)];

  set maxHeightType(TaffyDimensionTag value) =>
      layoutFlags0 = maxHeightTypeBits.write(layoutFlags0, value.index);

  bool get intrinsicallySized => intrinsicallySizedBits.read(layoutFlags0) == 1;
  set intrinsicallySized(bool value) =>
      intrinsicallySizedBits.write(layoutFlags0, value ? 1 : 0);

  void markTaffyNodeDirty() {
    if (_taffyNode != null) {
      taffy?.markDirty(node: _taffyNode!);
      artboard?.markLayoutDirty(this);
    }
  }

  Taffy? get taffy => artboard?.taffy;
  TaffyNode? _taffyNode;
  TaffyNode? get taffyNode => _taffyNode;
  TaffyStyle? _style;

  void syncStyle(Taffy taffy) {
    if (_taffyNode == null || _style == null) {
      return;
    }
    _syncStyle(taffy, _style!, _taffyNode!);
  }

  void _syncStyle(Taffy taffy, TaffyStyle style, TaffyNode taffyNode) {
    bool setIntrinsicWidth = false;
    bool setIntrinsicHeight = false;
    if (intrinsicallySized &&
        (widthType == TaffyDimensionTag.auto ||
            heightType == TaffyDimensionTag.auto)) {
      bool foundIntrinsicSize = false;
      Size intrinsicSize = Size.zero;
      forEachChild((child) {
        if (child is LayoutComponent) {
          return false;
        }
        if (child is Sizable) {
          var minSize = Size(
            minWidthType == TaffyDimensionTag.points ? minWidth : 0,
            minHeightType == TaffyDimensionTag.points ? minHeight : 0,
          );
          var maxSize = Size(
            maxWidthType == TaffyDimensionTag.points
                ? maxWidth
                : double.infinity,
            maxHeightType == TaffyDimensionTag.points
                ? maxHeight
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
        if (widthType == TaffyDimensionTag.auto) {
          setIntrinsicWidth = true;
          style.size.width.tag = TaffyDimensionTag.points;
          style.size.width.value = intrinsicSize.width;
        }
        if (heightType == TaffyDimensionTag.auto) {
          setIntrinsicHeight = true;
          style.size.height.tag = TaffyDimensionTag.points;
          style.size.height.value = intrinsicSize.height;
        }
      }
    }

    style.display = display;
    style.position = position;

    if (!setIntrinsicWidth) {
      style.size.width.tag = widthType;
      style.size.width.value = width;
    }
    if (!setIntrinsicHeight) {
      style.size.height.tag = heightType;
      style.size.height.value = height;
    }
    style.minSize.width.tag = minWidthType;
    style.minSize.width.value = minWidth;
    style.minSize.height.tag = minHeightType;
    style.minSize.height.value = minHeight;

    style.maxSize.width.tag = maxWidthType;
    style.maxSize.width.value = maxWidth;
    style.maxSize.height.tag = maxHeightType;
    style.maxSize.height.value = maxHeight;

    style.gap.width.tag = gapWidthType;
    style.gap.height.tag = gapHeightType;

    style.flexDirection = flexDirection;
    style.flexWrap = flexWrap;
    style.alignItems = alignItems;
    style.alignSelf = alignSelf;
    style.justifyItems = justifyItems;
    style.justifySelf = justifySelf;
    style.alignContent = alignContent;
    style.justifyContent = justifyContent;

    style.gap.width.value = gapWidth;
    style.gap.height.value = gapHeight;

    style.flexGrow = flexGrow;
    style.flexShrink = flexShrink;
    //style.aspectRatio = aspectRatio;

    style.margin.left.tag = marginLeftType;
    style.margin.left.value = marginLeft;
    style.margin.right.tag = marginRightType;
    style.margin.right.value = marginRight;
    style.margin.top.tag = marginTopType;
    style.margin.top.value = marginTop;
    style.margin.bottom.tag = marginBottomType;
    style.margin.bottom.value = marginBottom;

    style.padding.left.tag = paddingLeftType;
    style.padding.left.value = paddingLeft;
    style.padding.right.tag = paddingRightType;
    style.padding.right.value = paddingRight;
    style.padding.top.tag = paddingTopType;
    style.padding.top.value = paddingTop;
    style.padding.bottom.tag = paddingBottomType;
    style.padding.bottom.value = paddingBottom;

    style.inset.left.tag = insetLeftType;
    style.inset.left.value = insetLeft;
    style.inset.right.tag = insetRightType;
    style.inset.right.value = insetRight;
    style.inset.top.tag = insetTopType;
    style.inset.top.value = insetTop;
    style.inset.bottom.tag = insetBottomType;
    style.inset.bottom.value = insetBottom;

    // Grid container properties
    style.gridAutoFlow = gridAutoFlow;

    style.gridTemplateRows = _convertToRepeatableModels(_gridTemplateRowSizing);
    style.gridTemplateColumns =
        _convertToRepeatableModels(_gridTemplateColumnSizing);

    style.gridAutoRows = _convertToSingleModels(_gridAutoRowSizing);
    style.gridAutoColumns = _convertToSingleModels(_gridAutoColumnSizing);

    // Grid child properties
    style.gridRow.start.tag = gridRowStartType;
    style.gridRow.start.lineIndex =
        gridRowStartType == TaffyGridPlacementTag.line ? gridRowStart : 1;
    style.gridRow.start.span =
        gridRowStartType == TaffyGridPlacementTag.span ? gridRowStart : 1;
    style.gridRow.end.tag = gridRowEndType;
    style.gridRow.end.lineIndex =
        gridRowEndType == TaffyGridPlacementTag.line ? gridRowEnd : 1;
    style.gridRow.end.span =
        gridRowEndType == TaffyGridPlacementTag.span ? gridRowEnd : 1;
    style.gridColumn.start.tag = gridColumnStartType;
    style.gridColumn.start.lineIndex =
        gridColumnStartType == TaffyGridPlacementTag.line ? gridColumnStart : 1;
    style.gridColumn.start.span =
        gridColumnStartType == TaffyGridPlacementTag.span ? gridColumnStart : 1;
    style.gridColumn.end.tag = gridColumnEndType;
    style.gridColumn.end.lineIndex =
        gridColumnEndType == TaffyGridPlacementTag.line ? gridColumnEnd : 1;
    style.gridColumn.end.span =
        gridColumnEndType == TaffyGridPlacementTag.span ? gridColumnEnd : 1;

    taffy.setStyle(node: taffyNode, style: style);
  }

  List<TaffyRepeatableTrackSizingModel> _convertToRepeatableModels(
      List<GridTrackSizingGroup> from) {
    List<TaffyRepeatableTrackSizingModel> to = [];
    for (final func in from) {
      var converted = _convertToRepeatableModel(func);
      to.add(converted);
    }
    return to;
  }

  List<TaffySingleTrackSizingModel> _convertToSingleModels(
      List<GridTrackSizingGroup> from) {
    List<TaffySingleTrackSizingModel> to = [];
    for (final func in from) {
      if (func.sizingFunctions.isNotEmpty) {
        var converted = _convertToSingleModel(func.sizingFunctions.first);
        to.add(converted);
      }
    }
    return to;
  }

  TaffyRepeatableTrackSizingModel _convertToRepeatableModel(
      GridTrackSizingGroup from) {
    var type = from.isRepeating
        ? TaffyTrackSizingFunctionTag.repeat
        : TaffyTrackSizingFunctionTag.single;
    var converted = TaffyRepeatableTrackSizingModel(type: type);
    if (from.isRepeating) {
      converted.repeatType = from.repeatType;
      converted.repeatCount = from.repeatCount;
      List<TaffySingleTrackSizingModel> funcs = [];
      for (final func in from.sizingFunctions) {
        var converted = _convertToSingleModel(func);
        funcs.add(converted);
      }
      converted.repeatModels = funcs;
    } else {
      converted.singleModel = _convertToSingleModel(from.sizingFunctions.first);
    }
    return converted;
  }

  TaffySingleTrackSizingModel _convertToSingleModel(TrackSizingFunction from) {
    var converted = TaffySingleTrackSizingModel(
        minType: from.minType,
        minValueType: from.minValueType,
        minValue: from.minValue,
        maxType: from.maxType,
        maxValueType: from.maxValueType,
        maxValue: from.maxValue);
    return converted;
  }

  void makeTaffyNode(Taffy taffy) {
    var result = taffy.node();
    if (result.tag == TaffyResultTag.ok) {
      _taffyNode = result.node;
      var style = taffy.defaultStyle();
      _style?.dispose();
      _style = style;
    }
  }

  @override
  void changeArtboard(Artboard? value) {
    _removeTaffyNode();
    var taffy = value?.taffy;
    if (taffy != null) {
      makeTaffyNode(taffy);
    }
    super.changeArtboard(value);
    artboard?.markLayoutDirty(this);
    if (parent is LayoutComponent) {
      (parent as LayoutComponent).syncLayoutChildren();
    }
  }

  @override
  void clipChanged(bool from, bool to) => markTaffyNodeDirty();

  @override
  void gapHeightChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void gapWidthChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void layoutFlags0Changed(int from, int to) => markTaffyNodeDirty();

  @override
  void layoutFlags1Changed(int from, int to) => markTaffyNodeDirty();

  @override
  void layoutFlags2Changed(int from, int to) => markTaffyNodeDirty();

  @override
  void heightChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void widthChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void maxHeightChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void maxWidthChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void minHeightChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void minWidthChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void flexGrowChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void flexShrinkChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void aspectRatioChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void marginBottomChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void marginLeftChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void marginRightChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void marginTopChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void paddingBottomChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void paddingLeftChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void paddingRightChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void paddingTopChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void insetBottomChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void insetLeftChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void insetRightChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void insetTopChanged(double from, double to) => markTaffyNodeDirty();

  @override
  void gridRowStartChanged(int from, int to) => markTaffyNodeDirty();

  @override
  void gridRowEndChanged(int from, int to) => markTaffyNodeDirty();

  @override
  void gridColumnStartChanged(int from, int to) => markTaffyNodeDirty();

  @override
  void gridColumnEndChanged(int from, int to) => markTaffyNodeDirty();

  // We should call this whenever any property on any of the sizing objects
  // is updated
  void gridSizingUpdated() {
    markTaffyNodeDirty();
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

  void syncLayoutChildren() {
    var node = _taffyNode;
    if (node == null) {
      return;
    }
    taffy?.setChildren(
        parent: node,
        children: children
            .whereType<LayoutComponent>()
            .map((child) => child.taffyNode)
            .whereNotNull()
            .toList());
  }

  @override
  void childAdded(Component child) {
    super.childAdded(child);
    switch (child.coreType) {
      case GridTrackSizingGroupBase.typeKey:
        var group = child as GridTrackSizingGroup;
        group.valueChanged.addListener(_gridContainerValueChanged);
        switch (group.trackType) {
          case GridTrackSizingType.templateRow:
            _gridTemplateRowSizing.add(child);

            break;
          case GridTrackSizingType.templateColumn:
            _gridTemplateColumnSizing.add(child);

            break;
          case GridTrackSizingType.autoRow:
            _gridAutoRowSizing.add(child);

            break;
          case GridTrackSizingType.autoColumn:
            _gridAutoColumnSizing.add(child);

            break;
        }
    }
    markTaffyNodeDirty();
  }

  @override
  void childRemoved(Component child) {
    super.childRemoved(child);
    switch (child.coreType) {
      case GridTrackSizingGroupBase.typeKey:
        var group = child as GridTrackSizingGroup;
        group.valueChanged.removeListener(_gridContainerValueChanged);
        switch (group.trackType) {
          case GridTrackSizingType.templateRow:
            _gridTemplateRowSizing.remove(child);

            break;
          case GridTrackSizingType.templateColumn:
            _gridTemplateColumnSizing.remove(child);

            break;
          case GridTrackSizingType.autoRow:
            _gridAutoRowSizing.remove(child);

            break;
          case GridTrackSizingType.autoColumn:
            _gridAutoColumnSizing.remove(child);

            break;
        }
    }
    markTaffyNodeDirty();
  }

  void _gridContainerValueChanged() {
    markTaffyNodeDirty();
  }

  @override
  void onAdded() {
    super.onAdded();
    syncLayoutChildren();
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

  void updateLayoutBounds(Taffy taffy) {
    var taffyNode = _taffyNode;
    if (taffyNode == null) {
      return;
    }

    var layoutValueResult = taffy.layout(node: taffyNode);
    if (layoutValueResult.tag == TaffyResultTag.ok) {
      var layout = layoutValueResult.layout!;

      if (layout.location != _layoutLocation || layout.size != _layoutSize) {
        // TODO: Sometimes taffy returns NaN for these values, we need to handle
        // this/show an error.
        _layoutLocation =
            layout.location.isFinite ? layout.location : Offset.zero;
        _layoutSize = layout.size.isFinite ? layout.size : Size.zero;
        propagateSize();
        markWorldTransformDirty();
      } else if (false /*was content resized*/) {
        markWorldTransformDirty();
      }
    } else {
      print('hmm no layout?!');
    }
  }

  void _removeTaffyNode() {
    if (_taffyNode != null) {
      artboard?.taffy.remove(node: _taffyNode!);
      _taffyNode = null;
      _style?.dispose();
      _style = null;
    }
    var parent = this.parent;
    if (parent is LayoutComponent) {
      parent.markTaffyNodeDirty();
    }
  }

  @override
  void onRemoved() {
    _removeTaffyNode();
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
