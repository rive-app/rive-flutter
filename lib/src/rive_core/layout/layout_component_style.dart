import 'package:rive/src/generated/layout/layout_component_style_base.dart';
import 'package:rive/src/rive_core/animation/keyframe_interpolation.dart';
import 'package:rive/src/rive_core/animation/keyframe_interpolator.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/rive_core/enum_helper.dart';
import 'package:rive/src/rive_core/notifier.dart';
import 'package:rive_common/layout_engine.dart';
import 'package:rive_common/math.dart';

export 'package:rive/src/generated/layout/layout_component_style_base.dart';

enum LayoutAlignmentType {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
  spaceBetweenStart,
  spaceBetweenCenter,
  spaceBetweenEnd;
}

enum ScaleType {
  fixed,
  fill,
  hug;

  String get label => name[0].toUpperCase() + name.substring(1);
}

enum LayoutAnimationStyle { none, inherit, custom }

enum LayoutStyleInterpolation { hold, linear, cubic, elastic }

extension LayoutStyleInterpolationExtension on LayoutStyleInterpolation {
  // Converts to KeyFrameInterpolation to we can be compatible with
  // InterpolationViewModel
  KeyFrameInterpolation toKeyFrameInterpolation() {
    switch (this) {
      case LayoutStyleInterpolation.hold:
        return KeyFrameInterpolation.hold;
      case LayoutStyleInterpolation.linear:
        return KeyFrameInterpolation.linear;
      case LayoutStyleInterpolation.cubic:
        return KeyFrameInterpolation.cubic;
      case LayoutStyleInterpolation.elastic:
        return KeyFrameInterpolation.elastic;
    }
  }
}

class LayoutComponentStyle extends LayoutComponentStyleBase {
  Notifier valueChanged = Notifier();
  Notifier interpolationChanged = Notifier();

  KeyFrameInterpolator? _interpolator;
  KeyFrameInterpolator? get interpolator => _interpolator;
  set interpolator(KeyFrameInterpolator? value) {
    if (_interpolator == value) {
      return;
    }
    _interpolator = value;
    interpolatorId = value?.id ?? Core.missingId;
  }

  LayoutStyleInterpolation get interpolation =>
      enumAt(LayoutStyleInterpolation.values, interpolationType);
  set interpolation(LayoutStyleInterpolation value) {
    interpolationType = value.index;
  }

  LayoutAnimationStyle get animationStyle =>
      enumAt(LayoutAnimationStyle.values, animationStyleType);
  set animationStyle(LayoutAnimationStyle value) {
    animationStyleType = value.index;
  }

  static List<Enum> enumForPropertyKey(int propertyKey) {
    switch (propertyKey) {
      case LayoutComponentStyleBase.borderLeftUnitsValuePropertyKey:
      case LayoutComponentStyleBase.borderRightUnitsValuePropertyKey:
      case LayoutComponentStyleBase.borderTopUnitsValuePropertyKey:
      case LayoutComponentStyleBase.borderBottomUnitsValuePropertyKey:
      case LayoutComponentStyleBase.marginLeftUnitsValuePropertyKey:
      case LayoutComponentStyleBase.marginRightUnitsValuePropertyKey:
      case LayoutComponentStyleBase.marginTopUnitsValuePropertyKey:
      case LayoutComponentStyleBase.marginBottomUnitsValuePropertyKey:
      case LayoutComponentStyleBase.paddingLeftUnitsValuePropertyKey:
      case LayoutComponentStyleBase.paddingRightUnitsValuePropertyKey:
      case LayoutComponentStyleBase.paddingTopUnitsValuePropertyKey:
      case LayoutComponentStyleBase.paddingBottomUnitsValuePropertyKey:
      case LayoutComponentStyleBase.positionLeftUnitsValuePropertyKey:
      case LayoutComponentStyleBase.positionRightUnitsValuePropertyKey:
      case LayoutComponentStyleBase.positionTopUnitsValuePropertyKey:
      case LayoutComponentStyleBase.positionBottomUnitsValuePropertyKey:
      case LayoutComponentStyleBase.gapHorizontalUnitsValuePropertyKey:
      case LayoutComponentStyleBase.gapVerticalUnitsValuePropertyKey:
      case LayoutComponentStyleBase.minWidthUnitsValuePropertyKey:
      case LayoutComponentStyleBase.minHeightUnitsValuePropertyKey:
      case LayoutComponentStyleBase.maxWidthUnitsValuePropertyKey:
      case LayoutComponentStyleBase.maxHeightUnitsValuePropertyKey:
      case LayoutComponentStyleBase.widthUnitsValuePropertyKey:
      case LayoutComponentStyleBase.heightUnitsValuePropertyKey:
        return LayoutUnit.values;
      case LayoutComponentStyleBase.alignContentValuePropertyKey:
      case LayoutComponentStyleBase.alignItemsValuePropertyKey:
      case LayoutComponentStyleBase.alignSelfValuePropertyKey:
        return LayoutAlign.values;
      case LayoutComponentStyleBase.justifyContentValuePropertyKey:
        return LayoutJustify.values;
      case LayoutComponentStyleBase.directionValuePropertyKey:
        return LayoutDirection.values;
      case LayoutComponentStyleBase.flexDirectionValuePropertyKey:
        return LayoutFlexDirection.values;
      case LayoutComponentStyleBase.positionTypeValuePropertyKey:
        return LayoutPosition.values;
      case LayoutComponentStyleBase.flexWrapValuePropertyKey:
        return LayoutWrap.values;
      case LayoutComponentStyleBase.overflowValuePropertyKey:
        return LayoutOverflow.values;
      case LayoutComponentStyleBase.displayValuePropertyKey:
        return LayoutDisplay.values;
      case LayoutComponentStyleBase.layoutAlignmentTypePropertyKey:
        return LayoutAlignmentType.values;
      default:
        return [];
    }
  }

  static const BitFieldLoc widthScaleTypeBits = BitFieldLoc(0, 3);
  static const BitFieldLoc heightScaleTypeBits = BitFieldLoc(4, 7);

  LayoutDisplay get display => LayoutDisplay.values[displayValue];
  set display(LayoutDisplay value) => displayValue = value.index;

  LayoutPosition get positionType => LayoutPosition.values[positionTypeValue];
  set positionType(LayoutPosition value) => positionTypeValue = value.index;

  LayoutFlexDirection get flexDirection =>
      LayoutFlexDirection.values[flexDirectionValue];
  set flexDirection(LayoutFlexDirection value) =>
      flexDirectionValue = value.index;

  LayoutDirection get direction => LayoutDirection.values[directionValue];
  set direction(LayoutDirection value) => directionValue = value.index;

  LayoutWrap get flexWrap => LayoutWrap.values[flexWrapValue];
  set flexWrap(LayoutWrap value) => flexWrapValue = value.index;

  LayoutAlign get alignItems => LayoutAlign.values[alignItemsValue];
  set alignItems(LayoutAlign value) => alignItemsValue = value.index;

  LayoutAlign get alignSelf => LayoutAlign.values[alignSelfValue];
  set alignSelf(LayoutAlign value) => alignSelfValue = value.index;

  LayoutAlign get alignContent => LayoutAlign.values[alignContentValue];
  set alignContent(LayoutAlign value) => alignContentValue = value.index;

  LayoutJustify get justifyContent => LayoutJustify.values[justifyContentValue];
  set justifyContent(LayoutJustify value) => justifyContentValue = value.index;

  bool get intrinsicallySized => intrinsicallySizedValue;
  set intrinsicallySized(bool value) => intrinsicallySizedValue = value;

  LayoutUnit get widthUnits => LayoutUnit.values[widthUnitsValue];
  set widthUnits(LayoutUnit value) => widthUnitsValue = value.index;

  LayoutUnit get heightUnits => LayoutUnit.values[heightUnitsValue];
  set heightUnits(LayoutUnit value) => heightUnitsValue = value.index;

  LayoutUnit get borderLeftUnits => LayoutUnit.values[borderLeftUnitsValue];
  set borderLeftUnits(LayoutUnit value) => borderLeftUnitsValue = value.index;

  LayoutUnit get borderRightUnits => LayoutUnit.values[borderRightUnitsValue];
  set borderRightUnits(LayoutUnit value) => borderRightUnitsValue = value.index;

  LayoutUnit get borderTopUnits => LayoutUnit.values[borderTopUnitsValue];
  set borderTopUnits(LayoutUnit value) => borderTopUnitsValue = value.index;

  LayoutUnit get borderBottomUnits => LayoutUnit.values[borderBottomUnitsValue];
  set borderBottomUnits(LayoutUnit value) =>
      borderBottomUnitsValue = value.index;

  LayoutUnit get marginLeftUnits => LayoutUnit.values[marginLeftUnitsValue];
  set marginLeftUnits(LayoutUnit value) => marginLeftUnitsValue = value.index;

  LayoutUnit get marginRightUnits => LayoutUnit.values[marginRightUnitsValue];
  set marginRightUnits(LayoutUnit value) => marginRightUnitsValue = value.index;

  LayoutUnit get marginTopUnits => LayoutUnit.values[marginTopUnitsValue];
  set marginTopUnits(LayoutUnit value) => marginTopUnitsValue = value.index;

  LayoutUnit get marginBottomUnits => LayoutUnit.values[marginBottomUnitsValue];
  set marginBottomUnits(LayoutUnit value) =>
      marginBottomUnitsValue = value.index;

  LayoutUnit get paddingLeftUnits => LayoutUnit.values[paddingLeftUnitsValue];
  set paddingLeftUnits(LayoutUnit value) => paddingLeftUnitsValue = value.index;

  LayoutUnit get paddingRightUnits => LayoutUnit.values[paddingRightUnitsValue];
  set paddingRightUnits(LayoutUnit value) =>
      paddingRightUnitsValue = value.index;

  LayoutUnit get paddingTopUnits => LayoutUnit.values[paddingTopUnitsValue];
  set paddingTopUnits(LayoutUnit value) => paddingTopUnitsValue = value.index;

  LayoutUnit get paddingBottomUnits =>
      LayoutUnit.values[paddingBottomUnitsValue];
  set paddingBottomUnits(LayoutUnit value) =>
      paddingBottomUnitsValue = value.index;

  LayoutUnit get positionLeftUnits => LayoutUnit.values[positionLeftUnitsValue];
  set positionLeftUnits(LayoutUnit value) =>
      positionLeftUnitsValue = value.index;

  LayoutUnit get positionRightUnits =>
      LayoutUnit.values[positionRightUnitsValue];
  set positionRightUnits(LayoutUnit value) =>
      positionRightUnitsValue = value.index;

  LayoutUnit get positionTopUnits => LayoutUnit.values[positionTopUnitsValue];
  set positionTopUnits(LayoutUnit value) => positionTopUnitsValue = value.index;

  LayoutUnit get positionBottomUnits =>
      LayoutUnit.values[positionBottomUnitsValue];
  set positionBottomUnits(LayoutUnit value) =>
      positionBottomUnitsValue = value.index;

  LayoutUnit get gapHorizontalUnits =>
      LayoutUnit.values[gapHorizontalUnitsValue];
  set gapHorizontalUnits(LayoutUnit value) =>
      gapHorizontalUnitsValue = value.index;

  LayoutUnit get gapVerticalUnits => LayoutUnit.values[gapVerticalUnitsValue];
  set gapVerticalUnits(LayoutUnit value) => gapVerticalUnitsValue = value.index;

  LayoutUnit get minWidthUnits => LayoutUnit.values[minWidthUnitsValue];
  set minWidthUnits(LayoutUnit value) => minWidthUnitsValue = value.index;

  LayoutUnit get minHeightUnits => LayoutUnit.values[minHeightUnitsValue];
  set minHeightUnits(LayoutUnit value) => minHeightUnitsValue = value.index;

  LayoutUnit get maxWidthUnits => LayoutUnit.values[maxWidthUnitsValue];
  set maxWidthUnits(LayoutUnit value) => maxWidthUnitsValue = value.index;

  LayoutUnit get maxHeightUnits => LayoutUnit.values[maxHeightUnitsValue];
  set maxHeightUnits(LayoutUnit value) => maxHeightUnitsValue = value.index;

  ScaleType get widthScaleType =>
      ScaleType.values[widthScaleTypeBits.read(scaleType)];

  set widthScaleType(ScaleType value) =>
      scaleType = widthScaleTypeBits.write(scaleType, value.index);

  ScaleType get heightScaleType =>
      ScaleType.values[heightScaleTypeBits.read(scaleType)];

  set heightScaleType(ScaleType value) =>
      scaleType = heightScaleTypeBits.write(scaleType, value.index);

  LayoutAlignmentType get alignmentType =>
      LayoutAlignmentType.values[layoutAlignmentType];

  set alignmentType(LayoutAlignmentType value) =>
      layoutAlignmentType = value.index;

  void markLayoutNodeDirty() {
    valueChanged.notify();
  }

  void markLayoutStyleDirty() {
    interpolationChanged.notify();
  }

  @override
  void buildDependencies() {
    super.buildDependencies();
    parent?.addDependent(this);
  }

  @override
  void onAdded() {}

  @override
  void onAddedDirty() {
    interpolator = context.resolve(interpolatorId);
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
  void positionTypeValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void displayValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void flexDirectionValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void directionValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void alignContentValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void alignItemsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void alignSelfValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void justifyContentValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void flexWrapValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void overflowValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void intrinsicallySizedValueChanged(bool from, bool to) =>
      markLayoutNodeDirty();

  @override
  void widthUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void heightUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void borderLeftUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void borderRightUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void borderTopUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void borderBottomUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void marginLeftUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void marginRightUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void marginTopUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void marginBottomUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void paddingLeftUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void paddingRightUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void paddingTopUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void paddingBottomUnitsValueChanged(int from, int to) =>
      markLayoutNodeDirty();

  @override
  void positionLeftUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void positionRightUnitsValueChanged(int from, int to) =>
      markLayoutNodeDirty();

  @override
  void positionTopUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void positionBottomUnitsValueChanged(int from, int to) =>
      markLayoutNodeDirty();

  @override
  void gapHorizontalUnitsValueChanged(int from, int to) =>
      markLayoutNodeDirty();

  @override
  void gapVerticalUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void minWidthUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void minHeightUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void maxWidthUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void maxHeightUnitsValueChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void animationStyleTypeChanged(int from, int to) {
    markLayoutNodeDirty();
  }

  @override
  void interpolationTypeChanged(int from, int to) {
    markLayoutStyleDirty();
    markLayoutNodeDirty();
  }

  @override
  void interpolatorIdChanged(int from, int to) {
    interpolator = context.resolve(interpolatorId);
    markLayoutStyleDirty();
    markLayoutNodeDirty();
  }

  @override
  void interpolationTimeChanged(double from, double to) {
    markLayoutStyleDirty();
    markLayoutNodeDirty();
  }

  @override
  void scaleTypeChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void layoutAlignmentTypeChanged(int from, int to) => markLayoutNodeDirty();

  @override
  void update(int dirt) {}
}
