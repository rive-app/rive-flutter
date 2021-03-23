import 'dart:ui';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/shapes/shape_paint_container.dart';
import 'package:rive/src/generated/shapes/paint/fill_base.dart';
export 'package:rive/src/generated/shapes/paint/fill_base.dart';

class Fill extends FillBase {
  @override
  Paint makePaint() => Paint()..style = PaintingStyle.fill;
  PathFillType get fillType => PathFillType.values[fillRule];
  set fillType(PathFillType type) => fillRule = type.index;
  @override
  void fillRuleChanged(int from, int to) =>
      parent?.addDirt(ComponentDirt.paint);
  @override
  void update(int dirt) {}
  @override
  void onAdded() {
    super.onAdded();
    if (parent is ShapePaintContainer) {
      (parent as ShapePaintContainer).addFill(this);
    }
  }

  @override
  void draw(Canvas canvas, Path path) {
    if (!isVisible) {
      return;
    }
    path.fillType = fillType;
    canvas.drawPath(path, paint);
  }
}
