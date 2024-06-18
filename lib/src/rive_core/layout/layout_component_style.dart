import 'package:rive/src/generated/layout/layout_component_style_base.dart';
import 'package:rive/src/rive_core/notifier.dart';
import 'package:rive_common/layout_engine.dart';
import 'package:rive_common/math.dart';

export 'package:rive/src/generated/layout/layout_component_style_base.dart';

enum ScaleType {
  fixed,
  fill,
  hug;

  String get label => name[0].toUpperCase() + name.substring(1);
}

class LayoutComponentStyle extends LayoutComponentStyleBase {
  Notifier valueChanged = Notifier();

  // ---- Flags 0
  static const BitFieldLoc displayBits = BitFieldLoc(0, 0);
  static const BitFieldLoc positionTypeBits = BitFieldLoc(1, 2); // relative
  static const BitFieldLoc flexDirectionBits = BitFieldLoc(3, 4); // row
  static const BitFieldLoc directionBits = BitFieldLoc(5, 6);
  static const BitFieldLoc alignContentBits = BitFieldLoc(7, 9);
  static const BitFieldLoc alignItemsBits = BitFieldLoc(10, 12); // flexStart
  static const BitFieldLoc alignSelfBits = BitFieldLoc(13, 15);
  static const BitFieldLoc justifyContentBits =
      BitFieldLoc(16, 18); // flexStart
  static const BitFieldLoc flexWrapBits = BitFieldLoc(19, 20);
  static const BitFieldLoc overflowBits = BitFieldLoc(21, 22);
  static const BitFieldLoc intrinsicallySizedBits = BitFieldLoc(23, 23);
  static const BitFieldLoc widthUnitsBits = BitFieldLoc(24, 25); // points
  static const BitFieldLoc heightUnitsBits = BitFieldLoc(26, 27); // points

  // ---- Flags 1
  static const BitFieldLoc borderLeftUnitsBits = BitFieldLoc(0, 1);
  static const BitFieldLoc borderRightUnitsBits = BitFieldLoc(2, 3);
  static const BitFieldLoc borderTopUnitsBits = BitFieldLoc(4, 5);
  static const BitFieldLoc borderBottomUnitsBits = BitFieldLoc(6, 7);
  static const BitFieldLoc marginLeftUnitsBits = BitFieldLoc(8, 9);
  static const BitFieldLoc marginRightUnitsBits = BitFieldLoc(10, 11);
  static const BitFieldLoc marginTopUnitsBits = BitFieldLoc(12, 13);
  static const BitFieldLoc marginBottomUnitsBits = BitFieldLoc(14, 15);
  static const BitFieldLoc paddingLeftUnitsBits = BitFieldLoc(16, 17);
  static const BitFieldLoc paddingRightUnitsBits = BitFieldLoc(18, 19);
  static const BitFieldLoc paddingTopUnitsBits = BitFieldLoc(20, 21);
  static const BitFieldLoc paddingBottomUnitsBits = BitFieldLoc(22, 23);
  static const BitFieldLoc positionLeftUnitsBits = BitFieldLoc(24, 25);
  static const BitFieldLoc positionRightUnitsBits = BitFieldLoc(26, 27);
  static const BitFieldLoc positionTopUnitsBits = BitFieldLoc(28, 29);
  static const BitFieldLoc positionBottomUnitsBits = BitFieldLoc(30, 31);

  // ---- Flags 2
  static const BitFieldLoc gapHorizontalUnitsBits = BitFieldLoc(0, 1);
  static const BitFieldLoc gapVerticalUnitsBits = BitFieldLoc(2, 3);
  static const BitFieldLoc minWidthUnitsBits = BitFieldLoc(4, 5);
  static const BitFieldLoc minHeightUnitsBits = BitFieldLoc(6, 7);
  static const BitFieldLoc maxWidthUnitsBits = BitFieldLoc(8, 9);
  static const BitFieldLoc maxHeightUnitsBits = BitFieldLoc(10, 11);

  static const BitFieldLoc widthScaleTypeBits = BitFieldLoc(0, 3);
  static const BitFieldLoc heightScaleTypeBits = BitFieldLoc(4, 7);

  LayoutDisplay get display =>
      LayoutDisplay.values[displayBits.read(layoutFlags0)];
  set display(LayoutDisplay value) =>
      layoutFlags0 = displayBits.write(layoutFlags0, value.index);

  LayoutPosition get positionType =>
      LayoutPosition.values[positionTypeBits.read(layoutFlags0)];
  set positionType(LayoutPosition value) =>
      layoutFlags0 = positionTypeBits.write(layoutFlags0, value.index);

  LayoutFlexDirection get flexDirection =>
      LayoutFlexDirection.values[flexDirectionBits.read(layoutFlags0)];
  set flexDirection(LayoutFlexDirection value) =>
      layoutFlags0 = flexDirectionBits.write(layoutFlags0, value.index);

  LayoutDirection get direction =>
      LayoutDirection.values[directionBits.read(layoutFlags0)];
  set direction(LayoutDirection value) =>
      layoutFlags0 = directionBits.write(layoutFlags0, value.index);

  LayoutWrap get flexWrap => LayoutWrap.values[flexWrapBits.read(layoutFlags0)];
  set flexWrap(LayoutWrap value) =>
      layoutFlags0 = flexWrapBits.write(layoutFlags0, value.index);

  LayoutAlign get alignItems =>
      LayoutAlign.values[alignItemsBits.read(layoutFlags0)];
  set alignItems(LayoutAlign value) =>
      layoutFlags0 = alignItemsBits.write(layoutFlags0, value.index);

  LayoutAlign get alignSelf =>
      LayoutAlign.values[alignSelfBits.read(layoutFlags0)];
  set alignSelf(LayoutAlign value) =>
      layoutFlags0 = alignSelfBits.write(layoutFlags0, value.index);

  LayoutAlign get alignContent =>
      LayoutAlign.values[alignContentBits.read(layoutFlags0)];
  set alignContent(LayoutAlign value) =>
      layoutFlags0 = alignContentBits.write(layoutFlags0, value.index);

  LayoutJustify get justifyContent =>
      LayoutJustify.values[justifyContentBits.read(layoutFlags0)];
  set justifyContent(LayoutJustify value) =>
      layoutFlags0 = justifyContentBits.write(layoutFlags0, value.index);

  bool get intrinsicallySized => intrinsicallySizedBits.read(layoutFlags0) == 1;
  set intrinsicallySized(bool value) =>
      intrinsicallySizedBits.write(layoutFlags0, value ? 1 : 0);

  LayoutUnit get widthUnits =>
      LayoutUnit.values[widthUnitsBits.read(layoutFlags0)];
  set widthUnits(LayoutUnit value) =>
      layoutFlags0 = widthUnitsBits.write(layoutFlags0, value.index);

  LayoutUnit get heightUnits =>
      LayoutUnit.values[heightUnitsBits.read(layoutFlags0)];
  set heightUnits(LayoutUnit value) =>
      layoutFlags0 = heightUnitsBits.write(layoutFlags0, value.index);

  LayoutUnit get borderLeftUnits =>
      LayoutUnit.values[borderLeftUnitsBits.read(layoutFlags1)];
  set borderLeftUnits(LayoutUnit value) =>
      layoutFlags1 = borderLeftUnitsBits.write(layoutFlags1, value.index);

  LayoutUnit get borderRightUnits =>
      LayoutUnit.values[borderRightUnitsBits.read(layoutFlags1)];
  set borderRightUnits(LayoutUnit value) =>
      layoutFlags1 = borderRightUnitsBits.write(layoutFlags1, value.index);

  LayoutUnit get borderTopUnits =>
      LayoutUnit.values[borderTopUnitsBits.read(layoutFlags1)];
  set borderTopUnits(LayoutUnit value) =>
      layoutFlags1 = borderTopUnitsBits.write(layoutFlags1, value.index);

  LayoutUnit get borderBottomUnits =>
      LayoutUnit.values[borderBottomUnitsBits.read(layoutFlags1)];
  set borderBottomUnits(LayoutUnit value) =>
      layoutFlags1 = borderBottomUnitsBits.write(layoutFlags1, value.index);

  LayoutUnit get marginLeftUnits =>
      LayoutUnit.values[marginLeftUnitsBits.read(layoutFlags1)];
  set marginLeftUnits(LayoutUnit value) =>
      layoutFlags1 = marginLeftUnitsBits.write(layoutFlags1, value.index);

  LayoutUnit get marginRightUnits =>
      LayoutUnit.values[marginRightUnitsBits.read(layoutFlags1)];
  set marginRightUnits(LayoutUnit value) =>
      layoutFlags1 = marginRightUnitsBits.write(layoutFlags1, value.index);

  LayoutUnit get marginTopUnits =>
      LayoutUnit.values[marginTopUnitsBits.read(layoutFlags1)];
  set marginTopUnits(LayoutUnit value) =>
      layoutFlags1 = marginTopUnitsBits.write(layoutFlags1, value.index);

  LayoutUnit get marginBottomUnits =>
      LayoutUnit.values[marginBottomUnitsBits.read(layoutFlags1)];
  set marginBottomUnits(LayoutUnit value) =>
      layoutFlags1 = marginBottomUnitsBits.write(layoutFlags1, value.index);

  LayoutUnit get paddingLeftUnits =>
      LayoutUnit.values[paddingLeftUnitsBits.read(layoutFlags1)];
  set paddingLeftUnits(LayoutUnit value) =>
      layoutFlags1 = paddingLeftUnitsBits.write(layoutFlags1, value.index);

  LayoutUnit get paddingRightUnits =>
      LayoutUnit.values[paddingRightUnitsBits.read(layoutFlags1)];
  set paddingRightUnits(LayoutUnit value) =>
      layoutFlags1 = paddingRightUnitsBits.write(layoutFlags1, value.index);

  LayoutUnit get paddingTopUnits =>
      LayoutUnit.values[paddingTopUnitsBits.read(layoutFlags1)];
  set paddingTopUnits(LayoutUnit value) =>
      layoutFlags1 = paddingTopUnitsBits.write(layoutFlags1, value.index);

  LayoutUnit get paddingBottomUnits =>
      LayoutUnit.values[paddingBottomUnitsBits.read(layoutFlags1)];
  set paddingBottomUnits(LayoutUnit value) =>
      layoutFlags1 = paddingBottomUnitsBits.write(layoutFlags1, value.index);

  LayoutUnit get positionLeftUnits =>
      LayoutUnit.values[positionLeftUnitsBits.read(layoutFlags1)];
  set positionLeftUnits(LayoutUnit value) =>
      layoutFlags1 = positionLeftUnitsBits.write(layoutFlags1, value.index);

  LayoutUnit get positionRightUnits =>
      LayoutUnit.values[positionRightUnitsBits.read(layoutFlags1)];
  set positionRightUnits(LayoutUnit value) =>
      layoutFlags1 = positionRightUnitsBits.write(layoutFlags1, value.index);

  LayoutUnit get positionTopUnits =>
      LayoutUnit.values[positionTopUnitsBits.read(layoutFlags1)];
  set positionTopUnits(LayoutUnit value) =>
      layoutFlags1 = positionTopUnitsBits.write(layoutFlags1, value.index);

  LayoutUnit get positionBottomUnits =>
      LayoutUnit.values[positionBottomUnitsBits.read(layoutFlags1)];
  set positionBottomUnits(LayoutUnit value) =>
      layoutFlags1 = positionBottomUnitsBits.write(layoutFlags1, value.index);

  LayoutUnit get gapHorizontalUnits =>
      LayoutUnit.values[gapHorizontalUnitsBits.read(layoutFlags2)];
  set gapHorizontalUnits(LayoutUnit value) =>
      layoutFlags2 = gapHorizontalUnitsBits.write(layoutFlags2, value.index);

  LayoutUnit get gapVerticalUnits =>
      LayoutUnit.values[gapVerticalUnitsBits.read(layoutFlags2)];
  set gapVerticalUnits(LayoutUnit value) =>
      layoutFlags2 = gapVerticalUnitsBits.write(layoutFlags2, value.index);

  LayoutUnit get minWidthUnits =>
      LayoutUnit.values[minWidthUnitsBits.read(layoutFlags2)];
  set minWidthUnits(LayoutUnit value) =>
      layoutFlags2 = minWidthUnitsBits.write(layoutFlags2, value.index);

  LayoutUnit get minHeightUnits =>
      LayoutUnit.values[minHeightUnitsBits.read(layoutFlags2)];
  set minHeightUnits(LayoutUnit value) =>
      layoutFlags2 = minHeightUnitsBits.write(layoutFlags2, value.index);

  LayoutUnit get maxWidthUnits =>
      LayoutUnit.values[maxWidthUnitsBits.read(layoutFlags2)];
  set maxWidthUnits(LayoutUnit value) =>
      layoutFlags2 = maxWidthUnitsBits.write(layoutFlags2, value.index);

  LayoutUnit get maxHeightUnits =>
      LayoutUnit.values[maxHeightUnitsBits.read(layoutFlags2)];
  set maxHeightUnits(LayoutUnit value) =>
      layoutFlags2 = maxHeightUnitsBits.write(layoutFlags2, value.index);

  ScaleType get widthScaleType =>
      ScaleType.values[widthScaleTypeBits.read(scaleType)];

  set widthScaleType(ScaleType value) =>
      scaleType = widthScaleTypeBits.write(scaleType, value.index);

  ScaleType get heightScaleType =>
      ScaleType.values[heightScaleTypeBits.read(scaleType)];

  set heightScaleType(ScaleType value) =>
      scaleType = heightScaleTypeBits.write(scaleType, value.index);

  void markLayoutNodeDirty() {
    valueChanged.notify();
  }

  @override
  void buildDependencies() {
    super.buildDependencies();
    parent?.addDependent(this);
  }

  @override
  void onAdded() {}

  @override
  void onAddedDirty() {}

  @override
  void layoutFlags0Changed(int from, int to) {
    markLayoutNodeDirty();
  }

  @override
  void layoutFlags1Changed(int from, int to) {
    markLayoutNodeDirty();
  }

  @override
  void layoutFlags2Changed(int from, int to) {
    markLayoutNodeDirty();
  }

  @override
  void flexChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void flexGrowChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void flexShrinkChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void flexBasisChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void aspectRatioChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void minWidthChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void maxWidthChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void minHeightChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void maxHeightChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void gapHorizontalChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void gapVerticalChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void borderLeftChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void borderTopChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void borderRightChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void borderBottomChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void marginLeftChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void marginTopChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void marginRightChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void marginBottomChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void paddingLeftChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void paddingTopChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void paddingRightChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void paddingBottomChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void positionLeftChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void positionTopChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void positionRightChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void positionBottomChanged(double from, double to) => markLayoutNodeDirty();

  @override
  void scaleTypeChanged(int from, int to) {}

  @override
  void update(int dirt) {}
}
