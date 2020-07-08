/// Core automatically generated
/// lib/src/generated/animation/keyframe_draw_order_value_base.dart.
/// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class KeyFrameDrawOrderValueBase<T extends CoreContext>
    extends Core<T> {
  static const int typeKey = 33;
  @override
  int get coreType => KeyFrameDrawOrderValueBase.typeKey;
  @override
  Set<int> get coreTypes => {KeyFrameDrawOrderValueBase.typeKey};

  /// --------------------------------------------------------------------------
  /// DrawableId field with key 77.
  int _drawableId;
  static const int drawableIdPropertyKey = 77;

  /// The id of the Drawable this KeyFrameDrawOrderValue's value is for.
  int get drawableId => _drawableId;

  /// Change the [_drawableId] field value.
  /// [drawableIdChanged] will be invoked only if the field's value has changed.
  set drawableId(int value) {
    if (_drawableId == value) {
      return;
    }
    int from = _drawableId;
    _drawableId = value;
    drawableIdChanged(from, value);
  }

  void drawableIdChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// Value field with key 78.
  int _value;
  static const int valuePropertyKey = 78;

  /// The draw order value to apply to the Drawable.
  int get value => _value;

  /// Change the [_value] field value.
  /// [valueChanged] will be invoked only if the field's value has changed.
  set value(int value) {
    if (_value == value) {
      return;
    }
    int from = _value;
    _value = value;
    valueChanged(from, value);
  }

  void valueChanged(int from, int to);
}
