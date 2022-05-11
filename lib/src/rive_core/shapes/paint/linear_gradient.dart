import 'dart:ui' as ui;

import 'package:meta/meta.dart';
import 'package:rive/src/generated/shapes/paint/linear_gradient_base.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/shapes/paint/gradient_stop.dart';
import 'package:rive/src/rive_core/shapes/paint/shape_paint_mutator.dart';
import 'package:rive/src/rive_core/shapes/shape.dart';

export 'package:rive/src/generated/shapes/paint/linear_gradient_base.dart';

/// A core linear gradient. Can be added as a child to a [Shape]'s [Fill] or
/// [Stroke] to paint that Fill or Stroke with a gradient. This is the
/// foundation for the RadialGradient which is very similar but also has a
/// radius value.
class LinearGradient extends LinearGradientBase with ShapePaintMutator {
  /// Stored list of core gradient stops are in the hierarchy as children of
  /// this container.
  final List<GradientStop> gradientStops = [];

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

  /// Gradients depends on their shape.
  @override
  void buildDependencies() {
    super.buildDependencies();
    shapePaintContainer?.addDependent(this);
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

  /// Mark the gradient stops as changed. This will re-sort the stops and
  /// rebuild the necessary gradients in the next update cycle.
  void markStopsDirty() => addDirt(ComponentDirt.stops | ComponentDirt.paint);

  /// Mark the gradient as needing to be rebuilt. This is a more efficient
  /// version of markStopsDirty as it won't re-sort the stops.
  void markGradientDirty() => addDirt(ComponentDirt.paint);

  @override
  void update(int dirt) {
    // Do the stops need to be re-ordered?
    bool stopsChanged = dirt & ComponentDirt.stops != 0;
    if (stopsChanged) {
      gradientStops.sort((a, b) => a.position.compareTo(b.position));
    }

    bool worldTransformed = dirt & ComponentDirt.worldTransform != 0;
    bool localTransformed = dirt & ComponentDirt.transform != 0;

    // We rebuild the gradient if the gradient is dirty or we paint in world
    // space and the world space transform has changed, or the local transform
    // has changed. Local transform changes when a stop moves in local space.
    var rebuildGradient = dirt & ComponentDirt.paint != 0 ||
        localTransformed ||
        (paintsInWorldSpace && worldTransformed);
    if (rebuildGradient) {
      // build up the color and positions lists
      var colors = <ui.Color>[];
      var colorPositions = <double>[];
      for (final stop in gradientStops) {
        colors.add(stop.color);
        colorPositions.add(stop.position);
      }
      // Check if we need to update the world space gradient.
      if (paintsInWorldSpace) {
        // Get the start and end of the gradient in world coordinates (world
        // transform of the shape).
        var world = shapePaintContainer!.worldTransform;
        var worldStart = world * start;
        var worldEnd = world * end;
        paint.shader = makeGradient(ui.Offset(worldStart.x, worldStart.y),
            ui.Offset(worldEnd.x, worldEnd.y), colors, colorPositions);
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
  void onAdded() {
    super.onAdded();
    syncColor();
  }

  @override
  void opacityChanged(double from, double to) {
    syncColor();
    // We don't need to rebuild anything, just let our shape know we should
    // repaint.
    shapePaintContainer!.addDirt(ComponentDirt.paint);
  }

  @override
  void syncColor() {
    super.syncColor();
    paint.color = const ui.Color(0xFFFFFFFF)
        .withOpacity((opacity * renderOpacity).clamp(0, 1).toDouble());
  }

  @override
  bool validate() => super.validate() && shapePaintContainer != null;
}
