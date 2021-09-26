import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/keyed_property_base.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';
import 'package:rive/src/rive_core/animation/keyframe.dart';

export 'package:rive/src/generated/animation/keyed_property_base.dart';

abstract class KeyFrameInterface {
  int get frame;
}

class KeyFrameList<T extends KeyFrameInterface> {
  List<T> _keyframes = [];
  List<T> get keyframes => _keyframes;
  set keyframes(Iterable<T> frames) => _keyframes = frames.toList();

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

  void sort() => _keyframes.sort((a, b) => a.frame.compareTo(b.frame));
}

class KeyedProperty extends KeyedPropertyBase<RuntimeArtboard>
    with KeyFrameList<KeyFrame> {
  @override
  void onAdded() {}

  @override
  void onAddedDirty() {}

  @override
  void onRemoved() {
    super.onRemoved();
  }

  /// Called by rive_core to add a KeyFrame to this KeyedProperty. This should
  /// be @internal when it's supported.
  bool internalAddKeyFrame(KeyFrame frame) {
    if (_keyframes.contains(frame)) {
      return false;
    }
    _keyframes.add(frame);
    markKeyFrameOrderDirty();
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
    }

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

    for (int i = 0; i < _keyframes.length - 1; i++) {
      var a = _keyframes[i];
      var b = _keyframes[i + 1];
      if (a.frame == b.frame) {
        // N.B. this removes it from the list too.
        context.removeObject(a);
        // Repeat current.
        i--;
      }
    }
  }

  /// Number of keyframes for this keyed property.
  int get numFrames => _keyframes.length;

  KeyFrame getFrameAt(int index) => _keyframes[index];

  int closestFrameIndex(double seconds) {
    int idx = 0;
    // Binary find the keyframe index (use timeInSeconds here as opposed to the
    // finder above which operates in frames).
    int mid = 0;
    double closestSeconds = 0;
    int start = 0;
    int end = _keyframes.length - 1;

    while (start <= end) {
      mid = (start + end) >> 1;
      closestSeconds = _keyframes[mid].seconds;
      if (closestSeconds < seconds) {
        start = mid + 1;
      } else if (closestSeconds > seconds) {
        end = mid - 1;
      } else {
        idx = start = mid;
        break;
      }
      idx = start;
    }
    return idx;
  }

  void apply(double seconds, double mix, Core object) {
    if (_keyframes.isEmpty) {
      return;
    }

    int idx = closestFrameIndex(seconds);
    int pk = propertyKey;
    if (idx == 0) {
      var first = _keyframes[0];

      first.apply(object, pk, mix);
    } else {
      if (idx < _keyframes.length) {
        KeyFrame fromFrame = _keyframes[idx - 1];
        KeyFrame toFrame = _keyframes[idx];
        if (seconds == toFrame.seconds) {
          toFrame.apply(object, pk, mix);
        } else {
          /// Equivalent to fromFrame.interpolation ==
          /// KeyFrameInterpolation.hold.
          if (fromFrame.interpolationType == 0) {
            fromFrame.apply(object, pk, mix);
          } else {
            fromFrame.applyInterpolation(object, pk, seconds, toFrame, mix);
          }
        }
      } else {
        var last = _keyframes[idx - 1];

        last.apply(object, pk, mix);
      }
    }
  }

  @override
  void propertyKeyChanged(int from, int to) {}

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
