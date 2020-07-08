import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/drawable.dart';
import 'package:rive/src/generated/animation/keyframe_draw_order_value_base.dart';

class KeyFrameDrawOrderValue extends KeyFrameDrawOrderValueBase {
  @override
  void onAdded() {}
  @override
  void drawableIdChanged(int from, int to) {}
  @override
  void onAddedDirty() {}
  @override
  void onRemoved() {}
  @override
  void valueChanged(int from, int to) {}
  void apply(CoreContext context) {
    var drawable = context.resolve<Drawable>(drawableId);
    if (drawable != null) {
      drawable.drawOrder = value;
    }
  }

  @override
  int runtimeValueValue(int editorValue) {
    assert(false, 'this should never get called');
    return 0;
  }
}
