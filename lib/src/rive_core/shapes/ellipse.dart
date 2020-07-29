import 'package:rive/src/rive_core/math/circle_constant.dart';
import 'package:rive/src/rive_core/shapes/cubic_detached_vertex.dart';
import 'package:rive/src/rive_core/shapes/path_vertex.dart';
import 'package:rive/src/generated/shapes/ellipse_base.dart';
export 'package:rive/src/generated/shapes/ellipse_base.dart';

class Ellipse extends EllipseBase {
  @override
  List<PathVertex> get vertices => [
        CubicDetachedVertex.fromValues(
            x: 0,
            y: -radiusY,
            inX: -radiusX * circleConstant,
            inY: -radiusY,
            outX: radiusX * circleConstant,
            outY: -radiusY),
        CubicDetachedVertex.fromValues(
            x: radiusX,
            y: 0,
            inX: radiusX,
            inY: circleConstant * -radiusY,
            outX: radiusX,
            outY: circleConstant * radiusY),
        CubicDetachedVertex.fromValues(
            x: 0,
            y: radiusY,
            inX: radiusX * circleConstant,
            inY: radiusY,
            outX: -radiusX * circleConstant,
            outY: radiusY),
        CubicDetachedVertex.fromValues(
            x: -radiusX,
            y: 0,
            inX: -radiusX,
            inY: radiusY * circleConstant,
            outX: -radiusX,
            outY: -radiusY * circleConstant)
      ];
  double get radiusX => width / 2;
  double get radiusY => height / 2;
}
