import 'dart:ui';

import 'package:rive/src/generated/shapes/parametric_path_base.dart';
import 'package:rive/src/rive_core/bounds_provider.dart';
import 'package:rive_common/math.dart';

export 'package:rive/src/generated/shapes/parametric_path_base.dart';

abstract class ParametricPath extends ParametricPathBase implements Sizable {
  @override
  bool get isClosed => true;

  @override
  Size computeIntrinsicSize(Size min, Size max) {
    return Size(width, height);
  }

  @override
  void controlSize(Size size) {
    width = size.width;
    height = size.height;

    markPathDirty();
  }

  @override
  Mat2D get pathTransform => worldTransform;

  @override
  Mat2D get inversePathTransform => inverseWorldTransform;

  @override
  void widthChanged(double from, double to) => markPathDirty();

  @override
  void heightChanged(double from, double to) => markPathDirty();

  @override
  void xChanged(double from, double to) {
    super.xChanged(from, to);
    shape?.pathChanged(this);
  }

  @override
  void yChanged(double from, double to) {
    super.yChanged(from, to);
    shape?.pathChanged(this);
  }

  @override
  void rotationChanged(double from, double to) {
    super.rotationChanged(from, to);
    shape?.pathChanged(this);
  }

  @override
  void scaleXChanged(double from, double to) {
    super.scaleXChanged(from, to);
    shape?.pathChanged(this);
  }

  @override
  void scaleYChanged(double from, double to) {
    super.scaleYChanged(from, to);
    shape?.pathChanged(this);
  }

  @override
  void originXChanged(double from, double to) => markPathDirty();

  @override
  void originYChanged(double from, double to) => markPathDirty();
}
