import 'package:flutter/rendering.dart';
import 'package:rive/rive.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/nested_linear_animation.dart';
import 'package:rive/src/rive_core/animation/nested_state_machine.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart'
    as state_machine_core;
import 'package:rive_common/math.dart';

extension NestedArtboardRuntimeExtension on NestedArtboard {
  NestedArtboard? nestedArtboardAtPath(String path) {
    if (mountedArtboard is RuntimeMountedArtboard) {
      final runtimeMountedArtboard = mountedArtboard as RuntimeMountedArtboard;
      return runtimeMountedArtboard.artboardInstance.nestedArtboardAtPath(path);
    }
    return null;
  }
}

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
      object.mountedArtboard =
          RuntimeMountedArtboard(runtimeArtboardInstance, object);
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
          final linearAnimationInstance = LinearAnimationInstance(
              runtimeLinearAnimations[animationId],
              context:
                  (mountedArtboard as RuntimeMountedArtboard).artboardInstance);
          animation.linearAnimationInstance =
              RuntimeNestedLinearAnimationInstance(linearAnimationInstance);
          if (mountedArtboard is RuntimeMountedArtboard) {
            (mountedArtboard as RuntimeMountedArtboard)
                .addEventListener(linearAnimationInstance);
          }
        }
      } else if (animation is NestedStateMachine) {
        var animationId = animation.animationId;
        if (animationId >= 0 && animationId < runtimeStateMachines.length) {
          final controller =
              StateMachineController(runtimeStateMachines[animationId]);
          animation.stateMachineInstance = RuntimeNestedStateMachineInstance(
            (mountedArtboard as RuntimeMountedArtboard).artboardInstance,
            controller,
          );
          if (mountedArtboard is RuntimeMountedArtboard) {
            final runtimeMountedArtboard =
                mountedArtboard as RuntimeMountedArtboard;
            runtimeMountedArtboard.addEventListener(controller);
          }
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
    linearAnimation.advance(elapsedSeconds * speed,
        callbackReporter: linearAnimation);
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
  bool hitTest(Vec2D position) => stateMachineController.hitTest(position);

  @override
  state_machine_core.HitResult pointerDown(
      Vec2D position, PointerDownEvent event) {
    final result = stateMachineController.pointerDown(position, event);

    return result;
  }

  @override
  state_machine_core.HitResult pointerMove(Vec2D position) =>
      stateMachineController.pointerMove(position);

  @override
  state_machine_core.HitResult pointerUp(Vec2D position) =>
      stateMachineController.pointerUp(position);

  @override
  state_machine_core.HitResult pointerExit(Vec2D position) =>
      stateMachineController.pointerExit(position);

  @override
  dynamic getInputValue(int id) => stateMachineController.getInputValue(id);
  @override
  void setInputValue(int id, dynamic value) {
    var inputs = stateMachineController.stateMachine.inputs;
    if (id < inputs.length && id >= 0) {
      stateMachineController.setInputValue(inputs[id].id, value);
    }
  }
}
