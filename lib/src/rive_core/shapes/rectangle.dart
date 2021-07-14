import 'package:rive/src/generated/shapes/rectangle_base.dart';
import 'package:rive/src/rive_core/shapes/path_vertex.dart';
import 'package:rive/src/rive_core/shapes/straight_vertex.dart';

export 'package:rive/src/generated/shapes/rectangle_base.dart';

class Rectangle extends RectangleBase {
  //
  @override
  List<PathVertex> get vertices {
    double ox = -originX * width;
    double oy = -originY * height;

    return [
      StraightVertex.procedural()
        ..x = ox
        ..y = oy
        ..radius = cornerRadiusTL,
      StraightVertex.procedural()
        ..x = ox + width
        ..y = oy
        ..radius = linkCornerRadius ? cornerRadiusTL : cornerRadiusTR,
      StraightVertex.procedural()
        ..x = ox + width
        ..y = oy + height
        ..radius = linkCornerRadius ? cornerRadiusTL : cornerRadiusBR,
      StraightVertex.procedural()
        ..x = ox
        ..y = oy + height
        ..radius = linkCornerRadius ? cornerRadiusTL : cornerRadiusBL,
    ];
  }

  @override
  void cornerRadiusTLChanged(double from, double to) => markPathDirty();

  @override
  void cornerRadiusTRChanged(double from, double to) => markPathDirty();

  @override
  void cornerRadiusBLChanged(double from, double to) => markPathDirty();

  @override
  void cornerRadiusBRChanged(double from, double to) => markPathDirty();

  @override
  void linkCornerRadiusChanged(bool from, bool to) {
    markPathDirty();
  }
}
