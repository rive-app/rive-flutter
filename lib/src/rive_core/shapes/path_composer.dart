import 'dart:ui' as ui;

import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/shapes/shape.dart';

/// The PathComposer builds the desired world and local paths for the shapes and
/// their fills/strokes. It guarantees that one of local or world path is always
/// available. If the Shape only wants a local path, we'll only build a local
/// one. If the Shape only wants a world path, we'll build only that world path.
/// If it wants both, we build both. If it wants none, we still build a world
/// path.
class PathComposer extends Component {
  final Shape shape;
  PathComposer(this.shape);

  @override
  Artboard? get artboard => shape.artboard;

  final ui.Path worldPath = ui.Path();
  final ui.Path localPath = ui.Path();
  ui.Path _fillPath = ui.Path();
  ui.Path get fillPath => _fillPath;

  void _recomputePath() {
    // No matter what we'll need some form of a world path to get our bounds.
    // Let's optimize how we build it.
    var buildLocalPath = shape.wantLocalPath;
    var buildWorldPath = shape.wantWorldPath || !buildLocalPath;

    // The fill path will be whichever one of these two is available.
    if (buildLocalPath) {
      localPath.reset();
      var world = shape.worldTransform;
      Mat2D inverseWorld = Mat2D();
      if (Mat2D.invert(inverseWorld, world)) {
        for (final path in shape.paths) {
          if (path.isHidden) {
            continue;
          }
          localPath.addPath(path.uiPath, ui.Offset.zero,
              matrix4:
                  Mat2D.multiplySkipIdentity(inverseWorld, path.pathTransform)
                      .mat4);
        }
      }

      // If the world path doesn't get built, we should mark the bounds dirty
      // here.
      if (!buildWorldPath) {
        shape.markBoundsDirty();
      }
    }
    if (buildWorldPath) {
      worldPath.reset();
      for (final path in shape.paths) {
        if (path.isHidden) {
          continue;
        }
        worldPath.addPath(path.uiPath, ui.Offset.zero,
            matrix4: path.pathTransform.mat4);
      }
      shape.markBoundsDirty();
    }
    _fillPath = shape.fillInWorld ? worldPath : localPath;
  }

  @override
  void buildDependencies() {
    super.buildDependencies();

    // We depend on the shape and all of its paths so that we can update after
    // all of them.
    shape.addDependent(this);
    for (final path in shape.paths) {
      path.addDependent(this);
    }
  }

  @override
  void update(int dirt) {
    if (dirt & ComponentDirt.path != 0) {
      _recomputePath();
    }
  }
}
