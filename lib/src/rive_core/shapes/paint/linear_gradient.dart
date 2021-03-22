import 'dart:ui' as ui;
import 'package:meta/meta.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/shapes/paint/gradient_stop.dart';
import 'package:rive/src/rive_core/shapes/paint/shape_paint_mutator.dart';
import 'package:rive/src/generated/shapes/paint/linear_gradient_base.dart';
export 'package:rive/src/generated/shapes/paint/linear_gradient_base.dart';

class _UnknownGradient extends LinearGradient {}

class LinearGradient extends LinearGradientBase with ShapePaintMutator {
  final List<GradientStop> gradientStops = [];
  static final LinearGradient unknown = _UnknownGradient();
  bool _paintsInWorldSpace = true;
  bool get paintsInWorldSpace => _paintsInWorldSpace;
  set paintsInWorldSpace(bool value) {
    if (_paintsInWorldSpace == value) {
      return;
    }
    _paintsInWorldSpace = value;
    addDirt(ComponentDirt.paint);
  }

  Vec2D get start => Vec2D.fromValues(startX, startY);
  Vec2D get end => Vec2D.fromValues(endX, endY);
  ui.Offset get startOffset => ui.Offset(startX, startY);
  ui.Offset get endOffset => ui.Offset(endX, endY);
  @override
  void buildDependencies() {
    super.buildDependencies();
    shapePaintContainer.addDependent(this);
  }

  @override
  void childAdded(Component child) {
    super.childAdded(child);
    if (child is GradientStop && !gradientStops.contains(child)) {
      gradientStops.add(child);
      markStopsDirty();
    }
  }

  @override
  void childRemoved(Component child) {
    super.childRemoved(child);
    if (child is GradientStop && gradientStops.contains(child)) {
      gradientStops.remove(child);
      markStopsDirty();
    }
  }

  void markStopsDirty() => addDirt(ComponentDirt.stops | ComponentDirt.paint);
  void markGradientDirty() => addDirt(ComponentDirt.paint);
  @override
  void update(int dirt) {
    bool stopsChanged = dirt & ComponentDirt.stops != 0;
    if (stopsChanged) {
      gradientStops.sort((a, b) => a.position.compareTo(b.position));
    }
    bool worldTransformed = dirt & ComponentDirt.worldTransform != 0;
    bool localTransformed = dirt & ComponentDirt.transform != 0;
    var rebuildGradient = dirt & ComponentDirt.paint != 0 ||
        localTransformed ||
        (paintsInWorldSpace && worldTransformed);
    if (rebuildGradient) {
      var colors = <ui.Color>[];
      var colorPositions = <double>[];
      for (final stop in gradientStops) {
        colors.add(stop.color);
        colorPositions.add(stop.position);
      }
      if (paintsInWorldSpace) {
        var world = shapePaintContainer.worldTransform;
        var worldStart = Vec2D.transformMat2D(Vec2D(), start, world);
        var worldEnd = Vec2D.transformMat2D(Vec2D(), end, world);
        paint.shader = makeGradient(ui.Offset(worldStart[0], worldStart[1]),
            ui.Offset(worldEnd[0], worldEnd[1]), colors, colorPositions);
      } else {
        paint.shader =
            makeGradient(startOffset, endOffset, colors, colorPositions);
      }
    }
  }

  @protected
  ui.Gradient makeGradient(ui.Offset start, ui.Offset end,
          List<ui.Color> colors, List<double> colorPositions) =>
      ui.Gradient.linear(start, end, colors, colorPositions);
  @override
  void startXChanged(double from, double to) {
    addDirt(ComponentDirt.transform);
  }

  @override
  void startYChanged(double from, double to) {
    addDirt(ComponentDirt.transform);
  }

  @override
  void endXChanged(double from, double to) {
    addDirt(ComponentDirt.transform);
  }

  @override
  void endYChanged(double from, double to) {
    addDirt(ComponentDirt.transform);
  }

  @override
  void opacityChanged(double from, double to) {
    syncColor();
    shapePaintContainer.addDirt(ComponentDirt.paint);
  }

  @override
  void syncColor() {
    paint.color = const ui.Color(0xFFFFFFFF)
        .withOpacity((opacity * renderOpacity).clamp(0, 1).toDouble());
  }
}
