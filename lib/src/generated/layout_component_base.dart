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
  /// Clip field with key 196.
  static const int clipPropertyKey = 196;
  static const bool clipInitialValue = true;
  bool _clip = clipInitialValue;

  /// True when the layout component bounds clip its contents.
  bool get clip => _clip;

  /// Change the [_clip] field value.
  /// [clipChanged] will be invoked only if the field's value has changed.
  set clip(bool value) {
    if (_clip == value) {
      return;
    }
    bool from = _clip;
    _clip = value;
    if (hasValidated) {
      clipChanged(from, value);
    }
  }

  void clipChanged(bool from, bool to);

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
  /// StyleId field with key 494.
  static const int styleIdPropertyKey = 494;
  static const int styleIdInitialValue = -1;
  int _styleId = styleIdInitialValue;

  /// LayoutStyle that defines the styling for this LayoutComponent
  int get styleId => _styleId;

  /// Change the [_styleId] field value.
  /// [styleIdChanged] will be invoked only if the field's value has changed.
  set styleId(int value) {
    if (_styleId == value) {
      return;
    }
    int from = _styleId;
    _styleId = value;
    if (hasValidated) {
      styleIdChanged(from, value);
    }
  }

  void styleIdChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is LayoutComponentBase) {
      _clip = source._clip;
      _width = source._width;
      _height = source._height;
      _styleId = source._styleId;
    }
  }
}
