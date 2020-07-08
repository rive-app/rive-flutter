import 'dart:ui' as ui;
import 'package:rive/src/generated/shapes/paint/radial_gradient_base.dart';
export 'package:rive/src/generated/shapes/paint/radial_gradient_base.dart';

class RadialGradient extends RadialGradientBase {
  @override
  ui.Gradient makeGradient(ui.Offset start, ui.Offset end,
          List<ui.Color> colors, List<double> colorPositions) =>
      ui.Gradient.radial(start, (end - start).distance, colors, colorPositions);
}
