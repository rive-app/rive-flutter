import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyframe_base.dart';
import 'package:rive/src/rive_core/animation/interpolator.dart';
import 'package:rive/src/rive_core/animation/keyed_property.dart';
import 'package:rive/src/rive_core/animation/keyframe_interpolation.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';

export 'package:rive/src/generated/animation/keyframe_base.dart';

abstract class KeyFrame extends KeyFrameBase<RuntimeArtboard>
    implements KeyFrameInterface {
  double _timeInSeconds = 0;
  double get seconds => _timeInSeconds;

  bool get canInterpolate => true;

  KeyFrameInterpolation get interpolation =>
      KeyFrameInterpolation.values[interpolationType];
  set interpolation(KeyFrameInterpolation value) {
    interpolationType = value.index;
  }

  @override
  void interpolationTypeChanged(int from, int to) {}

  @override
  void interpolatorIdChanged(int from, int to) {
    // This might resolve to null during a load or if context isn't available
    // yet so we also do this in onAddedDirty.
    interpolator = context.resolve(to);
  }

  @override
  void onAdded() {}

  void computeSeconds(LinearAnimation animation) {
    _timeInSeconds = frame / animation.fps;
  }

  @override
  void onAddedDirty() {
    if (interpolatorId != Core.missingId) {
      interpolator = context.resolve(interpolatorId);
    }
  }

  @override
  void onRemoved() {
    super.onRemoved();
  }

  @override
  void frameChanged(int from, int to) {}

  /// Apply the value of this keyframe to the object's property.
  void apply(Core object, int propertyKey, double mix);

  /// Interpolate the value between this keyframe and the next and apply it to
  /// the object's property.
  void applyInterpolation(Core object, int propertyKey, double seconds,
      covariant KeyFrame nextFrame, double mix);

  Interpolator? _interpolator;
  Interpolator? get interpolator => _interpolator;
  set interpolator(Interpolator? value) {
    if (_interpolator == value) {
      return;
    }

    _interpolator = value;
    interpolatorId = value?.id ?? Core.missingId;
  }

  @override
  bool import(ImportStack importStack) {
    var keyedPropertyHelper =
        importStack.latest<KeyedPropertyImporter>(KeyedPropertyBase.typeKey);
    if (keyedPropertyHelper == null) {
      return false;
    }
    keyedPropertyHelper.addKeyFrame(this);

    return super.import(importStack);
  }
}
