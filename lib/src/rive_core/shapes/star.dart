import 'dart:math';
import 'package:rive/src/rive_core/bones/weight.dart';
import 'package:rive/src/rive_core/shapes/path_vertex.dart';
import 'package:rive/src/rive_core/shapes/straight_vertex.dart';
import 'package:rive/src/generated/shapes/star_base.dart';
export 'package:rive/src/generated/shapes/star_base.dart';

class Star extends StarBase {
  @override
  void innerRadiusChanged(double from, double to) => markPathDirty();
  @override
  List<PathVertex<Weight>> get vertices {
    var actualPoints = points * 2;
    var vertexList =
        List<StraightVertex>.filled(actualPoints, null, growable: false);
    var halfWidth = width / 2;
    var halfHeight = height / 2;
    var innerHalfWidth = width * innerRadius / 2;
    var innerHalfHeight = height * innerRadius / 2;
    var angle = -pi / 2;
    var inc = 2 * pi / actualPoints;
    for (int i = 0; i < actualPoints; i++) {
      vertexList[i++] = StraightVertex()
        ..x = cos(angle) * halfWidth
        ..y = sin(angle) * halfHeight
        ..radius = cornerRadius;
      angle += inc;
      vertexList[i] = StraightVertex()
        ..x = cos(angle) * innerHalfWidth
        ..y = sin(angle) * innerHalfHeight
        ..radius = cornerRadius;
      angle += inc;
    }
    return vertexList;
  }
}
