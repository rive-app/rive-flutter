import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/nested_state_machine_base.dart';
import 'package:rive/src/rive_core/animation/nested_bool.dart';
import 'package:rive/src/rive_core/animation/nested_input.dart';
import 'package:rive/src/rive_core/animation/nested_number.dart';
import 'package:rive/src/rive_core/nested_artboard.dart';
import 'package:rive/src/rive_core/state_machine_controller.dart';
import 'package:rive_common/math.dart';

export 'package:rive/src/generated/animation/nested_state_machine_base.dart';

abstract class NestedStateMachineInstance {
  bool get isActive;
  ValueListenable<bool> get isActiveChanged;

  void apply(covariant MountedArtboard artboard, double elapsedSeconds);

  bool hitTest(Vec2D position);

  HitResult pointerMove(Vec2D position);

  HitResult pointerDown(Vec2D position, PointerDownEvent event);

  HitResult pointerUp(Vec2D position);

  HitResult pointerExit(Vec2D position);

  dynamic getInputValue(int id);
  void setInputValue(int id, dynamic value);
}

class NestedStateMachine extends NestedStateMachineBase {
  @override
  bool advance(double elapsedSeconds, MountedArtboard mountedArtboard) {
    _stateMachineInstance?.apply(mountedArtboard, elapsedSeconds);
    return isEnabled;
  }

  @override
  bool get isEnabled => _stateMachineInstance?.isActive ?? false;

  final Set<NestedInput> _nestedInputs = HashSet<NestedInput>();//{};
  Set<NestedInput> get nestedInputs => _nestedInputs;

  NestedStateMachineInstance? _stateMachineInstance;
  NestedStateMachineInstance? get stateMachineInstance => _stateMachineInstance;
  set stateMachineInstance(NestedStateMachineInstance? value) {
    if (_stateMachineInstance == value) {
      return;
    }
    var from = _stateMachineInstance;
    _stateMachineInstance = value;
    stateMachineInstanceChanged(from, value);

    for (final input in nestedInputs) {
      if (input is NestedBool || input is NestedNumber) {
        input.updateValue();
      }
    }
  }

  void stateMachineInstanceChanged(
      NestedStateMachineInstance? from, NestedStateMachineInstance? to) {
    from?.isActiveChanged.removeListener(_isActiveChanged);
    to?.isActiveChanged.addListener(_isActiveChanged);
  }

  dynamic getInputValue(int id) {
    int inputId = id;

    _stateMachineInstance?.getInputValue(inputId);
  }

  void setInputValue(int id, dynamic value) {
    int inputId = id;

    _stateMachineInstance?.setInputValue(inputId, value);
  }

  bool hitTest(Vec2D position) =>
      _stateMachineInstance?.hitTest(position) ?? false;

  HitResult pointerMove(Vec2D position) =>
      _stateMachineInstance?.pointerMove(position) ?? HitResult.none;

  HitResult pointerDown(Vec2D position, PointerDownEvent event) =>
      _stateMachineInstance?.pointerDown(position, event) ?? HitResult.none;

  HitResult pointerUp(Vec2D position) =>
      _stateMachineInstance?.pointerUp(position) ?? HitResult.none;

  HitResult pointerExit(Vec2D position) =>
      _stateMachineInstance?.pointerExit(position) ?? HitResult.none;

  void _isActiveChanged() {
    // When a nested state machine re-activates (usually when an input changes)
    // we need to make sure any nesting artboard knows that we're goign to need
    // to advance.
    if (stateMachineInstance != null && stateMachineInstance!.isActive) {
      nestedArtboard?.markNeedsAdvance();
    }
  }

  @override
  void onRemoved() {
    stateMachineInstance = null;
    super.onRemoved();
  }
}
