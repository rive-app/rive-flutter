import 'package:flutter/foundation.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/nested_state_machine_base.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/nested_artboard.dart';

export 'package:rive/src/generated/animation/nested_state_machine_base.dart';

abstract class NestedStateMachineInstance {
  bool get isActive;
  ValueListenable<bool> get isActiveChanged;

  void apply(covariant MountedArtboard artboard, double elapsedSeconds);

  void pointerMove(Vec2D position);

  void pointerDown(Vec2D position);

  void pointerUp(Vec2D position);

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

  NestedStateMachineInstance? _stateMachineInstance;
  NestedStateMachineInstance? get stateMachineInstance => _stateMachineInstance;
  set stateMachineInstance(NestedStateMachineInstance? value) {
    if (_stateMachineInstance == value) {
      return;
    }
    var from = _stateMachineInstance;
    _stateMachineInstance = value;
    stateMachineInstanceChanged(from, value);
  }

  void stateMachineInstanceChanged(
      NestedStateMachineInstance? from, NestedStateMachineInstance? to) {
    from?.isActiveChanged.removeListener(_isActiveChanged);
    to?.isActiveChanged.addListener(_isActiveChanged);
  }

  void setInputValue(int id, dynamic value) {
    int inputId = id;

    _stateMachineInstance?.setInputValue(inputId, value);
  }

  void pointerMove(Vec2D position) =>
      _stateMachineInstance?.pointerMove(position);

  void pointerDown(Vec2D position) =>
      _stateMachineInstance?.pointerDown(position);

  void pointerUp(Vec2D position) => _stateMachineInstance?.pointerUp(position);

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
