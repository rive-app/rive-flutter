import 'package:rive/src/generated/shapes/ellipse_base.dart';
import 'package:rive/src/rive_core/math/circle_constant.dart';
import 'package:rive/src/rive_core/shapes/cubic_detached_vertex.dart';
import 'package:rive/src/rive_core/shapes/path_vertex.dart';

export 'package:rive/src/generated/shapes/ellipse_base.dart';

class Ellipse extends EllipseBase {
  @override
  List<PathVertex> get vertices {
    double ox = -originX * width + radiusX;
    double oy = -originY * height + radiusY;

    return [
      CubicDetachedVertex.fromValues(
        x: ox,
        y: oy - radiusY,
        inX: ox - radiusX * circleConstant,
        inY: oy - radiusY,
        outX: ox + radiusX * circleConstant,
        outY: oy - radiusY,
      ),
      CubicDetachedVertex.fromValues(
        x: ox + radiusX,
        y: oy,
        inX: ox + radiusX,
        inY: oy + circleConstant * -radiusY,
        outX: ox + radiusX,
        outY: oy + circleConstant * radiusY,
      ),
      CubicDetachedVertex.fromValues(
        x: ox,
        y: oy + radiusY,
        inX: ox + radiusX * circleConstant,
        inY: oy + radiusY,
        outX: ox - radiusX * circleConstant,
        outY: oy + radiusY,
      ),
      CubicDetachedVertex.fromValues(
        x: ox - radiusX,
        y: oy,
        inX: ox - radiusX,
        inY: oy + radiusY * circleConstant,
        outX: ox - radiusX,
        outY: oy - radiusY * circleConstant,
      ),
    ];
  }

  double get radiusX => width / 2;
  double get radiusY => height / 2;
}
