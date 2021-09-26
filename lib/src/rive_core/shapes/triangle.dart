import 'package:rive/src/generated/shapes/triangle_base.dart';
import 'package:rive/src/rive_core/shapes/path_vertex.dart';
import 'package:rive/src/rive_core/shapes/straight_vertex.dart';

/// Export the Base class for external use (e.g. rive.dart)
export 'package:rive/src/generated/shapes/triangle_base.dart';

class Triangle extends TriangleBase {
  @override
  List<PathVertex> get vertices {
    double ox = -originX * width;
    double oy = -originY * height;

    return [
      StraightVertex.procedural()
        ..x = ox + width / 2
        ..y = oy,
      StraightVertex.procedural()
        ..x = ox + width
        ..y = oy + height,
      StraightVertex.procedural()
        ..x = ox
        ..y = oy + height
    ];
  }
}
