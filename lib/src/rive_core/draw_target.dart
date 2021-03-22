import 'package:rive/src/rive_core/drawable.dart';
import 'package:rive/src/generated/draw_target_base.dart';
export 'package:rive/src/generated/draw_target_base.dart';

enum DrawTargetPlacement { before, after }

class DrawTarget extends DrawTargetBase {
  Drawable first = Drawable.unknown;
  Drawable last = Drawable.unknown;
  Drawable _drawable = Drawable.unknown;
  Drawable get drawable => _drawable;
  set drawable(Drawable value) {
    if (_drawable == value) {
      return;
    }
    _drawable = value;
    drawableId = value.id;
  }

  DrawTargetPlacement get placement =>
      DrawTargetPlacement.values[placementValue];
  set placement(DrawTargetPlacement value) => placementValue = value.index;
  @override
  void drawableIdChanged(int from, int to) {
    drawable = context.resolveWithDefault(to, Drawable.unknown);
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    drawable = context.resolveWithDefault(drawableId, Drawable.unknown);
  }

  @override
  void placementValueChanged(int from, int to) {
    artboard.markDrawOrderDirty();
  }

  @override
  void update(int dirt) {}
}
