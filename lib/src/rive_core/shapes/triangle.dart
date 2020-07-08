import 'package:rive/src/rive_core/shapes/path_vertex.dart';
import 'package:rive/src/rive_core/shapes/straight_vertex.dart';
import 'package:rive/src/generated/shapes/triangle_base.dart';
export 'package:rive/src/generated/shapes/triangle_base.dart';

class Triangle extends TriangleBase {
  @override
  List<PathVertex> get vertices => [
        StraightVertex()
          ..x = 0
          ..y = -height / 2,
        StraightVertex()
          ..x = width / 2
          ..y = height / 2,
        StraightVertex()
          ..x = -width / 2
          ..y = height / 2
      ];
}
