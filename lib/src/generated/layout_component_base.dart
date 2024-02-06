// Core automatically generated lib/src/generated/layout_component_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/world_transform_component.dart';

abstract class LayoutComponentBase extends WorldTransformComponent {
  static const int typeKey = 409;
  @override
  int get coreType => LayoutComponentBase.typeKey;
  @override
  Set<int> get coreTypes => {
        LayoutComponentBase.typeKey,
        WorldTransformComponentBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// LayoutFlags0 field with key 196.
  static const int layoutFlags0PropertyKey = 196;
  static const int layoutFlags0InitialValue = 0xAA001;
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
  /// LayoutFlags1 field with key 415.
  static const int layoutFlags1PropertyKey = 415;
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
  /// LayoutFlags2 field with key 441.
  static const int layoutFlags2PropertyKey = 441;
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
  /// GapWidth field with key 416.
  static const int gapWidthPropertyKey = 416;
  static const double gapWidthInitialValue = 0;
  double _gapWidth = gapWidthInitialValue;

  /// How large should the gaps between items in a grid or flex container be?
  double get gapWidth => _gapWidth;

  /// Change the [_gapWidth] field value.
  /// [gapWidthChanged] will be invoked only if the field's value has changed.
  set gapWidth(double value) {
    if (_gapWidth == value) {
      return;
    }
    double from = _gapWidth;
    _gapWidth = value;
    if (hasValidated) {
      gapWidthChanged(from, value);
    }
  }

  void gapWidthChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// GapHeight field with key 417.
  static const int gapHeightPropertyKey = 417;
  static const double gapHeightInitialValue = 0;
  double _gapHeight = gapHeightInitialValue;

  /// How large should the gaps between items in a grid or flex container be?
  double get gapHeight => _gapHeight;

  /// Change the [_gapHeight] field value.
  /// [gapHeightChanged] will be invoked only if the field's value has changed.
  set gapHeight(double value) {
    if (_gapHeight == value) {
      return;
    }
    double from = _gapHeight;
    _gapHeight = value;
    if (hasValidated) {
      gapHeightChanged(from, value);
    }
  }

  void gapHeightChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Width field with key 7.
  static const int widthPropertyKey = 7;
  static const double widthInitialValue = 0;
  double _width = widthInitialValue;

  /// Initial width of the item.
  double get width => _width;

  /// Change the [_width] field value.
  /// [widthChanged] will be invoked only if the field's value has changed.
  set width(double value) {
    if (_width == value) {
      return;
    }
    double from = _width;
    _width = value;
    if (hasValidated) {
      widthChanged(from, value);
    }
  }

  void widthChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Height field with key 8.
  static const int heightPropertyKey = 8;
  static const double heightInitialValue = 0;
  double _height = heightInitialValue;

  /// Initial height of the item.
  double get height => _height;

  /// Change the [_height] field value.
  /// [heightChanged] will be invoked only if the field's value has changed.
  set height(double value) {
    if (_height == value) {
      return;
    }
    double from = _height;
    _height = value;
    if (hasValidated) {
      heightChanged(from, value);
    }
  }

  void heightChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// MaxWidth field with key 418.
  static const int maxWidthPropertyKey = 418;
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
  /// MaxHeight field with key 419.
  static const int maxHeightPropertyKey = 419;
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
  /// MinWidth field with key 447.
  static const int minWidthPropertyKey = 447;
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
  /// MinHeight field with key 448.
  static const int minHeightPropertyKey = 448;
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
  /// MarginLeft field with key 454.
  static const int marginLeftPropertyKey = 454;
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
  /// MarginRight field with key 455.
  static const int marginRightPropertyKey = 455;
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
  /// MarginTop field with key 449.
  static const int marginTopPropertyKey = 449;
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
  /// MarginBottom field with key 456.
  static const int marginBottomPropertyKey = 456;
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
  /// PaddingLeft field with key 442.
  static const int paddingLeftPropertyKey = 442;
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
  /// PaddingRight field with key 443.
  static const int paddingRightPropertyKey = 443;
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
  /// PaddingTop field with key 444.
  static const int paddingTopPropertyKey = 444;
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
  /// PaddingBottom field with key 445.
  static const int paddingBottomPropertyKey = 445;
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
  /// InsetLeft field with key 450.
  static const int insetLeftPropertyKey = 450;
  static const double insetLeftInitialValue = 0;
  double _insetLeft = insetLeftInitialValue;

  /// Left inset value.
  double get insetLeft => _insetLeft;

  /// Change the [_insetLeft] field value.
  /// [insetLeftChanged] will be invoked only if the field's value has changed.
  set insetLeft(double value) {
    if (_insetLeft == value) {
      return;
    }
    double from = _insetLeft;
    _insetLeft = value;
    if (hasValidated) {
      insetLeftChanged(from, value);
    }
  }

  void insetLeftChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// InsetRight field with key 451.
  static const int insetRightPropertyKey = 451;
  static const double insetRightInitialValue = 0;
  double _insetRight = insetRightInitialValue;

  /// Right inset value.
  double get insetRight => _insetRight;

  /// Change the [_insetRight] field value.
  /// [insetRightChanged] will be invoked only if the field's value has changed.
  set insetRight(double value) {
    if (_insetRight == value) {
      return;
    }
    double from = _insetRight;
    _insetRight = value;
    if (hasValidated) {
      insetRightChanged(from, value);
    }
  }

  void insetRightChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// InsetTop field with key 452.
  static const int insetTopPropertyKey = 452;
  static const double insetTopInitialValue = 0;
  double _insetTop = insetTopInitialValue;

  /// Top inset value.
  double get insetTop => _insetTop;

  /// Change the [_insetTop] field value.
  /// [insetTopChanged] will be invoked only if the field's value has changed.
  set insetTop(double value) {
    if (_insetTop == value) {
      return;
    }
    double from = _insetTop;
    _insetTop = value;
    if (hasValidated) {
      insetTopChanged(from, value);
    }
  }

  void insetTopChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// InsetBottom field with key 453.
  static const int insetBottomPropertyKey = 453;
  static const double insetBottomInitialValue = 0;
  double _insetBottom = insetBottomInitialValue;

  /// Bottom inset value.
  double get insetBottom => _insetBottom;

  /// Change the [_insetBottom] field value.
  /// [insetBottomChanged] will be invoked only if the field's value has
  /// changed.
  set insetBottom(double value) {
    if (_insetBottom == value) {
      return;
    }
    double from = _insetBottom;
    _insetBottom = value;
    if (hasValidated) {
      insetBottomChanged(from, value);
    }
  }

  void insetBottomChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// FlexGrow field with key 457.
  static const int flexGrowPropertyKey = 457;
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
  /// FlexShrink field with key 458.
  static const int flexShrinkPropertyKey = 458;
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
  /// AspectRatio field with key 446.
  static const int aspectRatioPropertyKey = 446;
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
  /// GridRowStart field with key 469.
  static const int gridRowStartPropertyKey = 469;
  static const int gridRowStartInitialValue = 1;
  int _gridRowStart = gridRowStartInitialValue;

  /// Start position of grid item in a row.
  int get gridRowStart => _gridRowStart;

  /// Change the [_gridRowStart] field value.
  /// [gridRowStartChanged] will be invoked only if the field's value has
  /// changed.
  set gridRowStart(int value) {
    if (_gridRowStart == value) {
      return;
    }
    int from = _gridRowStart;
    _gridRowStart = value;
    if (hasValidated) {
      gridRowStartChanged(from, value);
    }
  }

  void gridRowStartChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// GridRowEnd field with key 470.
  static const int gridRowEndPropertyKey = 470;
  static const int gridRowEndInitialValue = 1;
  int _gridRowEnd = gridRowEndInitialValue;

  /// End position of grid item in a row.
  int get gridRowEnd => _gridRowEnd;

  /// Change the [_gridRowEnd] field value.
  /// [gridRowEndChanged] will be invoked only if the field's value has changed.
  set gridRowEnd(int value) {
    if (_gridRowEnd == value) {
      return;
    }
    int from = _gridRowEnd;
    _gridRowEnd = value;
    if (hasValidated) {
      gridRowEndChanged(from, value);
    }
  }

  void gridRowEndChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// GridColumnStart field with key 471.
  static const int gridColumnStartPropertyKey = 471;
  static const int gridColumnStartInitialValue = 1;
  int _gridColumnStart = gridColumnStartInitialValue;

  /// Start position of grid item in a column.
  int get gridColumnStart => _gridColumnStart;

  /// Change the [_gridColumnStart] field value.
  /// [gridColumnStartChanged] will be invoked only if the field's value has
  /// changed.
  set gridColumnStart(int value) {
    if (_gridColumnStart == value) {
      return;
    }
    int from = _gridColumnStart;
    _gridColumnStart = value;
    if (hasValidated) {
      gridColumnStartChanged(from, value);
    }
  }

  void gridColumnStartChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// GridColumnEnd field with key 472.
  static const int gridColumnEndPropertyKey = 472;
  static const int gridColumnEndInitialValue = 1;
  int _gridColumnEnd = gridColumnEndInitialValue;

  /// End position of grid item in a column.
  int get gridColumnEnd => _gridColumnEnd;

  /// Change the [_gridColumnEnd] field value.
  /// [gridColumnEndChanged] will be invoked only if the field's value has
  /// changed.
  set gridColumnEnd(int value) {
    if (_gridColumnEnd == value) {
      return;
    }
    int from = _gridColumnEnd;
    _gridColumnEnd = value;
    if (hasValidated) {
      gridColumnEndChanged(from, value);
    }
  }

  void gridColumnEndChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is LayoutComponentBase) {
      _layoutFlags0 = source._layoutFlags0;
      _layoutFlags1 = source._layoutFlags1;
      _layoutFlags2 = source._layoutFlags2;
      _gapWidth = source._gapWidth;
      _gapHeight = source._gapHeight;
      _width = source._width;
      _height = source._height;
      _maxWidth = source._maxWidth;
      _maxHeight = source._maxHeight;
      _minWidth = source._minWidth;
      _minHeight = source._minHeight;
      _marginLeft = source._marginLeft;
      _marginRight = source._marginRight;
      _marginTop = source._marginTop;
      _marginBottom = source._marginBottom;
      _paddingLeft = source._paddingLeft;
      _paddingRight = source._paddingRight;
      _paddingTop = source._paddingTop;
      _paddingBottom = source._paddingBottom;
      _insetLeft = source._insetLeft;
      _insetRight = source._insetRight;
      _insetTop = source._insetTop;
      _insetBottom = source._insetBottom;
      _flexGrow = source._flexGrow;
      _flexShrink = source._flexShrink;
      _aspectRatio = source._aspectRatio;
      _gridRowStart = source._gridRowStart;
      _gridRowEnd = source._gridRowEnd;
      _gridColumnStart = source._gridColumnStart;
      _gridColumnEnd = source._gridColumnEnd;
    }
  }
}
