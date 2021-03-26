import 'dart:ui' as ui;
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/shapes/shape.dart';

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
    var buildLocalPath = shape.wantLocalPath;
    var buildWorldPath = shape.wantWorldPath || !buildLocalPath;
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
    }
    _fillPath = shape.fillInWorld ? worldPath : localPath;
  }

  @override
  void buildDependencies() {
    super.buildDependencies();
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
