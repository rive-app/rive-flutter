import 'dart:ui';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/shapes/paint/shape_paint.dart';
import 'package:rive/src/rive_core/shapes/paint/shape_paint_mutator.dart';
import 'package:rive/src/generated/shapes/paint/solid_color_base.dart';
export 'package:rive/src/generated/shapes/paint/solid_color_base.dart';

class SolidColor extends SolidColorBase with ShapePaintMutator {
  Color get color => Color(colorValue);
  set color(Color c) {
    colorValue = c.value;
  }

  @override
  void colorValueChanged(int from, int to) {
    syncColor();
    shapePaintContainer?.addDirt(ComponentDirt.paint);
  }

  @override
  void update(int dirt) {}
  @override
  void syncColor() {
    paint.color = color
        .withOpacity((color.opacity * renderOpacity).clamp(0, 1).toDouble());
  }

  @override
  bool validate() => super.validate() && parent is ShapePaint;
  @override
  void onAdded() {
    super.onAdded();
    syncColor();
  }
}
