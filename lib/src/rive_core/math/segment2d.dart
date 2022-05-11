import 'package:rive/src/rive_core/math/vec2d.dart';

/// Result of projecting a point onto a segment.
class ProjectionResult {
  /// The distance factor from 0-1 along the segment starting at the
  /// [Segment2D.start].
  final double t;

  /// The actual 2d point in the same space as [Segment2D.start] and
  /// [Segment2D.end].
  final Vec2D point;

  ProjectionResult(this.t, this.point);
}

/// A line segment with a discrete [start] and [end].
class Segment2D {
  /// The starting point of this line segment.
  final Vec2D start;

  /// The ending point of this line segment.
  final Vec2D end;

  /// Difference from start to end. Nullable so we can compute it only when we
  /// need it.
  Vec2D? _diff;
  Vec2D get diff {
    _computeDiff();
    return _diff!;
  }

  void _computeDiff() {
    // We cache these internally so we can call projectPoint multiple times in
    // succession performantly.
    if (_diff == null) {
      _diff = start - end;
      lengthSquared = _diff!.squaredLength();
    }
  }

  /// The squared length of this segment.
  double lengthSquared = 0;

  Segment2D(this.start, this.end);

  /// Find where the given [point] lies on this segment.
  ProjectionResult projectPoint(Vec2D point, {bool clamp = true}) {
    _computeDiff();
    if (lengthSquared == 0) {
      return ProjectionResult(0, start);
    }
    double t = ((point.x - start.x) * (end.x - start.x) +
            (point.y - start.y) * (end.y - start.y)) /
        lengthSquared;

    if (clamp) {
      // Clamp at edges.
      if (t < 0.0) {
        return ProjectionResult(0, start);
      }
      if (t > 1.0) {
        return ProjectionResult(1, end);
      }
    }

    return ProjectionResult(
      t,
      Vec2D.fromValues(
        start.x + t * (end.x - start.x),
        start.y + t * (end.y - start.y),
      ),
    );
  }
}
