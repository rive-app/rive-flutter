import 'dart:ui';

import 'package:rive/src/generated/shapes/paint/solid_color_base.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/shapes/paint/shape_paint.dart';
import 'package:rive/src/rive_core/shapes/paint/shape_paint_mutator.dart';

export 'package:rive/src/generated/shapes/paint/solid_color_base.dart';

/// A solid color painter for a shape. Works for both Fill and Stroke.
class SolidColor extends SolidColorBase with ShapePaintMutator {
  Color get color => Color(colorValue);
  set color(Color c) {
    colorValue = c.value;
  }

  @override
  void colorValueChanged(int from, int to) {
    // Since all we need to do is set the color on the paint, we can just do
    // this whenever it changes as it's such a lightweight operation. We don't
    // need to schedule it for the next update cycle, which saves us from adding
    // SolidColor to the dependencies graph.
    syncColor();

    // Since we're not in the dependency tree, chuck dirt onto the shape, which
    // is. This just ensures we'll paint as soon as possible to show the updated
    // color.
    shapePaintContainer?.addDirt(ComponentDirt.paint);
  }

  @override
  void update(int dirt) {
    // Intentionally empty. SolidColor doesn't need an update cycle and doesn't
    // depend on anything.
  }

  @override
  void syncColor() {
    super.syncColor();
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
