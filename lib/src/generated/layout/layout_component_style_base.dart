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
  /// LayoutFlags0 field with key 495.
  static const int layoutFlags0PropertyKey = 495;
  static const int layoutFlags0InitialValue = 0x5000412;
  int _layoutFlags0 = layoutFlags0InitialValue;

  /// First BitFlags for layout styles.
  int get layoutFlags0 => _layoutFlags0;

  /// Change the [_layoutFlags0] field value.
  /// [layoutFlags0Changed] will be invoked only if the field's value has
  /// changed.
  set layoutFlags0(int value) {
    if (_layoutFlags0 == value) {
      return;
    }
    int from = _layoutFlags0;
    _layoutFlags0 = value;
    if (hasValidated) {
      layoutFlags0Changed(from, value);
    }
  }

  void layoutFlags0Changed(int from, int to);

  /// --------------------------------------------------------------------------
  /// LayoutFlags1 field with key 496.
  static const int layoutFlags1PropertyKey = 496;
  static const int layoutFlags1InitialValue = 0x00;
  int _layoutFlags1 = layoutFlags1InitialValue;

  /// Second BitFlags for layout styles.
  int get layoutFlags1 => _layoutFlags1;

  /// Change the [_layoutFlags1] field value.
  /// [layoutFlags1Changed] will be invoked only if the field's value has
  /// changed.
  set layoutFlags1(int value) {
    if (_layoutFlags1 == value) {
      return;
    }
    int from = _layoutFlags1;
    _layoutFlags1 = value;
    if (hasValidated) {
      layoutFlags1Changed(from, value);
    }
  }

  void layoutFlags1Changed(int from, int to);

  /// --------------------------------------------------------------------------
  /// LayoutFlags2 field with key 497.
  static const int layoutFlags2PropertyKey = 497;
  static const int layoutFlags2InitialValue = 0x00;
  int _layoutFlags2 = layoutFlags2InitialValue;

  /// Third BitFlags for layout styles.
  int get layoutFlags2 => _layoutFlags2;

  /// Change the [_layoutFlags2] field value.
  /// [layoutFlags2Changed] will be invoked only if the field's value has
  /// changed.
  set layoutFlags2(int value) {
    if (_layoutFlags2 == value) {
      return;
    }
    int from = _layoutFlags2;
    _layoutFlags2 = value;
    if (hasValidated) {
      layoutFlags2Changed(from, value);
    }
  }

  void layoutFlags2Changed(int from, int to);

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

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is LayoutComponentStyleBase) {
      _layoutFlags0 = source._layoutFlags0;
      _layoutFlags1 = source._layoutFlags1;
      _layoutFlags2 = source._layoutFlags2;
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
      _animationStyleType = source._animationStyleType;
      _interpolationType = source._interpolationType;
      _interpolatorId = source._interpolatorId;
      _interpolationTime = source._interpolationTime;
    }
  }
}
