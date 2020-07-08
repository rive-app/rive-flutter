import 'package:rive/src/generated/shapes/straight_vertex_base.dart';
export 'package:rive/src/generated/shapes/straight_vertex_base.dart';

class StraightVertex extends StraightVertexBase {
  @override
  String toString() => 'x[$x], y[$y], r[$radius]';
  @override
  void radiusChanged(double from, double to) {
    path?.markPathDirty();
  }
}
