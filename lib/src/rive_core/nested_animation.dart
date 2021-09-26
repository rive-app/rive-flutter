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
  void advance(double elapsedSeconds, MountedArtboard mountedArtboard);

  // @override
  // bool import(ImportStack stack) {
  //   var backboardImporter =
  //       stack.latest<BackboardImporter>(BackboardBase.typeKey);
  //   if (backboardImporter == null) {
  //     return false;
  //   }
  //   backboardImporter.addNestedArtboard(this);

  //   return super.import(stack);
  // }

  @override
  void update(int dirt) {}
}
