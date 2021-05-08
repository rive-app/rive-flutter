import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/src/rive_core/shapes/shape_paint_container.dart';

abstract class ShapePaintMutator {
  ShapePaintContainer? _shapePaintContainer;
  Paint _paint = Paint();

  /// The container is usually either a Shape or an Artboard, basically any of
  /// the various ContainerComponents that can contain Fills or Strokes.
  ShapePaintContainer? get shapePaintContainer => _shapePaintContainer;
  Paint get paint => _paint;

  double _renderOpacity = 1;
  double get renderOpacity => _renderOpacity;
  set renderOpacity(double value) {
    if (_renderOpacity != value) {
      _renderOpacity = value;
      syncColor();
    }
  }

  @protected
  void syncColor();

  @mustCallSuper
  void initializePaintMutator(ShapePaintContainer container, Paint paint) {
    _shapePaintContainer = container;
    _paint = paint;
    _shapePaintContainer?.onPaintMutatorChanged(this);
    syncColor();
  }
}
