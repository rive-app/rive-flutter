import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyframe_base.dart';
import 'package:rive/src/rive_core/animation/keyed_property.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';

import '../../generated/rive_core_beans.dart';

export 'package:rive/src/generated/animation/keyframe_base.dart';

abstract class KeyFrame extends KeyFrameBase<RuntimeArtboard>
    implements KeyFrameInterface {
  bool get canInterpolate => false;

  @nonVirtual
  double seconds = 0; // avoid getter

  @override
  void onAdded() {}

  void computeSeconds(LinearAnimation animation) {
    // _timeInSeconds = frame / animation.fps;
    seconds = frame / animation.fps;
  }

  @override
  void onAddedDirty() {}

  // @override
  // void frameChanged(int from, int to) {}

  /// Apply the value of this keyframe to the object's property.
  void apply(Core object, PropertyBean bean, double mix) {}

  /// Interpolate the value between this keyframe and the next and apply it to
  /// the object's property.
  void applyInterpolation(Core object, PropertyBean bean, double seconds,
      covariant KeyFrame nextFrame, double mix) {}

  @override
  bool import(ImportStack importStack) {
    // var keyedPropertyHelper = importStack.latest<KeyedPropertyImporter>(KeyedPropertyBase.typeKey);
    var keyedPropertyHelper = importStack.latests[KeyedPropertyBase.typeKey] as KeyedPropertyImporter;
    // var keyedPropertyHelper = importStack.latests[KeyedPropertyBase.typeKey] as KeyedPropertyImporter?;
    // if (keyedPropertyHelper == null) {
    //   return false;
    // }

    // keyedPropertyHelper.addKeyFrame(this);

    // keyedPropertyHelper.keyedProperty.context.addObject(this);
    var property = keyedPropertyHelper.keyedProperty;
    context = property.context;
    id = context.objects.length;
    context.objects.add(this);

    // property.internalAddKeyFrame(this);
    property.keyframes.add(this);
    // property.markKeyFrameOrderDirty();
    // context.dirty(property.sort);
    // property.onKeyframesChanged();
    property.pair = null;

    // computeSeconds(keyedPropertyHelper.animation);
    seconds = frame / keyedPropertyHelper.animation.fps;


    // return super.import(importStack);
    return true;
  }

  @override
  String toString() => '${super.toString()} id: ($id)';
}
