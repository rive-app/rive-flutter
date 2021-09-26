import 'dart:collection';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/linear_animation_base.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';
import 'package:rive/src/rive_core/animation/loop.dart';
import 'package:rive/src/rive_core/artboard.dart';

export 'package:rive/src/generated/animation/linear_animation_base.dart';

class LinearAnimation extends LinearAnimationBase {
  /// Map objectId to KeyedObject. N.B. this is the id of the object that we
  /// want to key in core, not of the KeyedObject. It's a clear way to see if an
  /// object is keyed in this animation.
  final _keyedObjects = HashMap<int, KeyedObject>();

  /// The metadata for the objects that are keyed in this animation.
  Iterable<KeyedObject> get keyedObjects => _keyedObjects.values;

  /// Called by rive_core to add a KeyedObject to the animation. This should be
  /// @internal when it's supported.
  bool internalAddKeyedObject(KeyedObject object) {
    if (internalCheckAddKeyedObject(object)) {
      _keyedObjects[object.objectId] = object;
      return true;
    }
    return false;
  }

  bool internalCheckAddKeyedObject(KeyedObject object) {
    var value = _keyedObjects[object.objectId];

    // If the object is already keyed, that's ok just make sure the KeyedObject
    // matches.
    if (value != null && value != object) {
      return false;
    }
    return true;
  }

  double get startSeconds => (enableWorkArea ? workStart : 0).toDouble() / fps;
  double get endSeconds =>
      (enableWorkArea ? workEnd : duration).toDouble() / fps;
  double get durationSeconds => endSeconds - startSeconds;

  /// Pass in a different [core] context if you want to apply the animation to a
  /// different instance. This isn't meant to be used yet but left as mostly a
  /// note to remember that at runtime we have to support applying animations to
  /// instances. We do a nice job of not duping all that data at runtime (so
  /// animations exist once but entire Rive file can be instanced multiple times
  /// playing different positions).
  void apply(double time, {required CoreContext coreContext, double mix = 1}) {
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

  /// Returns the end time of the animation in seconds
  double get endTime => (enableWorkArea ? workEnd : duration).toDouble() / fps;

  /// Returns the start time of the animation in seconds
  double get startTime => (enableWorkArea ? workStart : 0).toDouble() / fps;

  /// Convert a global clock to local seconds (takes into consideration work
  /// area start/end, speed, looping).
  double globalToLocalTime(double seconds) {
    switch (loop) {
      case Loop.oneShot:
        return seconds + startTime;
      case Loop.loop:
        return seconds % (endTime - startTime) + startTime;
      case Loop.pingPong:
        var localTime = seconds % (endTime - startTime);
        var direction = (seconds ~/ (endTime - startTime)) % 2;
        return direction == 0 ? localTime + startTime : endTime - localTime;
    }
  }

  @override
  bool import(ImportStack stack) {
    var artboardImporter = stack.latest<ArtboardImporter>(ArtboardBase.typeKey);
    if (artboardImporter == null) {
      return false;
    }
    artboardImporter.addAnimation(this);

    return super.import(stack);
  }
}
