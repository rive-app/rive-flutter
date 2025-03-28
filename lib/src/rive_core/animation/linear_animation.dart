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

  bool isAnyObjectKeyed(Iterable<Core> objects) =>
      objects.any((element) => _keyedObjects.containsKey(element.id));

  bool isObjectKeyed(Core object) => _keyedObjects.containsKey(object.id);

  bool removeObjectKeys(Core object) {
    var value = _keyedObjects[object.id];
    if (value == null) {
      return false;
    }
    bool found = false;

    for (final kp in value.keyedProperties) {
      for (final kf in kp.keyframes){
        kf.remove();
        if (!found) {
          kp.onKeyframesChanged();
          found = true;
        }
      }
    }
    return found;
  }

  /// Returns the seconds where the animiation work area starts
  double get startSeconds => (enableWorkArea ? workStart : 0).toDouble() / fps;

  /// Returns the seconds where the animation work area ends
  double get endSeconds =>
      (enableWorkArea ? workEnd : duration).toDouble() / fps;

  /// Returns the length of the animation
  double get durationSeconds => endSeconds - startSeconds;

  /// Returns the end time of the animation in seconds, considering speed
  double get endTime => (speed >= 0) ? endSeconds : startSeconds;

  /// Returns the start time of the animation in seconds, considering speed
  double get startTime => (speed >= 0) ? startSeconds : endSeconds;

  /// STOKANAL-FORK-EDIT: iterate properties with a list rather than with a map
  late final List<KeyedObject> _objects = _keyedObjects.values.toList(growable: false);

  void reportKeyedCallbacks(
    double secondsFrom,
    double secondsTo, {
    required KeyedCallbackReporter reporter,
    int speedDirection = 1,
    bool fromPong = false,
  }) {
    // We have to account for the state machine speed multiplier and the speed
    double startingTime =
        ((speed * speedDirection) >= 0) ? startSeconds : endSeconds;
    bool isAtStartFrame = startingTime == secondsFrom;

    // Do not report a callback twice if it comes from the "pong" part of a
    // "ping pong" loop
    if (!isAtStartFrame || !fromPong) {
      // for (final keyedObject in _keyedObjects.values) {
      /// STOKANAL-FORK-EDIT: iterate properties with a list rather than with a map
      for (final keyedObject in _objects) {
        keyedObject.reportKeyedCallbacks(
          secondsFrom,
          secondsTo,
          reporter: reporter,
          isAtStartFrame: isAtStartFrame,
        );
      }
    }
  }

  /// Pass in a different [core] context if you want to apply the animation to a
  /// different instance. This isn't meant to be used yet but left as mostly a
  /// note to remember that at runtime we have to support applying animations to
  /// instances. We do a nice job of not duping all that data at runtime (so
  /// animations exist once but entire Rive file can be instanced multiple times
  /// playing different positions).
  void apply(double time, {required CoreContext coreContext, double mix = 1}) {
    if (quantize) {
      // ignore: parameter_assignments
      time = (time * fps).floor() / fps;
    }
    // for (final keyedObject in _keyedObjects.values) {
    /// STOKANAL-FORK-EDIT: iterate properties with a list rather than with a map
    var t = _objects.length;
    for (var i = 0; i < t; i++) {
      _objects[i].apply(time, mix, coreContext);
    }
    // for (final keyedObject in _objects) {
    //   keyedObject.apply(time, mix, coreContext);
    // }
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

  @override
  void quantizeChanged(bool from, bool to) {}

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
