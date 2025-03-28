import 'package:rive/src/generated/animation/cubic_interpolator_component_base.dart';
import 'package:rive/src/rive_core/animation/cubic_ease_interpolator.dart';
import 'package:rive/src/rive_core/animation/cubic_interpolator.dart';
import 'package:rive/src/rive_core/animation/interpolator.dart';
import 'package:rive/src/rive_core/component_dirt.dart';

export 'package:rive/src/generated/animation/cubic_interpolator_component_base.dart';

class CubicInterpolatorComponent extends CubicInterpolatorComponentBase
    implements Interpolator, CubicInterface {
  CubicEase _ease = CubicEase.make(0.42, 0, 0.58, 1);

  @override
  bool get late => false;

  @override
  void update(int dirt) {}

  @override
  void x1Changed(double from, double to) => _updateStoredCubic();

  @override
  void x2Changed(double from, double to) => _updateStoredCubic();

  @override
  void y1Changed(double from, double to) => _updateStoredCubic();

  @override
  void y2Changed(double from, double to) => _updateStoredCubic();

  @override
  bool equalParameters(Interpolator other) {
    if (other is CubicInterpolatorComponent) {
      return x1 == other.x1 &&
          x2 == other.x2 &&
          y1 == other.y1 &&
          y2 == other.y2;
    }
    return false;
  }

  @override
  double transform(double value) => _ease.transform(value);

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    _updateStoredCubic();
  }

  @override
  double transformValue(double from, double to, double value) =>
      from + (to - from) * _ease.transform(value);

  void _updateStoredCubic() {
    _ease = CubicEase.make(x1, y1, x2, y2);

    parent?.onDirty(ComponentDirt.interpolator);
  }
}
