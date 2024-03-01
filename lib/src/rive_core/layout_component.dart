import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:rive/src/generated/layout_component_base.dart';
import 'package:rive/src/rive_core/bounds_provider.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/world_transform_component.dart';
import 'package:rive_common/math.dart';

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

  bool get intrinsicallySized => intrinsicallySizedBits.read(layoutFlags0) == 1;
  set intrinsicallySized(bool value) =>
      intrinsicallySizedBits.write(layoutFlags0, value ? 1 : 0);

  @override
  void clipChanged(bool from, bool to) {}

  @override
  void gapHeightChanged(double from, double to) {}

  @override
  void gapWidthChanged(double from, double to) {}

  @override
  void layoutFlags0Changed(int from, int to) {}

  @override
  void layoutFlags1Changed(int from, int to) {}

  @override
  void layoutFlags2Changed(int from, int to) {}

  @override
  void heightChanged(double from, double to) {}

  @override
  void widthChanged(double from, double to) {}

  @override
  void maxHeightChanged(double from, double to) {}

  @override
  void maxWidthChanged(double from, double to) {}

  @override
  void minHeightChanged(double from, double to) {}

  @override
  void minWidthChanged(double from, double to) {}

  @override
  void flexGrowChanged(double from, double to) {}

  @override
  void flexShrinkChanged(double from, double to) {}

  @override
  void aspectRatioChanged(double from, double to) {}

  @override
  void marginBottomChanged(double from, double to) {}

  @override
  void marginLeftChanged(double from, double to) {}

  @override
  void marginRightChanged(double from, double to) {}

  @override
  void marginTopChanged(double from, double to) {}

  @override
  void paddingBottomChanged(double from, double to) {}

  @override
  void paddingLeftChanged(double from, double to) {}

  @override
  void paddingRightChanged(double from, double to) {}

  @override
  void paddingTopChanged(double from, double to) {}

  @override
  void insetBottomChanged(double from, double to) {}

  @override
  void insetLeftChanged(double from, double to) {}

  @override
  void insetRightChanged(double from, double to) {}

  @override
  void insetTopChanged(double from, double to) {}

  @override
  void gridRowStartChanged(int from, int to) {}

  @override
  void gridRowEndChanged(int from, int to) {}

  @override
  void gridColumnStartChanged(int from, int to) {}

  @override
  void gridColumnEndChanged(int from, int to) {}

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

  final Offset _layoutLocation = Offset.zero;
  final Size _layoutSize = Size.zero;

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
