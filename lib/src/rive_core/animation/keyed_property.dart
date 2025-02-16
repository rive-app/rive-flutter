import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyed_property_base.dart';
import 'package:rive/src/rive_core/animation/interpolating_keyframe.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';
import 'package:rive/src/rive_core/animation/keyframe.dart';
import 'package:stokanal/collections.dart';

import '../../../rive.dart';
import '../../generated/animation/nested_trigger_base.dart';

export 'package:rive/src/generated/animation/keyed_property_base.dart';

abstract class KeyFrameInterface {
  int get frame;
}

class KeyFrameList<T extends KeyFrameInterface> {

  var _keyframes = <T>[];
  List<T> get keyframes => _keyframes;
  set keyframes(Iterable<T> frames) => _keyframes = frames.toList();

  // T get firstKeyframe => _keyframes.first;

  // void remove(T keyframe) {
  //   _keyframes.remove(keyframe);
  //   onKeyframesChanged();
  // }

  void onKeyframesChanged() {}

  /// Get the keyframe immediately following the provided one.
  T? after(T keyframe) {
    var index = _keyframes.indexOf(keyframe);
    if (index != -1 && index + 1 < _keyframes.length) {
      return _keyframes[index + 1];
    }
    return null;
  }

  /// Find the index in the keyframe list of a specific time frame.
  int indexOfFrame(int frame) {
    int idx = 0;
    // Binary find the keyframe index.
    int mid = 0;
    int closestFrame = 0;
    int start = 0;
    int end = _keyframes.length - 1;

    while (start <= end) {
      mid = (start + end) >> 1;
      closestFrame = _keyframes[mid].frame;
      if (closestFrame < frame) {
        start = mid + 1;
      } else if (closestFrame > frame) {
        end = mid - 1;
      } else {
        idx = start = mid;
        break;
      }

      idx = start;
    }
    return idx;
  }

  void sort() {
    _keyframes.sort((a, b) => a.frame.compareTo(b.frame));
  }
}

class KeyedProperty extends KeyedPropertyBase<RuntimeArtboard>
    with KeyFrameList<KeyFrame> {

  /// STOKANAL-FORK-EDIT: Reuse this object for every animation
  @override
  K? clone<K extends Core>() => this as K;

  @override
  void onAdded() {}

  @override
  void onAddedDirty() {}

  /// Called by rive_core to add a KeyFrame to this KeyedProperty. This should
  /// be @internal when it's supported.
  bool internalAddKeyFrame(KeyFrame frame) {
    if (_keyframes.contains(frame)) {
      return false;
    }
    _keyframes.add(frame);
    markKeyFrameOrderDirty();
    onKeyframesChanged();
    return true;
  }

  /// Called by rive_core to remove a KeyFrame from this KeyedProperty. This
  /// should be @internal when it's supported.
  bool internalRemoveKeyFrame(KeyFrame frame) {
    var removed = _keyframes.remove(frame);
    if (_keyframes.isEmpty) {
      // If they keyframes are now empty, we might want to remove this keyed
      // property. Wait for any other pending changes to complete before
      // checking.
      context.dirty(_checkShouldRemove);
    } else {
      markKeyFrameOrderDirty();
    }
    onKeyframesChanged();

    return removed;
  }

  void _checkShouldRemove() {
    if (_keyframes.isEmpty) {
      // Remove this keyed property.
      context.removeObject(this);
    }
  }

  /// Called by keyframes when their time value changes. This is a pretty rare
  /// operation, usually occurs when a user moves a keyframe. Meaning: this
  /// shouldn't make it into the runtimes unless we want to allow users moving
  /// keyframes around at runtime via code for some reason.
  void markKeyFrameOrderDirty() {
    context.dirty(_sortAndValidateKeyFrames);
  }

  void _sortAndValidateKeyFrames() {
    sort();
  }

  /// Number of keyframes for this keyed property.
  int get numFrames => _keyframes.length;

  KeyFrame getFrameAt(int index) => _keyframes[index];

  /// Return from and to frames
  Pair<InterpolatingKeyFrame?, KeyFrame> _closestFramePair(double seconds) {

    // Binary find the keyframe index (use timeInSeconds here as opposed to the
    // finder above which operates in frames).
    final lastIndex = _keyframes.length - 1;

    // If it's the last keyframe, we skip the binary search
    final last = _keyframes[lastIndex];
    if (seconds >= last.seconds) {
      return Pair(null, last);
    }

    var first = _keyframes[0];
    if (seconds <= first.seconds) {
      return Pair(null, first);
    }

    int start = 1;
    int end = lastIndex;
    while (start <= end) {
      int mid = (start + end) >> 1;
      var keyframe = _keyframes[mid];
      if (keyframe.seconds < seconds) {
        start = mid + 1;
      } else if (keyframe.seconds > seconds) {
        end = mid - 1;
      } else {
        return Pair(null, keyframe);
      }
    }
    // if (start == 0) {
    //   throw Exception('start=0 not expected');
    // }
    // return Pair.of((start == 0 ? _keyframes[lastIndex] : _keyframes[start-1]) as InterpolatingKeyFrame, _keyframes[start]);
    return Pair(_keyframes[start-1] as InterpolatingKeyFrame, _keyframes[start]);
  }

  int _closestFrameIndex(double seconds, {int exactOffset = 0}) {

    // Binary find the keyframe index (use timeInSeconds here as opposed to the
    // finder above which operates in frames).
    var length = _keyframes.length;
    int end = length - 1;
    var totalSeconds = _keyframes[end].seconds;

    // If it's the last keyframe, we skip the binary search
    if (seconds > totalSeconds) {
      return end + 1;
    }

    if (seconds == totalSeconds) {
      return end + exactOffset;
    }
    if (seconds < _keyframes[0].seconds) {
      return 0;
    }
    int mid = (length * seconds/totalSeconds).toInt(); // try to guess an optimal starting seconds
    if (mid > end) {
      mid = end;
    }

    int start = 0;
    double closestSeconds;

    while (start <= end) {
      closestSeconds = _keyframes[mid].seconds;
      if (closestSeconds < seconds) {
        start = mid + 1;
      } else if (closestSeconds > seconds) {
        end = mid - 1;
      } else {
        return mid + exactOffset;
      }
      mid = (start + end) >> 1;
    }
    return start;
  }

  /// Original method (DO NOT DELETE FOR REFERENCE)
  // int closestFrameIndex(double seconds, {int exactOffset = 0}) {
  //   // Binary find the keyframe index (use timeInSeconds here as opposed to the
  //   // finder above which operates in frames).
  //   int mid = 0;
  //   double closestSeconds = 0;
  //   int start = 0;
  //   int end = _keyframes.length - 1;
  //
  //   // If it's the last keyframe, we skip the binary search
  //   if (seconds > _keyframes[end].seconds) {
  //     return end + 1;
  //   }
  //
  //   while (start <= end) {
  //     mid = (start + end) >> 1;
  //     closestSeconds = _keyframes[mid].seconds;
  //     if (closestSeconds < seconds) {
  //       start = mid + 1;
  //     } else if (closestSeconds > seconds) {
  //       end = mid - 1;
  //     } else {
  //       return mid + exactOffset;
  //     }
  //   }
  //   return start;
  // }

  bool get isCallback =>
      propertyKey == EventBase.triggerPropertyKey ||
      propertyKey == NestedTriggerBase.firePropertyKey;
      // RiveCoreContext.isCallback(propertyKey_);

  /// Report any keyframes that occured between secondsFrom and secondsTo.
  void reportKeyedCallbacks(
    int objectId,
    double secondsFrom,
    double secondsTo, {
    required KeyedCallbackReporter reporter,
    bool isAtStartFrame = false,
  }) {
    if (secondsFrom == secondsTo) {
      return;
    }
    bool isForward = secondsFrom <= secondsTo;
    int fromExactOffset = 0;
    int toExactOffset = isForward ? 1 : 0;
    if (isForward) {
      if (!isAtStartFrame) {
        fromExactOffset = 1;
      }
    } else {
      if (isAtStartFrame) {
        fromExactOffset = 1;
      }
    }
    int idx = _closestFrameIndex(secondsFrom, exactOffset: fromExactOffset);
    int idxTo = _closestFrameIndex(secondsTo, exactOffset: toExactOffset);

    // validate _closestFrameIndex method
    // int _idx = closestFrameIndex(secondsFrom, exactOffset: fromExactOffset);
    // int _idxTo = closestFrameIndex(secondsTo, exactOffset: toExactOffset);
    // if (_idx != idx || idxTo != _idxTo) {
    //   throw Exception('$_idx != $idx, $idxTo != $_idxTo');
    // }

    // going backwards?
    if (idxTo < idx) {
      var swap = idx;
      idx = idxTo;
      idxTo = swap;
    }

    while (idxTo > idx) {
      var frame = _keyframes[idx];
      reporter.reportKeyedCallback(
          objectId, propertyKey, secondsTo - frame.seconds);
      idx++;
    }
  }

  @override
  void onKeyframesChanged() {
    _seconds = -1;
    _pair = null;
  }

  double _seconds = -1;
  Pair<InterpolatingKeyFrame?, KeyFrame>? _pair;

  /// Apply keyframe values at a given time expressed in [seconds].
  void apply(double seconds, double mix, Core object) {
    if (_keyframes.length == 0) {
      return;
    }

    // var calculated = false;
    if (_seconds != seconds) { // if seconds coincide, return value from last run
      _seconds = seconds;
      _pair = _closestFramePair(seconds);
      // calculated = true;
    }

    // // validate _closestFrameIndex method
    // int idx = closestFrameIndex(seconds);
    // Pair<InterpolatingKeyFrame?, KeyFrame> pair;
    // if (idx == 0) {
    //   pair = Pair.of(null, _keyframes[0]);
    //   // _keyframes[0].apply(object, pk, mix);
    // } else {
    //   if (idx < _keyframes.length) {
    //     InterpolatingKeyFrame fromFrame = _keyframes[idx - 1] as InterpolatingKeyFrame;
    //     KeyFrame toFrame = _keyframes[idx];
    //     if (seconds == toFrame.seconds) {
    //       pair = Pair.of(null, toFrame);
    //       // toFrame.apply(object, pk, mix);
    //     } else {
    //       if (fromFrame.interpolationType == 0) {
    //         pair = Pair.of(fromFrame, toFrame);
    //         // fromFrame.apply(object, pk, mix);
    //       } else {
    //         pair = Pair.of(fromFrame, toFrame);
    //         // fromFrame.applyInterpolation(object, pk, seconds, toFrame, mix);
    //       }
    //     }
    //   } else {
    //     pair = Pair.of(null, _keyframes[idx - 1]);
    //     // _keyframes[idx - 1].apply(object, pk, mix);
    //   }
    // }
    // if (_pair != pair) {
    //   throw Exception('$_pair != $pair > calculated=$calculated keyframes=${_keyframes.length} idx=$idx index=${_keyframes.indexOf(_pair!.right)} ${_keyframes.indexOf(pair.right)}');
    // }

    var fromFrame = _pair!.key;

    if (fromFrame != null) { // interpolation
      if (fromFrame.interpolationType == 0) {
        fromFrame.apply(object, propertyBean, mix);
      } else {
        fromFrame.applyInterpolation(object, propertyBean, seconds, _pair!.value, mix);
      }
    } else {
      _pair!.value.apply(object, propertyBean, mix);
    }
  }

  // @override
  // void propertyKeyChanged(int from, int to) {}

  @override
  bool import(ImportStack stack) {
    var importer = stack.latest<KeyedObjectImporter>(KeyedObjectBase.typeKey);
    if (importer == null) {
      return false;
    }
    importer.addKeyedProperty(this);

    return super.import(stack);
  }
}
