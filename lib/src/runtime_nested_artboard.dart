import 'package:flutter/rendering.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/linear_animation_instance.dart';
import 'package:rive/src/rive_core/animation/nested_linear_animation.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/math/aabb.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/nested_artboard.dart';

class RuntimeNestedArtboard extends NestedArtboard {
  Artboard? sourceArtboard;
  @override
  K? clone<K extends Core<CoreContext>>() {
    var object = RuntimeNestedArtboard();
    object.copy(this);
    if (sourceArtboard != null) {
      object.sourceArtboard = sourceArtboard;
      var runtimeArtboardInstance =
          sourceArtboard!.instance() as RuntimeArtboard;
      object.mountedArtboard = RuntimeMountedArtboard(runtimeArtboardInstance);
    }

    return object as K;
  }

  @override
  void onAdded() {
    super.onAdded();
    if (mountedArtboard is! RuntimeMountedArtboard ||
        sourceArtboard == null ||
        animations.isEmpty) {
      return;
    }
    var runtimeLinearAnimations =
        sourceArtboard!.linearAnimations.toList(growable: false);
    for (final animation in animations) {
      if (animation is NestedLinearAnimation) {
        var animationId = animation.animationId;
        if (animationId >= 0 && animationId < runtimeLinearAnimations.length) {
          animation.linearAnimationInstance =
              RuntimeNestedLinearAnimationInstance(LinearAnimationInstance(
                  runtimeLinearAnimations[animationId]));
        }
      }
    }
  }
}

class RuntimeNestedLinearAnimationInstance
    extends NestedLinearAnimationInstance {
  final LinearAnimationInstance linearAnimation;

  RuntimeNestedLinearAnimationInstance(this.linearAnimation);

  @override
  void apply(RuntimeMountedArtboard artboard, double mix) {
    linearAnimation.animation.apply(linearAnimation.time,
        coreContext: artboard.artboardInstance, mix: mix);
  }

  @override
  void advance(double elapsedSeconds) {
    needsApply = true;
    linearAnimation.advance(elapsedSeconds * speed);
  }

  @override
  double speed = 1;

  @override
  void goto(double value) {
    var localTime = linearAnimation.animation.globalToLocalTime(value);
    if (localTime == linearAnimation.time) {
      return;
    }
    needsApply = true;
    linearAnimation.time = localTime;
  }

  @override
  double get durationSeconds => linearAnimation.animation.durationSeconds;
}

class RuntimeMountedArtboard extends MountedArtboard {
  final RuntimeArtboard artboardInstance;
  RuntimeMountedArtboard(this.artboardInstance);

  @override
  Mat2D worldTransform = Mat2D();

  @override
  void draw(Canvas canvas) {
    canvas.save();
    canvas.transform(worldTransform.mat4);
    canvas.translate(-artboardInstance.originX * artboardInstance.width,
        -artboardInstance.originY * artboardInstance.height);
    artboardInstance.advance(0);
    artboardInstance.draw(canvas);
    canvas.restore();
  }

  @override
  AABB get bounds {
    var width = artboardInstance.width;

    var height = artboardInstance.height;
    var x = -artboardInstance.originX * width;
    var y = -artboardInstance.originY * height;
    return AABB.fromValues(x, y, x + width, y + height);
  }

  @override
  double get renderOpacity => artboardInstance.opacity;

  @override
  set renderOpacity(double value) {
    artboardInstance.opacity = value;
  }

  @override
  void advance(double seconds) =>
      artboardInstance.advance(seconds, nested: true);
}
