import 'package:rive/src/rive_core/shapes/path_vertex.dart';
import 'package:rive/src/rive_core/shapes/straight_vertex.dart';
import 'package:rive/src/generated/shapes/rectangle_base.dart';
export 'package:rive/src/generated/shapes/rectangle_base.dart';

class Rectangle extends RectangleBase {
  @override
  List<PathVertex> get vertices {
    double ox = -originX * width;
    double oy = -originY * height;
    return [
      StraightVertex()
        ..x = ox
        ..y = oy
        ..radius = cornerRadius,
      StraightVertex()
        ..x = ox + width
        ..y = oy
        ..radius = cornerRadius,
      StraightVertex()
        ..x = ox + width
        ..y = oy + height
        ..radius = cornerRadius,
      StraightVertex()
        ..x = ox
        ..y = oy + height
        ..radius = cornerRadius
    ];
  }

  @override
  void cornerRadiusChanged(double from, double to) => markPathDirty();
}
