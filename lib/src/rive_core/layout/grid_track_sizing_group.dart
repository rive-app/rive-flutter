import 'package:rive/src/generated/layout/grid_track_sizing_group_base.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/layout/track_sizing_function.dart';
import 'package:rive/src/rive_core/notifier.dart';
import 'package:rive_common/rive_taffy.dart';

export 'package:rive/src/generated/layout/grid_track_sizing_group_base.dart';

enum GridTrackSizingType { templateRow, templateColumn, autoRow, autoColumn }

class GridTrackSizingGroup extends GridTrackSizingGroupBase {
  TaffyGridTrackRepetitionTag get repeatType =>
      TaffyGridTrackRepetitionTag.values[repeatTag];

  GridTrackSizingType get trackType => GridTrackSizingType.values[trackTag];
  set trackType(GridTrackSizingType type) => trackTag = type.index;

  List<TrackSizingFunction> get sizingFunctions =>
      children.whereType<TrackSizingFunction>().toList();

  Notifier valueChanged = Notifier();

  @override
  void trackTagChanged(int from, int to) {}

  @override
  void isRepeatingChanged(bool from, bool to) {}

  @override
  void repeatTagChanged(int from, int to) {}

  @override
  void repeatCountChanged(int from, int to) {}

  @override
  void update(int dirt) {}

  @override
  void childAdded(Component child) {
    super.childAdded(child);
    if (child is TrackSizingFunction) {
      child.valueChanged.addListener(_sizingFunctionChanged);
    }
    _sizingFunctionChanged();
  }

  @override
  void childRemoved(Component child) {
    super.childRemoved(child);
    if (child is TrackSizingFunction) {
      child.valueChanged.removeListener(_sizingFunctionChanged);
    }
    _sizingFunctionChanged();
  }

  void _sizingFunctionChanged() {
    valueChanged.notify();
  }
}
