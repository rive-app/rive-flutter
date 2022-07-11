import 'package:flutter/rendering.dart';
import 'package:rive/src/controllers/state_machine_controller.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/linear_animation_instance.dart';
import 'package:rive/src/rive_core/animation/nested_linear_animation.dart';
import 'package:rive/src/rive_core/animation/nested_state_machine.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/math/aabb.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
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
    var runtimeStateMachines =
        sourceArtboard!.stateMachines.toList(growable: false);
    for (final animation in animations) {
      if (animation is NestedLinearAnimation) {
        var animationId = animation.animationId;
        if (animationId >= 0 && animationId < runtimeLinearAnimations.length) {
          animation.linearAnimationInstance =
              RuntimeNestedLinearAnimationInstance(LinearAnimationInstance(
                  runtimeLinearAnimations[animationId]));
        }
      } else if (animation is NestedStateMachine) {
        var animationId = animation.animationId;
        if (animationId >= 0 && animationId < runtimeStateMachines.length) {
          animation.stateMachineInstance = RuntimeNestedStateMachineInstance(
            (mountedArtboard as RuntimeMountedArtboard).artboardInstance,
            StateMachineController(runtimeStateMachines[animationId]),
          );
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
  bool advance(double elapsedSeconds) {
    needsApply = true;
    linearAnimation.advance(elapsedSeconds * speed);
    return linearAnimation.keepGoing;
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

class RuntimeNestedStateMachineInstance extends NestedStateMachineInstance {
  final StateMachineController stateMachineController;

  RuntimeNestedStateMachineInstance(
      RuntimeArtboard artboard, this.stateMachineController) {
    stateMachineController.init(artboard);
  }

  @override
  void apply(RuntimeMountedArtboard artboard, double elapsedSeconds) {
    stateMachineController.apply(artboard.artboardInstance, elapsedSeconds);
  }

  @override
  bool get isActive => stateMachineController.isActive;

  @override
  ValueListenable<bool> get isActiveChanged =>
      stateMachineController.isActiveChanged;

  @override
  void pointerDown(Vec2D position) =>
      stateMachineController.pointerDown(position);

  @override
  void pointerMove(Vec2D position) =>
      stateMachineController.pointerMove(position);

  @override
  void pointerUp(Vec2D position) => stateMachineController.pointerUp(position);

  @override
  void setInputValue(int id, dynamic value) {
    var inputs = stateMachineController.stateMachine.inputs;
    if (id < inputs.length && id >= 0) {
      stateMachineController.setInputValue(inputs[id].id, value);
    }
  }
}

class RuntimeMountedArtboard extends MountedArtboard {
  final RuntimeArtboard artboardInstance;
  RuntimeMountedArtboard(this.artboardInstance) {
    artboardInstance.frameOrigin = false;
    artboardInstance.advance(0, nested: true);
  }

  @override
  void dispose() {}

  @override
  Mat2D worldTransform = Mat2D();

  @override
  void draw(Canvas canvas) {
    canvas.save();
    canvas.transform(worldTransform.mat4);
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
  bool advance(double seconds) =>
      artboardInstance.advance(seconds, nested: true);
}
