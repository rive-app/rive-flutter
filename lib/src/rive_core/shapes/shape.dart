import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:rive/src/generated/shapes/shape_base.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/aabb.dart';
import 'package:rive/src/rive_core/math/hit_test.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/shapes/paint/linear_gradient.dart' as core;
import 'package:rive/src/rive_core/shapes/paint/shape_paint_mutator.dart';
import 'package:rive/src/rive_core/shapes/paint/stroke.dart';
import 'package:rive/src/rive_core/shapes/path.dart';
import 'package:rive/src/rive_core/shapes/path_composer.dart';
import 'package:rive/src/rive_core/shapes/shape_paint_container.dart';

export 'package:rive/src/generated/shapes/shape_base.dart';

class Shape extends ShapeBase with ShapePaintContainer {
  final Set<Path> paths = {};

  bool _wantWorldPath = false;
  bool _wantLocalPath = false;
  bool get wantWorldPath => _wantWorldPath;
  bool get wantLocalPath => _wantLocalPath;
  bool _fillInWorld = false;
  bool get fillInWorld => _fillInWorld;

  late PathComposer pathComposer;
  Shape() {
    pathComposer = PathComposer(this);
  }

  ui.Path get fillPath => pathComposer.fillPath;

  // Build the bounds on demand, more efficient than re-computing whenever they
  // change as bounds rarely have bearing at runtime (they will in some cases
  // with constraints eventually).
  AABB? _worldBounds;
  AABB? _localBounds;

  AABB get worldBounds => _worldBounds ??= computeWorldBounds();

  AABB get localBounds => _localBounds ??= computeLocalBounds();

  /// Let the shape know that any further call to get world/local bounds will
  /// need to rebuild the cached bounds.
  void markBoundsDirty() {
    _worldBounds = _localBounds = null;
  }

  bool addPath(Path path) {
    paintChanged();
    var added = paths.add(path);

    return added;
  }

  void _markComposerDirty() {
    pathComposer.addDirt(ComponentDirt.path, recurse: true);
    // Stroke effects need to be rebuilt whenever the path composer rebuilds the
    // compound path.
    invalidateStrokeEffects();
  }

  void pathChanged(Path path) => _markComposerDirty();

  void paintChanged() {
    addDirt(ComponentDirt.path);
    _markBlendModeDirty();
    _markRenderOpacityDirty();

    // Add world transform dirt to the direct dependents (don't recurse) as
    // things like ClippingShape directly depend on their referenced Shape. This
    // allows them to recompute any stored values which can change when the
    // transformAffectsStroke property changes (whether the path is in world
    // space or not). Consider using a different dirt type if this pattern is
    // repeated.
    for (final d in dependents) {
      d.addDirt(ComponentDirt.worldTransform);
    }

    // Path composer needs to update if we update the types of paths we want.
    _markComposerDirty();
  }

  @override
  bool addStroke(Stroke stroke) {
    paintChanged();
    return super.addStroke(stroke);
  }

  @override
  bool removeStroke(Stroke stroke) {
    paintChanged();
    return super.removeStroke(stroke);
  }

  @override
  void update(int dirt) {
    super.update(dirt);

    // When the paint gets marked dirty, we need to sync the blend mode with the
    // paints.
    if (dirt & ComponentDirt.blendMode != 0) {
      for (final fill in fills) {
        fill.blendMode = blendMode;
      }
      for (final stroke in strokes) {
        stroke.blendMode = blendMode;
      }
    }

    // RenderOpacity gets updated with the worldTransform (accumulates through
    // hierarchy), so if we see worldTransform is dirty, update our internal
    // render opacities.
    if (dirt & ComponentDirt.worldTransform != 0) {
      for (final fill in fills) {
        fill.renderOpacity = renderOpacity;
      }
      for (final stroke in strokes) {
        stroke.renderOpacity = renderOpacity;
      }
    }
    // We update before the path composer so let's get our ducks in a row, what
    // do we want? PathComposer depends on us so we're safe to update our
    // desires here.
    if (dirt & ComponentDirt.path != 0) {
      // Recompute which paths we want.
      _wantWorldPath = false;
      _wantLocalPath = false;
      for (final stroke in strokes) {
        if (stroke.transformAffectsStroke) {
          _wantLocalPath = true;
        } else {
          _wantWorldPath = true;
        }
      }

      // Update the gradients' paintsInWorldSpace properties based on whether
      // the path we'll be feeding that at draw time is in world or local space.
      // This is a good opportunity to do it as gradients depend on us so
      // they'll update after us.

      // We optmistically first fill in the space we know the stroke will be in.
      _fillInWorld = _wantWorldPath || !_wantLocalPath;

      // Gradients almost always fill in local space, unless they are bound to
      // bones.
      var mustFillLocal = fills.firstWhereOrNull(
            (fill) => fill.paintMutator is core.LinearGradient,
          ) !=
          null;
      if (mustFillLocal) {
        _fillInWorld = false;
        _wantLocalPath = true;
      }

      for (final fill in fills) {
        var mutator = fill.paintMutator;
        if (mutator is core.LinearGradient) {
          mutator.paintsInWorldSpace = _fillInWorld;
        }
      }

      for (final stroke in strokes) {
        var mutator = stroke.paintMutator;
        if (mutator is core.LinearGradient) {
          mutator.paintsInWorldSpace = !stroke.transformAffectsStroke;
        }
      }
    }
  }

  bool removePath(Path path) {
    paintChanged();
    return paths.remove(path);
  }

  AABB computeWorldBounds() {
    var boundsPaths = paths.where((path) => path.hasBounds);
    if (boundsPaths.isEmpty) {
      return AABB.fromMinMax(worldTranslation, worldTranslation);
    }
    var path = boundsPaths.first;
    AABB worldBounds = path.preciseComputeBounds(transform: path.pathTransform);
    for (final path in boundsPaths.skip(1)) {
      AABB.combine(worldBounds, worldBounds,
          path.preciseComputeBounds(transform: path.pathTransform));
    }
    return worldBounds;
  }

  AABB computeBounds(Mat2D relativeTo) {
    var boundsPaths = paths.where((path) => path.hasBounds);
    if (boundsPaths.isEmpty) {
      return AABB();
    }
    var path = boundsPaths.first;

    AABB localBounds = path.preciseComputeBounds(
      transform: Mat2D.multiply(
        Mat2D(),
        relativeTo,
        path.pathTransform,
      ),
    );

    for (final path in paths.skip(1)) {
      AABB.combine(
        localBounds,
        localBounds,
        path.preciseComputeBounds(
          transform: Mat2D.multiply(
            Mat2D(),
            relativeTo,
            path.pathTransform,
          ),
        ),
      );
    }
    return localBounds;
  }

  AABB computeLocalBounds() {
    var toTransform = Mat2D();
    if (!Mat2D.invert(toTransform, worldTransform)) {
      Mat2D.setIdentity(toTransform);
    }
    return computeBounds(toTransform);
  }

  @override
  void blendModeValueChanged(int from, int to) => _markBlendModeDirty();

  @override
  void draw(ui.Canvas canvas) {
    bool clipped = clip(canvas);
    var path = pathComposer.fillPath;
    if (!_fillInWorld) {
      canvas.save();
      canvas.transform(worldTransform.mat4);
    }
    for (final fill in fills) {
      fill.draw(canvas, path);
    }
    if (!_fillInWorld) {
      canvas.restore();
    }

    // Strokes are slightly more complicated, they may want a local path. Note
    // that we've already built this up during our update and processed any
    // gradients to have their offsets in the correct transform space (see our
    // update method).
    for (final stroke in strokes) {
      // stroke.draw(canvas, _pathComposer);
      var transformAffectsStroke = stroke.transformAffectsStroke;
      var path = transformAffectsStroke
          ? pathComposer.localPath
          : pathComposer.worldPath;

      if (transformAffectsStroke) {
        // Get into world space.
        canvas.save();
        canvas.transform(worldTransform.mat4);
        stroke.draw(canvas, path);
        canvas.restore();
      } else {
        stroke.draw(canvas, path);
      }
    }

    if (clipped) {
      canvas.restore();
    }
  }

  void _markBlendModeDirty() => addDirt(ComponentDirt.blendMode);
  void _markRenderOpacityDirty() => addDirt(ComponentDirt.worldTransform);

  @override
  void onPaintMutatorChanged(ShapePaintMutator mutator) {
    // The transform affects stroke property may have changed as we have a new
    // mutator.
    paintChanged();
  }

  @override
  void onStrokesChanged() => paintChanged();

  @override
  void onFillsChanged() => paintChanged();

  /// Since the PathComposer isn't in core, we need to let it know when to proxy
  /// build dependencies.
  @override
  void buildDependencies() {
    super.buildDependencies();
    pathComposer.buildDependencies();
  }

  /// Prep the [hitTester] for checking collision with the paths inside this
  /// shape.
  void fillHitTester(TransformingHitTester hitTester) {
    for (final path in paths) {
      hitTester.transform = path.pathTransform;
      path.buildPath(hitTester);
    }
  }
}
