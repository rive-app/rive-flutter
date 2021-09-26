import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/draw_target_base.dart';
import 'package:rive/src/rive_core/drawable.dart';

export 'package:rive/src/generated/draw_target_base.dart';

enum DrawTargetPlacement { before, after }

class DrawTarget extends DrawTargetBase {
  // Store first and last drawables that are affected by this target.
  Drawable? first;
  Drawable? last;

  Drawable? _drawable;
  Drawable? get drawable => _drawable;
  set drawable(Drawable? value) {
    if (_drawable == value) {
      return;
    }

    _drawable = value;
    drawableId = value?.id ?? Core.missingId;
  }

  DrawTargetPlacement get placement =>
      DrawTargetPlacement.values[placementValue];
  set placement(DrawTargetPlacement value) => placementValue = value.index;

  @override
  void drawableIdChanged(int from, int to) {
    drawable = context.resolve(to);
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    drawable = context.resolve(drawableId);
  }

  @override
  void placementValueChanged(int from, int to) {
    artboard?.markDrawOrderDirty();
  }

  @override
  void update(int dirt) {}
}
