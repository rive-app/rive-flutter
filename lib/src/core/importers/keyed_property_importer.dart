import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/keyed_property.dart';
import 'package:rive/src/rive_core/animation/keyframe.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';

class KeyedPropertyImporter extends ImportStackObject {
  final KeyedProperty keyedProperty;
  final LinearAnimation animation;

  KeyedPropertyImporter(this.keyedProperty, this.animation);

  void addKeyFrame(KeyFrame keyFrame) {
    keyedProperty.context.addObject(keyFrame);
    keyedProperty.internalAddKeyFrame(keyFrame);
    keyFrame.computeSeconds(animation);
  }

  @override
  void resolve() {}
}
