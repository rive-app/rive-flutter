import 'dart:collection';
import 'package:rive/src/rive_core/animation/keyframe.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/keyframe_draw_order_value.dart';
import 'package:rive/src/generated/animation/keyframe_draw_order_base.dart';

class KeyFrameDrawOrder extends KeyFrameDrawOrderBase {
  final HashSet<KeyFrameDrawOrderValue> _values =
      HashSet<KeyFrameDrawOrderValue>();
  bool internalAddValue(KeyFrameDrawOrderValue value) {
    if (_values.contains(value)) {
      return false;
    }
    _values.add(value);
    return true;
  }

  bool internalRemoveValue(KeyFrameDrawOrderValue value) {
    if (_values.remove(value)) {
      return true;
    }
    return false;
  }

  @override
  void apply(Core<CoreContext> object, int propertyKey, double mix) {
    for (final value in _values) {
      value.apply(object.context);
    }
  }

  @override
  void applyInterpolation(Core<CoreContext> object, int propertyKey,
      double seconds, KeyFrame nextFrame, double mix) {
    apply(object, propertyKey, mix);
  }
}
