import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyframe_bool_base.dart';
export 'package:rive/src/generated/animation/keyframe_bool_base.dart';

/// KeyFrame for animating bool properties.
class KeyFrameBool extends KeyFrameBoolBase {
  @override
  bool get canInterpolate => false;

  @override
  void apply(Core<CoreContext> object, int propertyKey, double mix) {
    RiveCoreContext.setBool(object, propertyKey, value);
  }

  @override
  void applyInterpolation(Core<CoreContext> object, int propertyKey,
      double currentTime, KeyFrameBool nextFrame, double mix) {
    RiveCoreContext.setBool(object, propertyKey, value);
  }

  @override
  void valueChanged(bool from, bool to) {}
}
