import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyframe_string_base.dart';

import '../../generated/rive_core_beans.dart';

export 'package:rive/src/generated/animation/keyframe_id_base.dart';

class KeyFrameString extends KeyFrameStringBase {
  @override
  bool get canInterpolate => false;

  @override
  void apply(Core<CoreContext> object, PropertyBean bean, double mix) {
    bean.setString(object, value);
  }

  @override
  void applyInterpolation(Core<CoreContext> object, PropertyBean bean,
      double currentTime, KeyFrameString nextFrame, double mix) {
    bean.setString(object, value);
  }

  @override
  void valueChanged(String from, String to) {}
}
