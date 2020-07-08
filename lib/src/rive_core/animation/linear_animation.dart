import 'dart:collection';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';
import 'package:rive/src/rive_core/animation/loop.dart';
import 'package:rive/src/generated/animation/linear_animation_base.dart';
export 'package:rive/src/generated/animation/linear_animation_base.dart';

class LinearAnimation extends LinearAnimationBase {
  final _keyedObjects = HashMap<int, KeyedObject>();
  Iterable<KeyedObject> get keyedObjects => _keyedObjects.values;
  bool internalAddKeyedObject(KeyedObject object) {
    assert(
        object.objectId != null,
        'KeyedObject must be referencing a Core object '
        'before being added to an animation.');
    var value = _keyedObjects[object.objectId];
    if (value != null && value != object) {
      return false;
    }
    _keyedObjects[object.objectId] = object;
    return true;
  }

  void apply(double time, {double mix = 1, CoreContext coreContext}) {
    coreContext ??= context;
    for (final keyedObject in _keyedObjects.values) {
      keyedObject.apply(time, mix, coreContext);
    }
  }

  Loop get loop => Loop.values[loopValue];
  set loop(Loop value) => loopValue = value.index;
  @override
  void durationChanged(int from, int to) {}
  @override
  void enableWorkAreaChanged(bool from, bool to) {}
  @override
  void fpsChanged(int from, int to) {}
  @override
  void loopValueChanged(int from, int to) {}
  @override
  void speedChanged(double from, double to) {}
  @override
  void workEndChanged(int from, int to) {}
  @override
  void workStartChanged(int from, int to) {}
}
