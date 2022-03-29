import 'dart:typed_data';

import 'package:rive/src/generated/shapes/cubic_vertex_base.dart';
import 'package:rive/src/rive_core/bones/weight.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';

export 'package:rive/src/generated/shapes/cubic_vertex_base.dart';

abstract class CubicVertex extends CubicVertexBase {
  Vec2D get outPoint;
  Vec2D get inPoint;

  set outPoint(Vec2D value);
  set inPoint(Vec2D value);

  @override
  Vec2D get renderTranslation => weight?.translation ?? super.renderTranslation;

  Vec2D get renderIn => weight?.inTranslation ?? inPoint;
  Vec2D get renderOut => weight?.outTranslation ?? outPoint;

  @override
  void deform(Mat2D world, Float32List boneTransforms) {
    super.deform(world, boneTransforms);

    Weight.deform(outPoint.x, outPoint.y, weight!.outIndices, weight!.outValues,
        world, boneTransforms, weight!.outTranslation);
    Weight.deform(inPoint.x, inPoint.y, weight!.inIndices, weight!.inValues,
        world, boneTransforms, weight!.inTranslation);
  }
}
