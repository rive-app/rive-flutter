import 'dart:ui';

import 'package:rive/src/generated/shapes/paint/trim_path_base.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/shapes/paint/stroke.dart';
import 'package:rive/src/rive_core/shapes/paint/stroke_effect.dart';
import 'package:rive/src/rive_core/shapes/paint/trim_path_drawing.dart';

export 'package:rive/src/generated/shapes/paint/trim_path_base.dart';

enum TrimPathMode {
  none,
  sequential,
  synchronized,
}

class TrimPath extends TrimPathBase implements StrokeEffect {
  final Path _trimmedPath = Path();
  Path? _renderPath;
  @override
  Path effectPath(Path source) {
    if (_renderPath != null) {
      return _renderPath!;
    }
    _trimmedPath.reset();
    var isSequential = mode == TrimPathMode.sequential;
    double renderStart = start.clamp(0, 1).toDouble();
    double renderEnd = end.clamp(0, 1).toDouble();

    bool inverted = renderStart > renderEnd;
    if ((renderStart - renderEnd).abs() != 1.0) {
      renderStart = (renderStart + offset) % 1.0;
      renderEnd = (renderEnd + offset) % 1.0;

      if (renderStart < 0) {
        renderStart += 1.0;
      }
      if (renderEnd < 0) {
        renderEnd += 1.0;
      }
      if (inverted) {
        final double swap = renderEnd;
        renderEnd = renderStart;
        renderStart = swap;
      }
      if (renderEnd >= renderStart) {
        updateTrimPath(
            source, _trimmedPath, renderStart, renderEnd, false, isSequential);
      } else {
        updateTrimPath(
            source, _trimmedPath, renderEnd, renderStart, true, isSequential);
      }
    } else {
      return _renderPath = source;
    }
    return _renderPath = _trimmedPath;
  }

  Stroke? get stroke => parent as Stroke?;

  TrimPathMode get mode => TrimPathMode.values[modeValue];
  set mode(TrimPathMode value) => modeValue = value.index;

  @override
  void invalidateEffect() {
    _renderPath = null;
    stroke?.shapePaintContainer?.addDirt(ComponentDirt.paint);
  }

  @override
  void endChanged(double from, double to) => invalidateEffect();

  @override
  void modeValueChanged(int from, int to) => invalidateEffect();

  @override
  void offsetChanged(double from, double to) => invalidateEffect();

  @override
  void startChanged(double from, double to) => invalidateEffect();

  @override
  void update(int dirt) {}

  @override
  void onAdded() {
    super.onAdded();
    stroke?.addStrokeEffect(this);
    _renderPath = null;
  }

  @override
  void onRemoved() {
    stroke?.removeStrokeEffect(this);

    super.onRemoved();
  }
}
