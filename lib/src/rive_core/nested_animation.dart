import 'package:rive/src/generated/nested_animation_base.dart';
import 'package:rive/src/rive_core/animation/animation.dart';
import 'package:rive/src/rive_core/nested_artboard.dart';

export 'package:rive/src/generated/nested_animation_base.dart';

abstract class NestedAnimation<T extends Animation>
    extends NestedAnimationBase {
  NestedArtboard? get nestedArtboard =>
      parent is NestedArtboard ? parent as NestedArtboard : null;

  @override
  void animationIdChanged(int from, int to) {}


  bool get isEnabled;

  /// Returns true when the NestedAnimation needs to keep advancing. Returning
  /// false doesn't guarantee another advance won't be called, it just means
  /// that it's no longer necessary to call advance again as the reesults will
  /// be the same.
  bool advance(double elapsedSeconds, MountedArtboard mountedArtboard);

  @override
  void update(int dirt) {}
}
