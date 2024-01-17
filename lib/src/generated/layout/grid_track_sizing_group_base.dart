// Core automatically generated
// lib/src/generated/layout/grid_track_sizing_group_base.dart.
// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/container_component.dart';

abstract class GridTrackSizingGroupBase extends ContainerComponent {
  static const int typeKey = 177;
  @override
  int get coreType => GridTrackSizingGroupBase.typeKey;
  @override
  Set<int> get coreTypes => {
        GridTrackSizingGroupBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// TrackTag field with key 465.
  static const int trackTagPropertyKey = 465;
  static const int trackTagInitialValue = 0;
  int _trackTag = trackTagInitialValue;

  /// Track type (templateRow|templateColumn|autoRow|autoColumn).
  int get trackTag => _trackTag;

  /// Change the [_trackTag] field value.
  /// [trackTagChanged] will be invoked only if the field's value has changed.
  set trackTag(int value) {
    if (_trackTag == value) {
      return;
    }
    int from = _trackTag;
    _trackTag = value;
    if (hasValidated) {
      trackTagChanged(from, value);
    }
  }

  void trackTagChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// IsRepeating field with key 466.
  static const int isRepeatingPropertyKey = 466;
  static const bool isRepeatingInitialValue = false;
  bool _isRepeating = isRepeatingInitialValue;

  /// Whether this sizing function repeats. If no, ignore repeatTag and
  /// repeatCount and use the first item in the sizingFunctions list.
  bool get isRepeating => _isRepeating;

  /// Change the [_isRepeating] field value.
  /// [isRepeatingChanged] will be invoked only if the field's value has
  /// changed.
  set isRepeating(bool value) {
    if (_isRepeating == value) {
      return;
    }
    bool from = _isRepeating;
    _isRepeating = value;
    if (hasValidated) {
      isRepeatingChanged(from, value);
    }
  }

  void isRepeatingChanged(bool from, bool to);

  /// --------------------------------------------------------------------------
  /// RepeatTag field with key 467.
  static const int repeatTagPropertyKey = 467;
  static const int repeatTagInitialValue = 0;
  int _repeatTag = repeatTagInitialValue;

  /// Repeat tag (autoFill|autoFit|count).
  int get repeatTag => _repeatTag;

  /// Change the [_repeatTag] field value.
  /// [repeatTagChanged] will be invoked only if the field's value has changed.
  set repeatTag(int value) {
    if (_repeatTag == value) {
      return;
    }
    int from = _repeatTag;
    _repeatTag = value;
    if (hasValidated) {
      repeatTagChanged(from, value);
    }
  }

  void repeatTagChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// RepeatCount field with key 468.
  static const int repeatCountPropertyKey = 468;
  static const int repeatCountInitialValue = 0;
  int _repeatCount = repeatCountInitialValue;

  /// Number of times to repeat if repeatTag is set to count
  int get repeatCount => _repeatCount;

  /// Change the [_repeatCount] field value.
  /// [repeatCountChanged] will be invoked only if the field's value has
  /// changed.
  set repeatCount(int value) {
    if (_repeatCount == value) {
      return;
    }
    int from = _repeatCount;
    _repeatCount = value;
    if (hasValidated) {
      repeatCountChanged(from, value);
    }
  }

  void repeatCountChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is GridTrackSizingGroupBase) {
      _trackTag = source._trackTag;
      _isRepeating = source._isRepeating;
      _repeatTag = source._repeatTag;
      _repeatCount = source._repeatCount;
    }
  }
}
