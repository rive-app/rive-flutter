import 'dart:ui' as ui;
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/shapes/shape.dart';
import 'package:rive/src/generated/shapes/path_composer_base.dart';

class PathComposer extends PathComposerBase {
  static final PathComposer unknown = PathComposer();
  Shape _shape = Shape.unknown;
  Shape get shape => _shape;
  final ui.Path worldPath = ui.Path();
  final ui.Path localPath = ui.Path();
  ui.Path _fillPath = ui.Path();
  ui.Path get fillPath => _fillPath;
  void _changeShape(Shape value) {
    if (value == _shape) {
      return;
    }
    if (_shape != Shape.unknown && _shape.pathComposer == this) {
      _shape.pathComposer = PathComposer.unknown;
    }
    value.pathComposer = this;
    _shape = value;
  }

  void _recomputePath() {
    var buildLocalPath = _shape.wantLocalPath;
    var buildWorldPath = _shape.wantWorldPath || !buildLocalPath;
    if (buildLocalPath) {
      localPath.reset();
      var world = _shape.worldTransform;
      Mat2D inverseWorld = Mat2D();
      if (Mat2D.invert(inverseWorld, world)) {
        for (final path in _shape.paths) {
          if (path.isHidden) {
            continue;
          }
          localPath.addPath(path.uiPath, ui.Offset.zero,
              matrix4:
                  Mat2D.multiplySkipIdentity(inverseWorld, path.pathTransform)
                      .mat4);
        }
      }
    }
    if (buildWorldPath) {
      worldPath.reset();
      for (final path in _shape.paths) {
        if (path.isHidden) {
          continue;
        }
        worldPath.addPath(path.uiPath, ui.Offset.zero,
            matrix4: path.pathTransform.mat4);
      }
    }
    _fillPath = _shape.fillInWorld ? worldPath : localPath;
  }

  @override
  void buildDependencies() {
    super.buildDependencies();
    _shape.addDependent(this);
    for (final path in _shape.paths) {
      path.addDependent(this);
    }
  }

  @override
  void update(int dirt) {
    if (dirt & ComponentDirt.path != 0) {
      _recomputePath();
    }
  }

  @override
  bool resolveArtboard() {
    _changeShape(Shape.unknown);
    return super.resolveArtboard();
  }

  @override
  void visitAncestor(Component ancestor) {
    super.visitAncestor(ancestor);
    if (_shape == Shape.unknown && ancestor is Shape) {
      _changeShape(ancestor);
    }
  }
}
