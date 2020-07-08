import 'package:rive/src/rive_core/math/vec2d.dart';

class ProjectionResult {
  final double t;
  final Vec2D point;
  ProjectionResult(this.t, this.point);
}

class Segment2D {
  final Vec2D start;
  final Vec2D end;
  Vec2D diff;
  double lengthSquared;
  Segment2D(this.start, this.end);
  ProjectionResult projectPoint(Vec2D point) {
    if (diff == null) {
      diff = Vec2D.subtract(Vec2D(), start, end);
      lengthSquared = Vec2D.squaredLength(diff);
    }
    if (lengthSquared == 0) {
      return ProjectionResult(0, start);
    }
    double t = ((point[0] - start[0]) * (end[0] - start[0]) +
            (point[1] - start[1]) * (end[1] - start[1])) /
        lengthSquared;
    if (t < 0.0) {
      return ProjectionResult(0, start);
    }
    if (t > 1.0) {
      return ProjectionResult(1, end);
    }
    return ProjectionResult(
        t,
        Vec2D.fromValues(start[0] + t * (end[0] - start[0]),
            start[1] + t * (end[1] - start[1])));
  }
}
