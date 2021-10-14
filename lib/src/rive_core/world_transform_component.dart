import 'package:rive/src/generated/world_transform_component_base.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';

export 'package:rive/src/generated/world_transform_component_base.dart';

/// A Component with world transform.
abstract class WorldTransformComponent extends WorldTransformComponentBase {
  final Mat2D worldTransform = Mat2D();
  double get childOpacity => opacity;

  void markWorldTransformDirty() =>
      addDirt(ComponentDirt.worldTransform, recurse: true);

  @override
  void opacityChanged(double from, double to) {
    markWorldTransformDirty();
  }

  /// Returns the world transform of the parent component. Returns the identity
  /// if there is no parent (the artboard should be the only case here).
  Mat2D get parentWorldTransform => parent is WorldTransformComponent
      ? (parent as WorldTransformComponent).worldTransform
      : Mat2D.identity;
}
