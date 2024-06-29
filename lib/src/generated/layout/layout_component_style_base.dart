// Core automatically generated
// lib/src/generated/layout/layout_component_style_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/component.dart';

abstract class LayoutComponentStyleBase extends Component {
  static const int typeKey = 420;
  @override
  int get coreType => LayoutComponentStyleBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {LayoutComponentStyleBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// GapHorizontal field with key 498.
  static const int gapHorizontalPropertyKey = 498;
  static const double gapHorizontalInitialValue = 0;
  double _gapHorizontal = gapHorizontalInitialValue;

  /// Horizontal gap between children in layout component
  double get gapHorizontal => _gapHorizontal;

  /// Change the [_gapHorizontal] field value.
  /// [gapHorizontalChanged] will be invoked only if the field's value has
  /// changed.
  set gapHorizontal(double value) {
    if (_gapHorizontal == value) {
      return;
    }
    double from = _gapHorizontal;
    _gapHorizontal = value;
    if (hasValidated) {
      gapHorizontalChanged(from, value);
    }
  }

  void gapHorizontalChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// GapVertical field with key 499.
  static const int gapVerticalPropertyKey = 499;
  static const double gapVerticalInitialValue = 0;
  double _gapVertical = gapVerticalInitialValue;

  /// Vertical gap between children in layout component
  double get gapVertical => _gapVertical;

  /// Change the [_gapVertical] field value.
  /// [gapVerticalChanged] will be invoked only if the field's value has
  /// changed.
  set gapVertical(double value) {
    if (_gapVertical == value) {
      return;
    }
    double from = _gapVertical;
    _gapVertical = value;
    if (hasValidated) {
      gapVerticalChanged(from, value);
    }
  }

  void gapVerticalChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// MaxWidth field with key 500.
  static const int maxWidthPropertyKey = 500;
  static const double maxWidthInitialValue = 0;
  double _maxWidth = maxWidthInitialValue;

  /// Max width of the item.
  double get maxWidth => _maxWidth;

  /// Change the [_maxWidth] field value.
  /// [maxWidthChanged] will be invoked only if the field's value has changed.
  set maxWidth(double value) {
    if (_maxWidth == value) {
      return;
    }
    double from = _maxWidth;
    _maxWidth = value;
    if (hasValidated) {
      maxWidthChanged(from, value);
    }
  }

  void maxWidthChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// MaxHeight field with key 501.
  static const int maxHeightPropertyKey = 501;
  static const double maxHeightInitialValue = 0;
  double _maxHeight = maxHeightInitialValue;

  /// Max height of the item.
  double get maxHeight => _maxHeight;

  /// Change the [_maxHeight] field value.
  /// [maxHeightChanged] will be invoked only if the field's value has changed.
  set maxHeight(double value) {
    if (_maxHeight == value) {
      return;
    }
    double from = _maxHeight;
    _maxHeight = value;
    if (hasValidated) {
      maxHeightChanged(from, value);
    }
  }

  void maxHeightChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// MinWidth field with key 502.
  static const int minWidthPropertyKey = 502;
  static const double minWidthInitialValue = 0;
  double _minWidth = minWidthInitialValue;

  /// Min width of the item.
  double get minWidth => _minWidth;

  /// Change the [_minWidth] field value.
  /// [minWidthChanged] will be invoked only if the field's value has changed.
  set minWidth(double value) {
    if (_minWidth == value) {
      return;
    }
    double from = _minWidth;
    _minWidth = value;
    if (hasValidated) {
      minWidthChanged(from, value);
    }
  }

  void minWidthChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// MinHeight field with key 503.
  static const int minHeightPropertyKey = 503;
  static const double minHeightInitialValue = 0;
  double _minHeight = minHeightInitialValue;

  /// Min height of the item.
  double get minHeight => _minHeight;

  /// Change the [_minHeight] field value.
  /// [minHeightChanged] will be invoked only if the field's value has changed.
  set minHeight(double value) {
    if (_minHeight == value) {
      return;
    }
    double from = _minHeight;
    _minHeight = value;
    if (hasValidated) {
      minHeightChanged(from, value);
    }
  }

  void minHeightChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// BorderLeft field with key 504.
  static const int borderLeftPropertyKey = 504;
  static const double borderLeftInitialValue = 0;
  double _borderLeft = borderLeftInitialValue;

  /// Left border value.
  double get borderLeft => _borderLeft;

  /// Change the [_borderLeft] field value.
  /// [borderLeftChanged] will be invoked only if the field's value has changed.
  set borderLeft(double value) {
    if (_borderLeft == value) {
      return;
    }
    double from = _borderLeft;
    _borderLeft = value;
    if (hasValidated) {
      borderLeftChanged(from, value);
    }
  }

  void borderLeftChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// BorderRight field with key 505.
  static const int borderRightPropertyKey = 505;
  static const double borderRightInitialValue = 0;
  double _borderRight = borderRightInitialValue;

  /// Right border value.
  double get borderRight => _borderRight;

  /// Change the [_borderRight] field value.
  /// [borderRightChanged] will be invoked only if the field's value has
  /// changed.
  set borderRight(double value) {
    if (_borderRight == value) {
      return;
    }
    double from = _borderRight;
    _borderRight = value;
    if (hasValidated) {
      borderRightChanged(from, value);
    }
  }

  void borderRightChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// BorderTop field with key 506.
  static const int borderTopPropertyKey = 506;
  static const double borderTopInitialValue = 0;
  double _borderTop = borderTopInitialValue;

  /// Top border value.
  double get borderTop => _borderTop;

  /// Change the [_borderTop] field value.
  /// [borderTopChanged] will be invoked only if the field's value has changed.
  set borderTop(double value) {
    if (_borderTop == value) {
      return;
    }
    double from = _borderTop;
    _borderTop = value;
    if (hasValidated) {
      borderTopChanged(from, value);
    }
  }

  void borderTopChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// BorderBottom field with key 507.
  static const int borderBottomPropertyKey = 507;
  static const double borderBottomInitialValue = 0;
  double _borderBottom = borderBottomInitialValue;

  /// Bottom border value.
  double get borderBottom => _borderBottom;

  /// Change the [_borderBottom] field value.
  /// [borderBottomChanged] will be invoked only if the field's value has
  /// changed.
  set borderBottom(double value) {
    if (_borderBottom == value) {
      return;
    }
    double from = _borderBottom;
    _borderBottom = value;
    if (hasValidated) {
      borderBottomChanged(from, value);
    }
  }

  void borderBottomChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// MarginLeft field with key 508.
  static const int marginLeftPropertyKey = 508;
  static const double marginLeftInitialValue = 0;
  double _marginLeft = marginLeftInitialValue;

  /// Left margin value.
  double get marginLeft => _marginLeft;

  /// Change the [_marginLeft] field value.
  /// [marginLeftChanged] will be invoked only if the field's value has changed.
  set marginLeft(double value) {
    if (_marginLeft == value) {
      return;
    }
    double from = _marginLeft;
    _marginLeft = value;
    if (hasValidated) {
      marginLeftChanged(from, value);
    }
  }

  void marginLeftChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// MarginRight field with key 509.
  static const int marginRightPropertyKey = 509;
  static const double marginRightInitialValue = 0;
  double _marginRight = marginRightInitialValue;

  /// Right margin value.
  double get marginRight => _marginRight;

  /// Change the [_marginRight] field value.
  /// [marginRightChanged] will be invoked only if the field's value has
  /// changed.
  set marginRight(double value) {
    if (_marginRight == value) {
      return;
    }
    double from = _marginRight;
    _marginRight = value;
    if (hasValidated) {
      marginRightChanged(from, value);
    }
  }

  void marginRightChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// MarginTop field with key 510.
  static const int marginTopPropertyKey = 510;
  static const double marginTopInitialValue = 0;
  double _marginTop = marginTopInitialValue;

  /// Top margin value.
  double get marginTop => _marginTop;

  /// Change the [_marginTop] field value.
  /// [marginTopChanged] will be invoked only if the field's value has changed.
  set marginTop(double value) {
    if (_marginTop == value) {
      return;
    }
    double from = _marginTop;
    _marginTop = value;
    if (hasValidated) {
      marginTopChanged(from, value);
    }
  }

  void marginTopChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// MarginBottom field with key 511.
  static const int marginBottomPropertyKey = 511;
  static const double marginBottomInitialValue = 0;
  double _marginBottom = marginBottomInitialValue;

  /// Bottom margin value.
  double get marginBottom => _marginBottom;

  /// Change the [_marginBottom] field value.
  /// [marginBottomChanged] will be invoked only if the field's value has
  /// changed.
  set marginBottom(double value) {
    if (_marginBottom == value) {
      return;
    }
    double from = _marginBottom;
    _marginBottom = value;
    if (hasValidated) {
      marginBottomChanged(from, value);
    }
  }

  void marginBottomChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// PaddingLeft field with key 512.
  static const int paddingLeftPropertyKey = 512;
  static const double paddingLeftInitialValue = 0;
  double _paddingLeft = paddingLeftInitialValue;

  /// Left padding value.
  double get paddingLeft => _paddingLeft;

  /// Change the [_paddingLeft] field value.
  /// [paddingLeftChanged] will be invoked only if the field's value has
  /// changed.
  set paddingLeft(double value) {
    if (_paddingLeft == value) {
      return;
    }
    double from = _paddingLeft;
    _paddingLeft = value;
    if (hasValidated) {
      paddingLeftChanged(from, value);
    }
  }

  void paddingLeftChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// PaddingRight field with key 513.
  static const int paddingRightPropertyKey = 513;
  static const double paddingRightInitialValue = 0;
  double _paddingRight = paddingRightInitialValue;

  /// Right padding value.
  double get paddingRight => _paddingRight;

  /// Change the [_paddingRight] field value.
  /// [paddingRightChanged] will be invoked only if the field's value has
  /// changed.
  set paddingRight(double value) {
    if (_paddingRight == value) {
      return;
    }
    double from = _paddingRight;
    _paddingRight = value;
    if (hasValidated) {
      paddingRightChanged(from, value);
    }
  }

  void paddingRightChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// PaddingTop field with key 514.
  static const int paddingTopPropertyKey = 514;
  static const double paddingTopInitialValue = 0;
  double _paddingTop = paddingTopInitialValue;

  /// Top padding value.
  double get paddingTop => _paddingTop;

  /// Change the [_paddingTop] field value.
  /// [paddingTopChanged] will be invoked only if the field's value has changed.
  set paddingTop(double value) {
    if (_paddingTop == value) {
      return;
    }
    double from = _paddingTop;
    _paddingTop = value;
    if (hasValidated) {
      paddingTopChanged(from, value);
    }
  }

  void paddingTopChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// PaddingBottom field with key 515.
  static const int paddingBottomPropertyKey = 515;
  static const double paddingBottomInitialValue = 0;
  double _paddingBottom = paddingBottomInitialValue;

  /// Bottom padding value.
  double get paddingBottom => _paddingBottom;

  /// Change the [_paddingBottom] field value.
  /// [paddingBottomChanged] will be invoked only if the field's value has
  /// changed.
  set paddingBottom(double value) {
    if (_paddingBottom == value) {
      return;
    }
    double from = _paddingBottom;
    _paddingBottom = value;
    if (hasValidated) {
      paddingBottomChanged(from, value);
    }
  }

  void paddingBottomChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// PositionLeft field with key 516.
  static const int positionLeftPropertyKey = 516;
  static const double positionLeftInitialValue = 0;
  double _positionLeft = positionLeftInitialValue;

  /// Left position value.
  double get positionLeft => _positionLeft;

  /// Change the [_positionLeft] field value.
  /// [positionLeftChanged] will be invoked only if the field's value has
  /// changed.
  set positionLeft(double value) {
    if (_positionLeft == value) {
      return;
    }
    double from = _positionLeft;
    _positionLeft = value;
    if (hasValidated) {
      positionLeftChanged(from, value);
    }
  }

  void positionLeftChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// PositionRight field with key 517.
  static const int positionRightPropertyKey = 517;
  static const double positionRightInitialValue = 0;
  double _positionRight = positionRightInitialValue;

  /// Right position value.
  double get positionRight => _positionRight;

  /// Change the [_positionRight] field value.
  /// [positionRightChanged] will be invoked only if the field's value has
  /// changed.
  set positionRight(double value) {
    if (_positionRight == value) {
      return;
    }
    double from = _positionRight;
    _positionRight = value;
    if (hasValidated) {
      positionRightChanged(from, value);
    }
  }

  void positionRightChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// PositionTop field with key 518.
  static const int positionTopPropertyKey = 518;
  static const double positionTopInitialValue = 0;
  double _positionTop = positionTopInitialValue;

  /// Top position value.
  double get positionTop => _positionTop;

  /// Change the [_positionTop] field value.
  /// [positionTopChanged] will be invoked only if the field's value has
  /// changed.
  set positionTop(double value) {
    if (_positionTop == value) {
      return;
    }
    double from = _positionTop;
    _positionTop = value;
    if (hasValidated) {
      positionTopChanged(from, value);
    }
  }

  void positionTopChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// PositionBottom field with key 519.
  static const int positionBottomPropertyKey = 519;
  static const double positionBottomInitialValue = 0;
  double _positionBottom = positionBottomInitialValue;

  /// Bottom position value.
  double get positionBottom => _positionBottom;

  /// Change the [_positionBottom] field value.
  /// [positionBottomChanged] will be invoked only if the field's value has
  /// changed.
  set positionBottom(double value) {
    if (_positionBottom == value) {
      return;
    }
    double from = _positionBottom;
    _positionBottom = value;
    if (hasValidated) {
      positionBottomChanged(from, value);
    }
  }

  void positionBottomChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Flex field with key 520.
  static const int flexPropertyKey = 520;
  static const double flexInitialValue = 0;
  double _flex = flexInitialValue;

  /// Flex value.
  double get flex => _flex;

  /// Change the [_flex] field value.
  /// [flexChanged] will be invoked only if the field's value has changed.
  set flex(double value) {
    if (_flex == value) {
      return;
    }
    double from = _flex;
    _flex = value;
    if (hasValidated) {
      flexChanged(from, value);
    }
  }

  void flexChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// FlexGrow field with key 521.
  static const int flexGrowPropertyKey = 521;
  static const double flexGrowInitialValue = 0;
  double _flexGrow = flexGrowInitialValue;

  /// Flex grow value.
  double get flexGrow => _flexGrow;

  /// Change the [_flexGrow] field value.
  /// [flexGrowChanged] will be invoked only if the field's value has changed.
  set flexGrow(double value) {
    if (_flexGrow == value) {
      return;
    }
    double from = _flexGrow;
    _flexGrow = value;
    if (hasValidated) {
      flexGrowChanged(from, value);
    }
  }

  void flexGrowChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// FlexShrink field with key 522.
  static const int flexShrinkPropertyKey = 522;
  static const double flexShrinkInitialValue = 1;
  double _flexShrink = flexShrinkInitialValue;

  /// Flex shrink value.
  double get flexShrink => _flexShrink;

  /// Change the [_flexShrink] field value.
  /// [flexShrinkChanged] will be invoked only if the field's value has changed.
  set flexShrink(double value) {
    if (_flexShrink == value) {
      return;
    }
    double from = _flexShrink;
    _flexShrink = value;
    if (hasValidated) {
      flexShrinkChanged(from, value);
    }
  }

  void flexShrinkChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// FlexBasis field with key 523.
  static const int flexBasisPropertyKey = 523;
  static const double flexBasisInitialValue = 1;
  double _flexBasis = flexBasisInitialValue;

  /// Flex basis value.
  double get flexBasis => _flexBasis;

  /// Change the [_flexBasis] field value.
  /// [flexBasisChanged] will be invoked only if the field's value has changed.
  set flexBasis(double value) {
    if (_flexBasis == value) {
      return;
    }
    double from = _flexBasis;
    _flexBasis = value;
    if (hasValidated) {
      flexBasisChanged(from, value);
    }
  }

  void flexBasisChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// AspectRatio field with key 524.
  static const int aspectRatioPropertyKey = 524;
  static const double aspectRatioInitialValue = 0;
  double _aspectRatio = aspectRatioInitialValue;

  /// Aspect ratio value.
  double get aspectRatio => _aspectRatio;

  /// Change the [_aspectRatio] field value.
  /// [aspectRatioChanged] will be invoked only if the field's value has
  /// changed.
  set aspectRatio(double value) {
    if (_aspectRatio == value) {
      return;
    }
    double from = _aspectRatio;
    _aspectRatio = value;
    if (hasValidated) {
      aspectRatioChanged(from, value);
    }
  }

  void aspectRatioChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// ScaleType field with key 546.
  static const int scaleTypePropertyKey = 546;
  static const int scaleTypeInitialValue = 0;
  int _scaleType = scaleTypeInitialValue;
  int get scaleType => _scaleType;

  /// Change the [_scaleType] field value.
  /// [scaleTypeChanged] will be invoked only if the field's value has changed.
  set scaleType(int value) {
    if (_scaleType == value) {
      return;
    }
    int from = _scaleType;
    _scaleType = value;
    if (hasValidated) {
      scaleTypeChanged(from, value);
    }
  }

  void scaleTypeChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// LayoutAlignmentType field with key 632.
  static const int layoutAlignmentTypePropertyKey = 632;
  static const int layoutAlignmentTypeInitialValue = 0;
  int _layoutAlignmentType = layoutAlignmentTypeInitialValue;
  int get layoutAlignmentType => _layoutAlignmentType;

  /// Change the [_layoutAlignmentType] field value.
  /// [layoutAlignmentTypeChanged] will be invoked only if the field's value has
  /// changed.
  set layoutAlignmentType(int value) {
    if (_layoutAlignmentType == value) {
      return;
    }
    int from = _layoutAlignmentType;
    _layoutAlignmentType = value;
    if (hasValidated) {
      layoutAlignmentTypeChanged(from, value);
    }
  }

  void layoutAlignmentTypeChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// AnimationStyleType field with key 589.
  static const int animationStyleTypePropertyKey = 589;
  static const int animationStyleTypeInitialValue = 0;
  int _animationStyleType = animationStyleTypeInitialValue;

  /// The type of animation none|custom|inherit applied to this layout.
  int get animationStyleType => _animationStyleType;

  /// Change the [_animationStyleType] field value.
  /// [animationStyleTypeChanged] will be invoked only if the field's value has
  /// changed.
  set animationStyleType(int value) {
    if (_animationStyleType == value) {
      return;
    }
    int from = _animationStyleType;
    _animationStyleType = value;
    if (hasValidated) {
      animationStyleTypeChanged(from, value);
    }
  }

  void animationStyleTypeChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// InterpolationType field with key 590.
  static const int interpolationTypePropertyKey = 590;
  static const int interpolationTypeInitialValue = 0;
  int _interpolationType = interpolationTypeInitialValue;

  /// The type of interpolation index in KeyframeInterpolation applied to this
  /// layout.
  int get interpolationType => _interpolationType;

  /// Change the [_interpolationType] field value.
  /// [interpolationTypeChanged] will be invoked only if the field's value has
  /// changed.
  set interpolationType(int value) {
    if (_interpolationType == value) {
      return;
    }
    int from = _interpolationType;
    _interpolationType = value;
    if (hasValidated) {
      interpolationTypeChanged(from, value);
    }
  }

  void interpolationTypeChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// InterpolatorId field with key 591.
  static const int interpolatorIdPropertyKey = 591;
  static const int interpolatorIdInitialValue = -1;
  int _interpolatorId = interpolatorIdInitialValue;

  /// The id of the custom interpolator used when interpolation is Cubic.
  int get interpolatorId => _interpolatorId;

  /// Change the [_interpolatorId] field value.
  /// [interpolatorIdChanged] will be invoked only if the field's value has
  /// changed.
  set interpolatorId(int value) {
    if (_interpolatorId == value) {
      return;
    }
    int from = _interpolatorId;
    _interpolatorId = value;
    if (hasValidated) {
      interpolatorIdChanged(from, value);
    }
  }

  void interpolatorIdChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// InterpolationTime field with key 592.
  static const int interpolationTimePropertyKey = 592;
  static const double interpolationTimeInitialValue = 0;
  double _interpolationTime = interpolationTimeInitialValue;

  /// The time over which the interpolator applies.
  double get interpolationTime => _interpolationTime;

  /// Change the [_interpolationTime] field value.
  /// [interpolationTimeChanged] will be invoked only if the field's value has
  /// changed.
  set interpolationTime(double value) {
    if (_interpolationTime == value) {
      return;
    }
    double from = _interpolationTime;
    _interpolationTime = value;
    if (hasValidated) {
      interpolationTimeChanged(from, value);
    }
  }

  void interpolationTimeChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// DisplayValue field with key 596.
  static const int displayValuePropertyKey = 596;
  static const int displayValueInitialValue = 0;
  int _displayValue = displayValueInitialValue;

  ///
  int get displayValue => _displayValue;

  /// Change the [_displayValue] field value.
  /// [displayValueChanged] will be invoked only if the field's value has
  /// changed.
  set displayValue(int value) {
    if (_displayValue == value) {
      return;
    }
    int from = _displayValue;
    _displayValue = value;
    if (hasValidated) {
      displayValueChanged(from, value);
    }
  }

  void displayValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// PositionTypeValue field with key 597.
  static const int positionTypeValuePropertyKey = 597;
  static const int positionTypeValueInitialValue = 1;
  int _positionTypeValue = positionTypeValueInitialValue;

  ///
  int get positionTypeValue => _positionTypeValue;

  /// Change the [_positionTypeValue] field value.
  /// [positionTypeValueChanged] will be invoked only if the field's value has
  /// changed.
  set positionTypeValue(int value) {
    if (_positionTypeValue == value) {
      return;
    }
    int from = _positionTypeValue;
    _positionTypeValue = value;
    if (hasValidated) {
      positionTypeValueChanged(from, value);
    }
  }

  void positionTypeValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// FlexDirectionValue field with key 598.
  static const int flexDirectionValuePropertyKey = 598;
  static const int flexDirectionValueInitialValue = 2;
  int _flexDirectionValue = flexDirectionValueInitialValue;

  /// Flex dir
  int get flexDirectionValue => _flexDirectionValue;

  /// Change the [_flexDirectionValue] field value.
  /// [flexDirectionValueChanged] will be invoked only if the field's value has
  /// changed.
  set flexDirectionValue(int value) {
    if (_flexDirectionValue == value) {
      return;
    }
    int from = _flexDirectionValue;
    _flexDirectionValue = value;
    if (hasValidated) {
      flexDirectionValueChanged(from, value);
    }
  }

  void flexDirectionValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// DirectionValue field with key 599.
  static const int directionValuePropertyKey = 599;
  static const int directionValueInitialValue = 0;
  int _directionValue = directionValueInitialValue;

  ///
  int get directionValue => _directionValue;

  /// Change the [_directionValue] field value.
  /// [directionValueChanged] will be invoked only if the field's value has
  /// changed.
  set directionValue(int value) {
    if (_directionValue == value) {
      return;
    }
    int from = _directionValue;
    _directionValue = value;
    if (hasValidated) {
      directionValueChanged(from, value);
    }
  }

  void directionValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// AlignContentValue field with key 600.
  static const int alignContentValuePropertyKey = 600;
  static const int alignContentValueInitialValue = 0;
  int _alignContentValue = alignContentValueInitialValue;

  ///
  int get alignContentValue => _alignContentValue;

  /// Change the [_alignContentValue] field value.
  /// [alignContentValueChanged] will be invoked only if the field's value has
  /// changed.
  set alignContentValue(int value) {
    if (_alignContentValue == value) {
      return;
    }
    int from = _alignContentValue;
    _alignContentValue = value;
    if (hasValidated) {
      alignContentValueChanged(from, value);
    }
  }

  void alignContentValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// AlignItemsValue field with key 601.
  static const int alignItemsValuePropertyKey = 601;
  static const int alignItemsValueInitialValue = 1;
  int _alignItemsValue = alignItemsValueInitialValue;

  ///
  int get alignItemsValue => _alignItemsValue;

  /// Change the [_alignItemsValue] field value.
  /// [alignItemsValueChanged] will be invoked only if the field's value has
  /// changed.
  set alignItemsValue(int value) {
    if (_alignItemsValue == value) {
      return;
    }
    int from = _alignItemsValue;
    _alignItemsValue = value;
    if (hasValidated) {
      alignItemsValueChanged(from, value);
    }
  }

  void alignItemsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// AlignSelfValue field with key 602.
  static const int alignSelfValuePropertyKey = 602;
  static const int alignSelfValueInitialValue = 0;
  int _alignSelfValue = alignSelfValueInitialValue;

  ///
  int get alignSelfValue => _alignSelfValue;

  /// Change the [_alignSelfValue] field value.
  /// [alignSelfValueChanged] will be invoked only if the field's value has
  /// changed.
  set alignSelfValue(int value) {
    if (_alignSelfValue == value) {
      return;
    }
    int from = _alignSelfValue;
    _alignSelfValue = value;
    if (hasValidated) {
      alignSelfValueChanged(from, value);
    }
  }

  void alignSelfValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// JustifyContentValue field with key 603.
  static const int justifyContentValuePropertyKey = 603;
  static const int justifyContentValueInitialValue = 0;
  int _justifyContentValue = justifyContentValueInitialValue;

  ///
  int get justifyContentValue => _justifyContentValue;

  /// Change the [_justifyContentValue] field value.
  /// [justifyContentValueChanged] will be invoked only if the field's value has
  /// changed.
  set justifyContentValue(int value) {
    if (_justifyContentValue == value) {
      return;
    }
    int from = _justifyContentValue;
    _justifyContentValue = value;
    if (hasValidated) {
      justifyContentValueChanged(from, value);
    }
  }

  void justifyContentValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// FlexWrapValue field with key 604.
  static const int flexWrapValuePropertyKey = 604;
  static const int flexWrapValueInitialValue = 0;
  int _flexWrapValue = flexWrapValueInitialValue;

  ///
  int get flexWrapValue => _flexWrapValue;

  /// Change the [_flexWrapValue] field value.
  /// [flexWrapValueChanged] will be invoked only if the field's value has
  /// changed.
  set flexWrapValue(int value) {
    if (_flexWrapValue == value) {
      return;
    }
    int from = _flexWrapValue;
    _flexWrapValue = value;
    if (hasValidated) {
      flexWrapValueChanged(from, value);
    }
  }

  void flexWrapValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// OverflowValue field with key 605.
  static const int overflowValuePropertyKey = 605;
  static const int overflowValueInitialValue = 0;
  int _overflowValue = overflowValueInitialValue;

  ///
  int get overflowValue => _overflowValue;

  /// Change the [_overflowValue] field value.
  /// [overflowValueChanged] will be invoked only if the field's value has
  /// changed.
  set overflowValue(int value) {
    if (_overflowValue == value) {
      return;
    }
    int from = _overflowValue;
    _overflowValue = value;
    if (hasValidated) {
      overflowValueChanged(from, value);
    }
  }

  void overflowValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// IntrinsicallySizedValue field with key 606.
  static const int intrinsicallySizedValuePropertyKey = 606;
  static const bool intrinsicallySizedValueInitialValue = false;
  bool _intrinsicallySizedValue = intrinsicallySizedValueInitialValue;

  ///
  bool get intrinsicallySizedValue => _intrinsicallySizedValue;

  /// Change the [_intrinsicallySizedValue] field value.
  /// [intrinsicallySizedValueChanged] will be invoked only if the field's value
  /// has changed.
  set intrinsicallySizedValue(bool value) {
    if (_intrinsicallySizedValue == value) {
      return;
    }
    bool from = _intrinsicallySizedValue;
    _intrinsicallySizedValue = value;
    if (hasValidated) {
      intrinsicallySizedValueChanged(from, value);
    }
  }

  void intrinsicallySizedValueChanged(bool from, bool to);

  /// --------------------------------------------------------------------------
  /// WidthUnitsValue field with key 607.
  static const int widthUnitsValuePropertyKey = 607;
  static const int widthUnitsValueInitialValue = 1;
  int _widthUnitsValue = widthUnitsValueInitialValue;

  ///
  int get widthUnitsValue => _widthUnitsValue;

  /// Change the [_widthUnitsValue] field value.
  /// [widthUnitsValueChanged] will be invoked only if the field's value has
  /// changed.
  set widthUnitsValue(int value) {
    if (_widthUnitsValue == value) {
      return;
    }
    int from = _widthUnitsValue;
    _widthUnitsValue = value;
    if (hasValidated) {
      widthUnitsValueChanged(from, value);
    }
  }

  void widthUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// HeightUnitsValue field with key 608.
  static const int heightUnitsValuePropertyKey = 608;
  static const int heightUnitsValueInitialValue = 1;
  int _heightUnitsValue = heightUnitsValueInitialValue;

  ///
  int get heightUnitsValue => _heightUnitsValue;

  /// Change the [_heightUnitsValue] field value.
  /// [heightUnitsValueChanged] will be invoked only if the field's value has
  /// changed.
  set heightUnitsValue(int value) {
    if (_heightUnitsValue == value) {
      return;
    }
    int from = _heightUnitsValue;
    _heightUnitsValue = value;
    if (hasValidated) {
      heightUnitsValueChanged(from, value);
    }
  }

  void heightUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// BorderLeftUnitsValue field with key 609.
  static const int borderLeftUnitsValuePropertyKey = 609;
  static const int borderLeftUnitsValueInitialValue = 0;
  int _borderLeftUnitsValue = borderLeftUnitsValueInitialValue;

  ///
  int get borderLeftUnitsValue => _borderLeftUnitsValue;

  /// Change the [_borderLeftUnitsValue] field value.
  /// [borderLeftUnitsValueChanged] will be invoked only if the field's value
  /// has changed.
  set borderLeftUnitsValue(int value) {
    if (_borderLeftUnitsValue == value) {
      return;
    }
    int from = _borderLeftUnitsValue;
    _borderLeftUnitsValue = value;
    if (hasValidated) {
      borderLeftUnitsValueChanged(from, value);
    }
  }

  void borderLeftUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// BorderRightUnitsValue field with key 610.
  static const int borderRightUnitsValuePropertyKey = 610;
  static const int borderRightUnitsValueInitialValue = 0;
  int _borderRightUnitsValue = borderRightUnitsValueInitialValue;

  ///
  int get borderRightUnitsValue => _borderRightUnitsValue;

  /// Change the [_borderRightUnitsValue] field value.
  /// [borderRightUnitsValueChanged] will be invoked only if the field's value
  /// has changed.
  set borderRightUnitsValue(int value) {
    if (_borderRightUnitsValue == value) {
      return;
    }
    int from = _borderRightUnitsValue;
    _borderRightUnitsValue = value;
    if (hasValidated) {
      borderRightUnitsValueChanged(from, value);
    }
  }

  void borderRightUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// BorderTopUnitsValue field with key 611.
  static const int borderTopUnitsValuePropertyKey = 611;
  static const int borderTopUnitsValueInitialValue = 0;
  int _borderTopUnitsValue = borderTopUnitsValueInitialValue;

  ///
  int get borderTopUnitsValue => _borderTopUnitsValue;

  /// Change the [_borderTopUnitsValue] field value.
  /// [borderTopUnitsValueChanged] will be invoked only if the field's value has
  /// changed.
  set borderTopUnitsValue(int value) {
    if (_borderTopUnitsValue == value) {
      return;
    }
    int from = _borderTopUnitsValue;
    _borderTopUnitsValue = value;
    if (hasValidated) {
      borderTopUnitsValueChanged(from, value);
    }
  }

  void borderTopUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// BorderBottomUnitsValue field with key 612.
  static const int borderBottomUnitsValuePropertyKey = 612;
  static const int borderBottomUnitsValueInitialValue = 0;
  int _borderBottomUnitsValue = borderBottomUnitsValueInitialValue;

  ///
  int get borderBottomUnitsValue => _borderBottomUnitsValue;

  /// Change the [_borderBottomUnitsValue] field value.
  /// [borderBottomUnitsValueChanged] will be invoked only if the field's value
  /// has changed.
  set borderBottomUnitsValue(int value) {
    if (_borderBottomUnitsValue == value) {
      return;
    }
    int from = _borderBottomUnitsValue;
    _borderBottomUnitsValue = value;
    if (hasValidated) {
      borderBottomUnitsValueChanged(from, value);
    }
  }

  void borderBottomUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// MarginLeftUnitsValue field with key 613.
  static const int marginLeftUnitsValuePropertyKey = 613;
  static const int marginLeftUnitsValueInitialValue = 0;
  int _marginLeftUnitsValue = marginLeftUnitsValueInitialValue;

  ///
  int get marginLeftUnitsValue => _marginLeftUnitsValue;

  /// Change the [_marginLeftUnitsValue] field value.
  /// [marginLeftUnitsValueChanged] will be invoked only if the field's value
  /// has changed.
  set marginLeftUnitsValue(int value) {
    if (_marginLeftUnitsValue == value) {
      return;
    }
    int from = _marginLeftUnitsValue;
    _marginLeftUnitsValue = value;
    if (hasValidated) {
      marginLeftUnitsValueChanged(from, value);
    }
  }

  void marginLeftUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// MarginRightUnitsValue field with key 614.
  static const int marginRightUnitsValuePropertyKey = 614;
  static const int marginRightUnitsValueInitialValue = 0;
  int _marginRightUnitsValue = marginRightUnitsValueInitialValue;

  ///
  int get marginRightUnitsValue => _marginRightUnitsValue;

  /// Change the [_marginRightUnitsValue] field value.
  /// [marginRightUnitsValueChanged] will be invoked only if the field's value
  /// has changed.
  set marginRightUnitsValue(int value) {
    if (_marginRightUnitsValue == value) {
      return;
    }
    int from = _marginRightUnitsValue;
    _marginRightUnitsValue = value;
    if (hasValidated) {
      marginRightUnitsValueChanged(from, value);
    }
  }

  void marginRightUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// MarginTopUnitsValue field with key 615.
  static const int marginTopUnitsValuePropertyKey = 615;
  static const int marginTopUnitsValueInitialValue = 0;
  int _marginTopUnitsValue = marginTopUnitsValueInitialValue;

  ///
  int get marginTopUnitsValue => _marginTopUnitsValue;

  /// Change the [_marginTopUnitsValue] field value.
  /// [marginTopUnitsValueChanged] will be invoked only if the field's value has
  /// changed.
  set marginTopUnitsValue(int value) {
    if (_marginTopUnitsValue == value) {
      return;
    }
    int from = _marginTopUnitsValue;
    _marginTopUnitsValue = value;
    if (hasValidated) {
      marginTopUnitsValueChanged(from, value);
    }
  }

  void marginTopUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// MarginBottomUnitsValue field with key 616.
  static const int marginBottomUnitsValuePropertyKey = 616;
  static const int marginBottomUnitsValueInitialValue = 0;
  int _marginBottomUnitsValue = marginBottomUnitsValueInitialValue;

  ///
  int get marginBottomUnitsValue => _marginBottomUnitsValue;

  /// Change the [_marginBottomUnitsValue] field value.
  /// [marginBottomUnitsValueChanged] will be invoked only if the field's value
  /// has changed.
  set marginBottomUnitsValue(int value) {
    if (_marginBottomUnitsValue == value) {
      return;
    }
    int from = _marginBottomUnitsValue;
    _marginBottomUnitsValue = value;
    if (hasValidated) {
      marginBottomUnitsValueChanged(from, value);
    }
  }

  void marginBottomUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// PaddingLeftUnitsValue field with key 617.
  static const int paddingLeftUnitsValuePropertyKey = 617;
  static const int paddingLeftUnitsValueInitialValue = 0;
  int _paddingLeftUnitsValue = paddingLeftUnitsValueInitialValue;

  ///
  int get paddingLeftUnitsValue => _paddingLeftUnitsValue;

  /// Change the [_paddingLeftUnitsValue] field value.
  /// [paddingLeftUnitsValueChanged] will be invoked only if the field's value
  /// has changed.
  set paddingLeftUnitsValue(int value) {
    if (_paddingLeftUnitsValue == value) {
      return;
    }
    int from = _paddingLeftUnitsValue;
    _paddingLeftUnitsValue = value;
    if (hasValidated) {
      paddingLeftUnitsValueChanged(from, value);
    }
  }

  void paddingLeftUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// PaddingRightUnitsValue field with key 618.
  static const int paddingRightUnitsValuePropertyKey = 618;
  static const int paddingRightUnitsValueInitialValue = 0;
  int _paddingRightUnitsValue = paddingRightUnitsValueInitialValue;

  ///
  int get paddingRightUnitsValue => _paddingRightUnitsValue;

  /// Change the [_paddingRightUnitsValue] field value.
  /// [paddingRightUnitsValueChanged] will be invoked only if the field's value
  /// has changed.
  set paddingRightUnitsValue(int value) {
    if (_paddingRightUnitsValue == value) {
      return;
    }
    int from = _paddingRightUnitsValue;
    _paddingRightUnitsValue = value;
    if (hasValidated) {
      paddingRightUnitsValueChanged(from, value);
    }
  }

  void paddingRightUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// PaddingTopUnitsValue field with key 619.
  static const int paddingTopUnitsValuePropertyKey = 619;
  static const int paddingTopUnitsValueInitialValue = 0;
  int _paddingTopUnitsValue = paddingTopUnitsValueInitialValue;

  ///
  int get paddingTopUnitsValue => _paddingTopUnitsValue;

  /// Change the [_paddingTopUnitsValue] field value.
  /// [paddingTopUnitsValueChanged] will be invoked only if the field's value
  /// has changed.
  set paddingTopUnitsValue(int value) {
    if (_paddingTopUnitsValue == value) {
      return;
    }
    int from = _paddingTopUnitsValue;
    _paddingTopUnitsValue = value;
    if (hasValidated) {
      paddingTopUnitsValueChanged(from, value);
    }
  }

  void paddingTopUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// PaddingBottomUnitsValue field with key 620.
  static const int paddingBottomUnitsValuePropertyKey = 620;
  static const int paddingBottomUnitsValueInitialValue = 0;
  int _paddingBottomUnitsValue = paddingBottomUnitsValueInitialValue;

  ///
  int get paddingBottomUnitsValue => _paddingBottomUnitsValue;

  /// Change the [_paddingBottomUnitsValue] field value.
  /// [paddingBottomUnitsValueChanged] will be invoked only if the field's value
  /// has changed.
  set paddingBottomUnitsValue(int value) {
    if (_paddingBottomUnitsValue == value) {
      return;
    }
    int from = _paddingBottomUnitsValue;
    _paddingBottomUnitsValue = value;
    if (hasValidated) {
      paddingBottomUnitsValueChanged(from, value);
    }
  }

  void paddingBottomUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// PositionLeftUnitsValue field with key 621.
  static const int positionLeftUnitsValuePropertyKey = 621;
  static const int positionLeftUnitsValueInitialValue = 0;
  int _positionLeftUnitsValue = positionLeftUnitsValueInitialValue;

  ///
  int get positionLeftUnitsValue => _positionLeftUnitsValue;

  /// Change the [_positionLeftUnitsValue] field value.
  /// [positionLeftUnitsValueChanged] will be invoked only if the field's value
  /// has changed.
  set positionLeftUnitsValue(int value) {
    if (_positionLeftUnitsValue == value) {
      return;
    }
    int from = _positionLeftUnitsValue;
    _positionLeftUnitsValue = value;
    if (hasValidated) {
      positionLeftUnitsValueChanged(from, value);
    }
  }

  void positionLeftUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// PositionRightUnitsValue field with key 622.
  static const int positionRightUnitsValuePropertyKey = 622;
  static const int positionRightUnitsValueInitialValue = 0;
  int _positionRightUnitsValue = positionRightUnitsValueInitialValue;

  ///
  int get positionRightUnitsValue => _positionRightUnitsValue;

  /// Change the [_positionRightUnitsValue] field value.
  /// [positionRightUnitsValueChanged] will be invoked only if the field's value
  /// has changed.
  set positionRightUnitsValue(int value) {
    if (_positionRightUnitsValue == value) {
      return;
    }
    int from = _positionRightUnitsValue;
    _positionRightUnitsValue = value;
    if (hasValidated) {
      positionRightUnitsValueChanged(from, value);
    }
  }

  void positionRightUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// PositionTopUnitsValue field with key 623.
  static const int positionTopUnitsValuePropertyKey = 623;
  static const int positionTopUnitsValueInitialValue = 0;
  int _positionTopUnitsValue = positionTopUnitsValueInitialValue;

  ///
  int get positionTopUnitsValue => _positionTopUnitsValue;

  /// Change the [_positionTopUnitsValue] field value.
  /// [positionTopUnitsValueChanged] will be invoked only if the field's value
  /// has changed.
  set positionTopUnitsValue(int value) {
    if (_positionTopUnitsValue == value) {
      return;
    }
    int from = _positionTopUnitsValue;
    _positionTopUnitsValue = value;
    if (hasValidated) {
      positionTopUnitsValueChanged(from, value);
    }
  }

  void positionTopUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// PositionBottomUnitsValue field with key 624.
  static const int positionBottomUnitsValuePropertyKey = 624;
  static const int positionBottomUnitsValueInitialValue = 0;
  int _positionBottomUnitsValue = positionBottomUnitsValueInitialValue;

  ///
  int get positionBottomUnitsValue => _positionBottomUnitsValue;

  /// Change the [_positionBottomUnitsValue] field value.
  /// [positionBottomUnitsValueChanged] will be invoked only if the field's
  /// value has changed.
  set positionBottomUnitsValue(int value) {
    if (_positionBottomUnitsValue == value) {
      return;
    }
    int from = _positionBottomUnitsValue;
    _positionBottomUnitsValue = value;
    if (hasValidated) {
      positionBottomUnitsValueChanged(from, value);
    }
  }

  void positionBottomUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// GapHorizontalUnitsValue field with key 625.
  static const int gapHorizontalUnitsValuePropertyKey = 625;
  static const int gapHorizontalUnitsValueInitialValue = 0;
  int _gapHorizontalUnitsValue = gapHorizontalUnitsValueInitialValue;

  ///
  int get gapHorizontalUnitsValue => _gapHorizontalUnitsValue;

  /// Change the [_gapHorizontalUnitsValue] field value.
  /// [gapHorizontalUnitsValueChanged] will be invoked only if the field's value
  /// has changed.
  set gapHorizontalUnitsValue(int value) {
    if (_gapHorizontalUnitsValue == value) {
      return;
    }
    int from = _gapHorizontalUnitsValue;
    _gapHorizontalUnitsValue = value;
    if (hasValidated) {
      gapHorizontalUnitsValueChanged(from, value);
    }
  }

  void gapHorizontalUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// GapVerticalUnitsValue field with key 626.
  static const int gapVerticalUnitsValuePropertyKey = 626;
  static const int gapVerticalUnitsValueInitialValue = 0;
  int _gapVerticalUnitsValue = gapVerticalUnitsValueInitialValue;

  ///
  int get gapVerticalUnitsValue => _gapVerticalUnitsValue;

  /// Change the [_gapVerticalUnitsValue] field value.
  /// [gapVerticalUnitsValueChanged] will be invoked only if the field's value
  /// has changed.
  set gapVerticalUnitsValue(int value) {
    if (_gapVerticalUnitsValue == value) {
      return;
    }
    int from = _gapVerticalUnitsValue;
    _gapVerticalUnitsValue = value;
    if (hasValidated) {
      gapVerticalUnitsValueChanged(from, value);
    }
  }

  void gapVerticalUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// MinWidthUnitsValue field with key 627.
  static const int minWidthUnitsValuePropertyKey = 627;
  static const int minWidthUnitsValueInitialValue = 0;
  int _minWidthUnitsValue = minWidthUnitsValueInitialValue;

  ///
  int get minWidthUnitsValue => _minWidthUnitsValue;

  /// Change the [_minWidthUnitsValue] field value.
  /// [minWidthUnitsValueChanged] will be invoked only if the field's value has
  /// changed.
  set minWidthUnitsValue(int value) {
    if (_minWidthUnitsValue == value) {
      return;
    }
    int from = _minWidthUnitsValue;
    _minWidthUnitsValue = value;
    if (hasValidated) {
      minWidthUnitsValueChanged(from, value);
    }
  }

  void minWidthUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// MinHeightUnitsValue field with key 628.
  static const int minHeightUnitsValuePropertyKey = 628;
  static const int minHeightUnitsValueInitialValue = 0;
  int _minHeightUnitsValue = minHeightUnitsValueInitialValue;

  ///
  int get minHeightUnitsValue => _minHeightUnitsValue;

  /// Change the [_minHeightUnitsValue] field value.
  /// [minHeightUnitsValueChanged] will be invoked only if the field's value has
  /// changed.
  set minHeightUnitsValue(int value) {
    if (_minHeightUnitsValue == value) {
      return;
    }
    int from = _minHeightUnitsValue;
    _minHeightUnitsValue = value;
    if (hasValidated) {
      minHeightUnitsValueChanged(from, value);
    }
  }

  void minHeightUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// MaxWidthUnitsValue field with key 629.
  static const int maxWidthUnitsValuePropertyKey = 629;
  static const int maxWidthUnitsValueInitialValue = 0;
  int _maxWidthUnitsValue = maxWidthUnitsValueInitialValue;

  ///
  int get maxWidthUnitsValue => _maxWidthUnitsValue;

  /// Change the [_maxWidthUnitsValue] field value.
  /// [maxWidthUnitsValueChanged] will be invoked only if the field's value has
  /// changed.
  set maxWidthUnitsValue(int value) {
    if (_maxWidthUnitsValue == value) {
      return;
    }
    int from = _maxWidthUnitsValue;
    _maxWidthUnitsValue = value;
    if (hasValidated) {
      maxWidthUnitsValueChanged(from, value);
    }
  }

  void maxWidthUnitsValueChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// MaxHeightUnitsValue field with key 630.
  static const int maxHeightUnitsValuePropertyKey = 630;
  static const int maxHeightUnitsValueInitialValue = 0;
  int _maxHeightUnitsValue = maxHeightUnitsValueInitialValue;

  ///
  int get maxHeightUnitsValue => _maxHeightUnitsValue;

  /// Change the [_maxHeightUnitsValue] field value.
  /// [maxHeightUnitsValueChanged] will be invoked only if the field's value has
  /// changed.
  set maxHeightUnitsValue(int value) {
    if (_maxHeightUnitsValue == value) {
      return;
    }
    int from = _maxHeightUnitsValue;
    _maxHeightUnitsValue = value;
    if (hasValidated) {
      maxHeightUnitsValueChanged(from, value);
    }
  }

  void maxHeightUnitsValueChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is LayoutComponentStyleBase) {
      _gapHorizontal = source._gapHorizontal;
      _gapVertical = source._gapVertical;
      _maxWidth = source._maxWidth;
      _maxHeight = source._maxHeight;
      _minWidth = source._minWidth;
      _minHeight = source._minHeight;
      _borderLeft = source._borderLeft;
      _borderRight = source._borderRight;
      _borderTop = source._borderTop;
      _borderBottom = source._borderBottom;
      _marginLeft = source._marginLeft;
      _marginRight = source._marginRight;
      _marginTop = source._marginTop;
      _marginBottom = source._marginBottom;
      _paddingLeft = source._paddingLeft;
      _paddingRight = source._paddingRight;
      _paddingTop = source._paddingTop;
      _paddingBottom = source._paddingBottom;
      _positionLeft = source._positionLeft;
      _positionRight = source._positionRight;
      _positionTop = source._positionTop;
      _positionBottom = source._positionBottom;
      _flex = source._flex;
      _flexGrow = source._flexGrow;
      _flexShrink = source._flexShrink;
      _flexBasis = source._flexBasis;
      _aspectRatio = source._aspectRatio;
      _scaleType = source._scaleType;
      _layoutAlignmentType = source._layoutAlignmentType;
      _animationStyleType = source._animationStyleType;
      _interpolationType = source._interpolationType;
      _interpolatorId = source._interpolatorId;
      _interpolationTime = source._interpolationTime;
      _displayValue = source._displayValue;
      _positionTypeValue = source._positionTypeValue;
      _flexDirectionValue = source._flexDirectionValue;
      _directionValue = source._directionValue;
      _alignContentValue = source._alignContentValue;
      _alignItemsValue = source._alignItemsValue;
      _alignSelfValue = source._alignSelfValue;
      _justifyContentValue = source._justifyContentValue;
      _flexWrapValue = source._flexWrapValue;
      _overflowValue = source._overflowValue;
      _intrinsicallySizedValue = source._intrinsicallySizedValue;
      _widthUnitsValue = source._widthUnitsValue;
      _heightUnitsValue = source._heightUnitsValue;
      _borderLeftUnitsValue = source._borderLeftUnitsValue;
      _borderRightUnitsValue = source._borderRightUnitsValue;
      _borderTopUnitsValue = source._borderTopUnitsValue;
      _borderBottomUnitsValue = source._borderBottomUnitsValue;
      _marginLeftUnitsValue = source._marginLeftUnitsValue;
      _marginRightUnitsValue = source._marginRightUnitsValue;
      _marginTopUnitsValue = source._marginTopUnitsValue;
      _marginBottomUnitsValue = source._marginBottomUnitsValue;
      _paddingLeftUnitsValue = source._paddingLeftUnitsValue;
      _paddingRightUnitsValue = source._paddingRightUnitsValue;
      _paddingTopUnitsValue = source._paddingTopUnitsValue;
      _paddingBottomUnitsValue = source._paddingBottomUnitsValue;
      _positionLeftUnitsValue = source._positionLeftUnitsValue;
      _positionRightUnitsValue = source._positionRightUnitsValue;
      _positionTopUnitsValue = source._positionTopUnitsValue;
      _positionBottomUnitsValue = source._positionBottomUnitsValue;
      _gapHorizontalUnitsValue = source._gapHorizontalUnitsValue;
      _gapVerticalUnitsValue = source._gapVerticalUnitsValue;
      _minWidthUnitsValue = source._minWidthUnitsValue;
      _minHeightUnitsValue = source._minHeightUnitsValue;
      _maxWidthUnitsValue = source._maxWidthUnitsValue;
      _maxHeightUnitsValue = source._maxHeightUnitsValue;
    }
  }
}
