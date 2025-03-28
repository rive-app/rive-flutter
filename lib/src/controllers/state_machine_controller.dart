import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_bool.dart';
import 'package:rive/src/rive_core/animation/state_machine_input.dart' as core;
import 'package:rive/src/rive_core/animation/state_machine_number.dart';
import 'package:rive/src/rive_core/animation/state_machine_trigger.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart' as core;
import 'package:rive/src/runtime_mounted_artboard.dart';

export 'package:rive/src/runtime_mounted_artboard.dart';

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
class StateMachineController extends core.StateMachineController
    with RuntimeEventReporter {

  /// A list of inputs available in the StateMachine.
  @nonVirtual
  final List<SMIInput> inputs = <SMIInput>[];

  // /// A list of inputs available in the StateMachine.
  // Iterable<SMIInput> get inputs => _inputs;

  final _runtimeEventListeners = <OnRuntimeEvent>{};

  StateMachineController(
    StateMachine stateMachine, {
    core.OnStateChange? onStateChange,
    // ignore: deprecated_member_use_from_same_package
  }) : super(stateMachine, onStateChange: onStateChange) {
    isActive = true;
    for (final input in stateMachine.inputs) {
      switch (input.coreType) {
        case StateMachineNumberBase.typeKey:
          inputs.add(SMINumber._(input as StateMachineNumber, this));
          break;
        case StateMachineBoolBase.typeKey:
          inputs.add(SMIBool._(input as StateMachineBool, this));
          break;
        case StateMachineTriggerBase.typeKey:
          inputs.add(SMITrigger._(input as StateMachineTrigger, this));
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
        final controller =
            StateMachineController(animation, onStateChange: onStateChange);
        if (artboard is RuntimeArtboard) {
          artboard.addNestedEventListener(controller);
        }
        return controller;
      }
    }
    return null;
  }

  /// Find an input with a specific backing type and a given name.
  ///
  /// For easier to use methods, see [getBoolInput], [getTriggerInput],
  /// [getNumberInput].
  SMIInput<T>? findInput<T>(String name) {
    for (final input in inputs) {
      if (input._is<T>() && input.name == name) {
        return input as SMIInput<T>;
      }
    }
    return null;
  }

  /// Find an input of specific concrete input type, with a given name.
  ///
  /// For easier to use methods, see [getBoolInput], [getTriggerInput],
  /// [getNumberInput].
  T? findSMI<T>(String name) {
    for (final input in inputs) {
      if (input is T && input.name == name) {
        return input as T;
      }
    }
    return null;
  }

  /// Find a boolean input with a given name.
  SMIBool? getBoolInput(String name) => findSMI<SMIBool>(name);

  /// Find a trigger input with a given name.
  SMITrigger? getTriggerInput(String name) => findSMI<SMITrigger>(name);

  /// Find a number input with a given name.
  ///
  /// See [triggerInput] to directly fire a trigger by its name.
  SMINumber? getNumberInput(String name) => findSMI<SMINumber>(name);

  /// Convenience method for firing a trigger input with a given name.
  ///
  /// Also see [getTriggerInput] to get a reference to the trigger input. If the
  /// trigger happens frequently, it's more efficient to get a reference to the
  /// trigger input and call `trigger.fire()` directly.
  void triggerInput(String name) => getTriggerInput(name)?.fire();

  @override
  void advanceInputs() {
    final t = inputs.length;
    for (var i = 0; i < t; i++) {
    // for (final input in _inputs) {
      inputs[i].advance();
      // input.advance();
    }
  }

  @override
  void addRuntimeEventListener(OnRuntimeEvent callback) =>
      _runtimeEventListeners.add(callback);

  @override
  void removeRuntimeEventListener(OnRuntimeEvent callback) =>
      _runtimeEventListeners.remove(callback);

  @override
  void applyEvents() {
    super.applyEvents();

    for (final event in _runtimeEventListeners) {
      // reportedEvents.forEach(event);

      var list = reportedEvents;
      var t = list.length;
      for (var i = 0; i < t; i++) {
        event(list[i]);
      }
    }
  }
}
