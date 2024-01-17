import 'package:rive/src/generated/layout/track_sizing_function_base.dart';
import 'package:rive/src/rive_core/notifier.dart';
import 'package:rive_common/rive_taffy.dart';

export 'package:rive/src/generated/layout/track_sizing_function_base.dart';

class TrackSizingFunction extends TrackSizingFunctionBase {
  TaffyMinTrackSizingFunctionTag get minType =>
      TaffyMinTrackSizingFunctionTag.values[minTypeTag];

  TaffyDimensionTag get minValueType => TaffyDimensionTag.values[minValueTag];

  TaffyMaxTrackSizingFunctionTag get maxType =>
      TaffyMaxTrackSizingFunctionTag.values[maxTypeTag];

  TaffyDimensionTag get maxValueType => TaffyDimensionTag.values[maxValueTag];

  Notifier valueChanged = Notifier();

  @override
  void minTypeTagChanged(int from, int to) {
    _notifyValueChanged();
  }

  @override
  void minValueTagChanged(int from, int to) {
    _notifyValueChanged();
  }

  @override
  void minValueChanged(double from, double to) {
    _notifyValueChanged();
  }

  @override
  void maxTypeTagChanged(int from, int to) {
    _notifyValueChanged();
  }

  @override
  void maxValueTagChanged(int from, int to) {
    _notifyValueChanged();
  }

  @override
  void maxValueChanged(double from, double to) {
    _notifyValueChanged();
  }

  @override
  void update(int dirt) {}

  void _notifyValueChanged() {
    valueChanged.notify();
  }
}
