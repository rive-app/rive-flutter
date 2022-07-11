import 'package:flutter/foundation.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_bool.dart';
import 'package:rive/src/rive_core/animation/state_machine_input.dart' as core;
import 'package:rive/src/rive_core/animation/state_machine_number.dart';
import 'package:rive/src/rive_core/animation/state_machine_trigger.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart' as core;

/// [StateMachine]s supports three input types. The StateMachine mostly
/// abstracts types by allowing the programmer to query for an input of a
/// specific Dart backing type, mapping it to the correct StateMachine type.
/// This is the most flexible API to use to check if a type with a given name
/// exists. However, if you need to iterate inputs and query their types, this
/// enum is exposed for convenience.
enum SMIType { number, boolean, trigger }

/// SMI = StateMachineInstance
///
/// This is the abstraction of an instanced input
/// from the [StateMachine]. Whenever a [StateMachineController] is created, the
/// list of inputs in the corresponding [StateMachine] is wrapped into a set of
/// [SMIInput] objects that ensure inputs are initialized to design-time values.
/// The implementation can now change these values freely as they are decoupled
/// from the backing [StateMachine] and can safely be re-instanced by another
/// controller later.
abstract class SMIInput<T> {
  final core.StateMachineInput _input;
  final StateMachineController controller;
  final SMIType type;

  SMIInput._(this._input, this.type, this.controller);

  @protected
  void advance() {}

  /// The id of the input within the context of the [StateMachine] it belongs
  /// to.
  int get id => _input.id;

  /// The name given to this input at design time in Rive.
  String get name => _input.name;

  /// Convenience method for changing the backing [SMIInput.value] of the input.
  /// For [SMITrigger] it's usually preferable to use the [SMITrigger.fire]
  /// method to change the input value, but calling change(true) is totally
  /// valid.
  bool change(T value) {
    if (controller.getInputValue(id) == value) {
      return false;
    }
    controller.setInputValue(id, value);
    controller.isActive = true;
    return true;
  }

  T get value => controller.getInputValue(id) as T;
  set value(T newValue) => change(newValue);

  bool _is<K>() {
    return K == T;
  }
}

/// A boolean StateMachine input instance. Use the [value] property to change
/// the input which will automatically re-activate the [StateMachineController]
/// if necessary.
class SMIBool extends SMIInput<bool> {
  SMIBool._(StateMachineBool input, StateMachineController controller)
      : super._(
          input,
          SMIType.boolean,
          controller,
        ) {
    controller.setInputValue(id, input.value);
  }
}

/// A numeric StateMachine input instance. Use the [value] property to change
/// the input which will automatically re-activate the [StateMachineController]
/// if necessary.
class SMINumber extends SMIInput<double> {
  SMINumber._(StateMachineNumber input, StateMachineController controller)
      : super._(
          input,
          SMIType.number,
          controller,
        ) {
    controller.setInputValue(id, input.value);
  }
}

/// A trigger StateMachine input instance. Use the [fire] method to change the
/// input which will automatically re-activate the [StateMachineController] if
/// necessary.
class SMITrigger extends SMIInput<bool> {
  SMITrigger._(StateMachineTrigger input, StateMachineController controller)
      : super._(
          input,
          SMIType.trigger,
          controller,
        ) {
    controller.setInputValue(id, false);
  }

  void fire() => change(true);
  @override
  void advance() => change(false);
}

/// An AnimationController which controls a StateMachine and provides access to
/// the inputs of the StateMachine.
class StateMachineController extends core.StateMachineController {
  final List<SMIInput> _inputs = <SMIInput>[];

  /// A list of inputs available in the StateMachine.
  Iterable<SMIInput> get inputs => _inputs;

  StateMachineController(
    StateMachine stateMachine, {
    core.OnStateChange? onStateChange,
  }) : super(stateMachine, onStateChange: onStateChange) {
    isActive = true;
    for (final input in stateMachine.inputs) {
      switch (input.coreType) {
        case StateMachineNumberBase.typeKey:
          _inputs.add(SMINumber._(input as StateMachineNumber, this));
          break;
        case StateMachineBoolBase.typeKey:
          _inputs.add(SMIBool._(input as StateMachineBool, this));
          break;
        case StateMachineTriggerBase.typeKey:
          _inputs.add(SMITrigger._(input as StateMachineTrigger, this));
          break;
      }
    }
  }

  /// Instance a [StateMachineController] from an [artboard] with the given
  /// [stateMachineName]. Returns the [StateMachineController] or null if no
  /// [StateMachine] with [stateMachineName] is found.
  static StateMachineController? fromArtboard(
    Artboard artboard,
    String stateMachineName, {
    core.OnStateChange? onStateChange,
  }) {
    for (final animation in artboard.animations) {
      if (animation is StateMachine && animation.name == stateMachineName) {
        return StateMachineController(animation, onStateChange: onStateChange);
      }
    }
    return null;
  }

  /// Find an input with a specific backing type and a given name.
  SMIInput<T>? findInput<T>(String name) {
    for (final input in _inputs) {
      if (input._is<T>() && input.name == name) {
        return input as SMIInput<T>;
      }
    }
    return null;
  }

  /// Find an input of specific concrete input type, with a given name.
  T? findSMI<T>(String name) {
    for (final input in _inputs) {
      if (input is T && input.name == name) {
        return input as T;
      }
    }
    return null;
  }

  @override
  void advanceInputs() {
    for (final input in _inputs) {
      input.advance();
    }
  }
}
