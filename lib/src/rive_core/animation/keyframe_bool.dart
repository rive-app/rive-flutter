import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyframe_bool_base.dart';
import 'package:rive/src/generated/rive_core_beans.dart';
export 'package:rive/src/generated/animation/keyframe_bool_base.dart';

/// KeyFrame for animating bool properties.
class KeyFrameBool extends KeyFrameBoolBase {
  @override
  bool get canInterpolate => false;

  @override
  void apply(Core<CoreContext> object, PropertyBean bean, double mix) {
    // RiveCoreContext.setBool(object, bean, value);
    bean.setBool(object, value);
  }

  @override
  void applyInterpolation(Core<CoreContext> object, PropertyBean bean,
      double currentTime, KeyFrameBool nextFrame, double mix) {
    // RiveCoreContext.setBool(object, bean, value);
    bean.setBool(object, value);
  }

  @override
  void valueChanged(bool from, bool to) {}
}
