import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyframe_id_base.dart';

import '../../generated/rive_core_beans.dart';

export 'package:rive/src/generated/animation/keyframe_id_base.dart';

class KeyFrameId extends KeyFrameIdBase {
  @override
  bool get canInterpolate => false;

  @override
  void apply(Core<CoreContext> object, PropertyBean bean, double mix) {
    bean.setUint(object, value);
  }

  @override
  void applyInterpolation(Core<CoreContext> object, PropertyBean bean,
      double currentTime, KeyFrameId nextFrame, double mix) {
    bean.setUint(object, value);
  }

  @override
  void valueChanged(int from, int to) {}
}
