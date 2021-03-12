
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart' as core;

class StateMachineInput<T> {
  final int id;
  final StateMachineController controller;
  StateMachineInput._(this.id, this.controller);

  T get value => controller.inputValues[id] as T;
  set value(T newValue) => change(newValue);

  /// Change the value of the input, returns true if the value was changed the
  /// and [StateMachineController] was activated.
  bool change(T value) {
    if (controller.inputValues[id] == value) {
      return false;
    }
    controller.inputValues[id] = value;
    controller.isActive = true;
    return true;
  }
}

/// An AnimationController which controls a StateMachine and provides access to
/// the inputs of the StateMachine.
class StateMachineController extends core.StateMachineController {
  StateMachineController(StateMachine stateMachine) : super(stateMachine) {
    isActive = true;
  }

  factory StateMachineController.fromArtboard(
      Artboard artboard, String stateMachineName) {
    for (final animation in artboard.animations) {
      if (animation is StateMachine && animation.name == stateMachineName) {
        return StateMachineController(animation);
      }
    }
    return null;
  }

  StateMachineInput<T> findInput<T>(String name) {
    for (final input in stateMachine.inputs) {
      if (input.name == name && input.isValidType<T>()) {
        inputValues[input.id] = input.controllerValue;
        return StateMachineInput<T>._(input.id, this);
      }
    }
    return null;
  }
}
