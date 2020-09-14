import 'package:rive/src/rive_core/drawable.dart';
import 'package:rive/src/generated/draw_target_base.dart';
export 'package:rive/src/generated/draw_target_base.dart';

enum DrawTargetPlacement { before, after }

class DrawTarget extends DrawTargetBase {
  Drawable first;
  Drawable last;
  Drawable _drawable;
  Drawable get drawable => _drawable;
  set drawable(Drawable value) {
    if (_drawable == value) {
      return;
    }
    _drawable = value;
    drawableId = value?.id;
  }

  DrawTargetPlacement get placement =>
      DrawTargetPlacement.values[placementValue];
  set placement(DrawTargetPlacement value) => placementValue = value.index;
  @override
  void drawableIdChanged(int from, int to) {
    _drawable = context?.resolve(to);
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    if (drawableId != null) {
      _drawable = context?.resolve(drawableId);
    } else {
      _drawable = null;
    }
  }

  @override
  void placementValueChanged(int from, int to) {
    artboard?.markDrawOrderDirty();
  }

  @override
  void update(int dirt) {}
}
