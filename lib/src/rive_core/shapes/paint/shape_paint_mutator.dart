import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rive/src/rive_core/shapes/shape_paint_container.dart';

class _UnknownMutator extends ShapePaintMutator {
  @override
  void syncColor() {
    throw UnsupportedError(
        'Not expected to call sync color on an UnknownMutator.');
  }
}

abstract class ShapePaintMutator {
  ShapePaintContainer _shapePaintContainer = ShapePaintContainer.unknown;
  late Paint _paint;
  static final ShapePaintMutator unknown = _UnknownMutator();
  ShapePaintContainer get shapePaintContainer => _shapePaintContainer;
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
    _shapePaintContainer.onPaintMutatorChanged(this);
    syncColor();
  }
}
