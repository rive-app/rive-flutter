/// Core automatically generated
/// lib/src/generated/shapes/paint/shape_paint_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/container_component.dart';

abstract class ShapePaintBase extends ContainerComponent {
  static const int typeKey = 21;
  @override
  int get coreType => ShapePaintBase.typeKey;
  @override
  Set<int> get coreTypes => {
        ShapePaintBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// IsVisible field with key 41.
  static const bool isVisibleInitialValue = true;
  bool _isVisible = isVisibleInitialValue;
  static const int isVisiblePropertyKey = 41;
  bool get isVisible => _isVisible;

  /// Change the [_isVisible] field value.
  /// [isVisibleChanged] will be invoked only if the field's value has changed.
  set isVisible(bool value) {
    if (_isVisible == value) {
      return;
    }
    bool from = _isVisible;
    _isVisible = value;
    if (hasValidated) {
      isVisibleChanged(from, value);
    }
  }

  void isVisibleChanged(bool from, bool to);

  @override
  void copy(covariant ShapePaintBase source) {
    super.copy(source);
    _isVisible = source._isVisible;
  }
}
