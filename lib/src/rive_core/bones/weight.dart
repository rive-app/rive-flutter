import 'dart:typed_data';

import 'package:rive/src/generated/bones/weight_base.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';

export 'package:rive/src/generated/bones/weight_base.dart';

class Weight extends WeightBase {
  final Vec2D translation = Vec2D();

  @override
  void indicesChanged(int from, int to) {}

  @override
  void update(int dirt) {
    // Intentionally empty. Weights don't update.
  }

  @override
  void valuesChanged(int from, int to) {}

  static void deform(double x, double y, int indices, int weights, Mat2D world,
      Float32List boneTransforms, Vec2D result) {
    double xx = 0, xy = 0, yx = 0, yy = 0, tx = 0, ty = 0;
    var rx = world[0] * x + world[2] * y + world[4];
    var ry = world[1] * x + world[3] * y + world[5];
    for (int i = 0; i < 4; i++) {
      var weight = encodedWeightValue(i, weights);
      if (weight == 0) {
        continue;
      }

      double normalizedWeight = weight / 255;
      var index = encodedWeightValue(i, indices);
      var startBoneTransformIndex = index * 6;
      xx += boneTransforms[startBoneTransformIndex++] * normalizedWeight;
      xy += boneTransforms[startBoneTransformIndex++] * normalizedWeight;
      yx += boneTransforms[startBoneTransformIndex++] * normalizedWeight;
      yy += boneTransforms[startBoneTransformIndex++] * normalizedWeight;
      tx += boneTransforms[startBoneTransformIndex++] * normalizedWeight;
      ty += boneTransforms[startBoneTransformIndex++] * normalizedWeight;
    }
    result.x = xx * rx + yx * ry + tx;
    result.y = xy * rx + yy * ry + ty;
  }

  static int encodedWeightValue(int index, int data) {
    return (data >> (index * 8)) & 0xFF;
  }
}
