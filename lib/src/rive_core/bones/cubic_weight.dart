import 'package:rive/src/generated/bones/cubic_weight_base.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';

export 'package:rive/src/generated/bones/cubic_weight_base.dart';

class CubicWeight extends CubicWeightBase {
  final Vec2D inTranslation = Vec2D();
  final Vec2D outTranslation = Vec2D();

  @override
  void inIndicesChanged(int from, int to) {}

  @override
  void inValuesChanged(int from, int to) {}

  @override
  void outIndicesChanged(int from, int to) {}

  @override
  void outValuesChanged(int from, int to) {}
}
