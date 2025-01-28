import 'dart:collection';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';
import 'package:rive/src/rive_core/animation/linear_animation_instance.dart'
    as core;
import 'package:rive/src/rive_core/event.dart';
import 'package:rive/src/runtime_mounted_artboard.dart';
export 'package:rive/src/runtime_mounted_artboard.dart';

/// An AnimationController which controls a StateMachine and provides access to
/// the inputs of the StateMachine.
class LinearAnimationInstance extends core.LinearAnimationInstance
    with RuntimeEventReporter, KeyedCallbackReporter {
  final _runtimeEventListeners = HashSet<OnRuntimeEvent>(); // {};
  late CoreContext? context;

  LinearAnimationInstance(animation,
      {double speedMultiplier = 1.0, this.context})
      : super(animation, speedMultiplier: speedMultiplier);

  @override
  void addRuntimeEventListener(OnRuntimeEvent callback) =>
      _runtimeEventListeners.add(callback);

  @override
  void removeRuntimeEventListener(OnRuntimeEvent callback) =>
      _runtimeEventListeners.remove(callback);

  @override
  void reportEvent(Event event) {
    _runtimeEventListeners.toList().forEach((callback) {
      callback(event);
    });
  }

  @override
  void reportKeyedCallback(
      int objectId, int propertyKey, double elapsedSeconds) {
    var coreObject = context?.resolve(objectId);
    if (coreObject != null) {
      RiveCoreContext.setCallback(
        coreObject,
        propertyKey,
        CallbackData(this, delay: elapsedSeconds),
      );
    }
  }
}
