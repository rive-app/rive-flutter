/// Extensions to the runtime core classes

import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/linear_animation_instance.dart';

/// Artboard extensions
extension ArtboardAdditions on Artboard {
  /// Returns an animation with the given name, or null if no animation with
  /// that name exists in the artboard
  LinearAnimationInstance animationByName(String name) {
    final animation = animations.firstWhere(
      (animation) => animation is LinearAnimation && animation.name == name,
      orElse: () => null,
    );
    if (animation != null) {
      return LinearAnimationInstance(animation as LinearAnimation);
    }
    return null;
  }
}
