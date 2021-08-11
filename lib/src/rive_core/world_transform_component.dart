import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/generated/world_transform_component_base.dart';
export 'package:rive/src/generated/world_transform_component_base.dart';

/// A Component with world transform.
abstract class WorldTransformComponent extends WorldTransformComponentBase {
  final Mat2D worldTransform = Mat2D();
  double get childOpacity => opacity;

  void markWorldTransformDirty() =>
      addDirt(ComponentDirt.worldTransform, recurse: true);
}
