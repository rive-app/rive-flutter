import 'dart:ui' as ui;
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/generated/shapes/paint/gradient_stop_base.dart';
import 'package:rive/src/rive_core/shapes/paint/linear_gradient.dart';
export 'package:rive/src/generated/shapes/paint/gradient_stop_base.dart';

class GradientStop extends GradientStopBase {
  @override
  Component get timelineParent =>
      _gradient is LinearGradient ? _gradient.parent : null;
  @override
  String get timelineName =>
      'Stop ${_gradient.gradientStops.indexOf(this) + 1}';
  LinearGradient _gradient;
  LinearGradient get gradient => _gradient;
  ui.Color get color => ui.Color(colorValue);
  set color(ui.Color c) {
    colorValue = c.value;
  }

  @override
  void positionChanged(double from, double to) {
    _gradient?.markStopsDirty();
  }

  @override
  void colorValueChanged(int from, int to) {
    _gradient?.markGradientDirty();
  }

  @override
  void update(int dirt) {}
  @override
  void parentChanged(ContainerComponent from, ContainerComponent to) {
    super.parentChanged(from, to);
    if (parent is LinearGradient) {
      _gradient = parent as LinearGradient;
    } else {
      _gradient = null;
    }
  }
}
