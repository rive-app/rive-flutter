import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyframe_string_base.dart';

export 'package:rive/src/generated/animation/keyframe_id_base.dart';

class KeyFrameString extends KeyFrameStringBase {
  @override
  bool get canInterpolate => false;

  @override
  void apply(Core<CoreContext> object, int propertyKey, double mix) {
    // If mix is 0, we don't apply this keyframe value. This rule allows
    // "mixing" of string values which are inherently unmixable
    if (mix > 0) {
      RiveCoreContext.setString(object, propertyKey, value);
    }
  }

  @override
  void applyInterpolation(Core<CoreContext> object, int propertyKey,
      double currentTime, KeyFrameString nextFrame, double mix) {
    // If mix is 0, we don't apply this keyframe value. This rule allows
    // "mixing" of string values which are inherently unmixable
    if (mix > 0) {
      RiveCoreContext.setString(object, propertyKey, value);
    }
  }

  @override
  void valueChanged(String from, String to) {}
}
