import 'dart:math';
import 'package:rive/src/rive_core/shapes/path_vertex.dart';
import 'package:rive/src/rive_core/bones/weight.dart';
import 'package:rive/src/rive_core/shapes/straight_vertex.dart';
import 'package:rive/src/generated/shapes/polygon_base.dart';
export 'package:rive/src/generated/shapes/polygon_base.dart';

class Polygon extends PolygonBase {
  @override
  void cornerRadiusChanged(double from, double to) => markPathDirty();
  @override
  void pointsChanged(int from, int to) => markPathDirty();
  @override
  List<PathVertex<Weight>> get vertices {
    var vertexList = List<StraightVertex>.filled(points, null);
    var halfWidth = width / 2;
    var halfHeight = height / 2;
    var angle = -pi / 2;
    var inc = 2 * pi / points;
    for (int i = 0; i < points; i++) {
      vertexList[i] = StraightVertex()
        ..x = cos(angle) * halfWidth
        ..y = sin(angle) * halfHeight
        ..radius = cornerRadius;
      angle += inc;
    }
    return vertexList;
  }
}
