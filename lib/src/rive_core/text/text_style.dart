import 'dart:collection';
import 'dart:ui' as ui;

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/text/text_style_base.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/assets/file_asset.dart';
import 'package:rive/src/rive_core/assets/font_asset.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/shapes/paint/shape_paint.dart';
import 'package:rive/src/rive_core/shapes/paint/shape_paint_mutator.dart';
import 'package:rive/src/rive_core/shapes/shape_paint_container.dart';
import 'package:rive/src/rive_core/text/text.dart';
import 'package:rive/src/rive_core/text/text_style_axis.dart';
import 'package:rive/src/rive_core/text/text_style_feature.dart';
import 'package:rive/src/rive_core/text/text_value_run.dart';
import 'package:rive_common/math.dart';
import 'package:rive_common/rive_text.dart';

export 'package:rive/src/generated/text/text_style_base.dart';

class TextVariationHelper extends Component {
  final TextStyle style;
  Font? _font;

  @override
  Artboard? get artboard => style.artboard;

  Font? get font => _font;

  TextVariationHelper(this.style) {
    style.markRebuildDependencies();
  }

  @override
  void update(int dirt) {
    _font?.dispose();
    _font = style._makeFontVariation();
  }

  void dispose() {
    _font?.dispose();
    _font = null;
  }

  @override
  void buildDependencies() {
    var text = style.text;
    if (text != null) {
      text.artboard?.addDependent(this);
      addDependent(text);
    }
  }
}

class TextStyle extends TextStyleBase
    with ShapePaintContainer, FileAssetReferencer<FontAsset> {
  final Set<TextValueRun> _referencers = {};
  Text? get text => parent as Text?;
  final Set<TextStyleAxis> _variations = {};
  final Set<TextStyleFeature> _features = {};
  Iterable<TextStyleAxis> get variations => _variations;
  Iterable<TextStyleFeature> get features => _features;

  Iterable<FontAxis> get variableAxes => asset?.font?.axes ?? [];
  bool get hasVariableAxes => asset?.font?.axes.isNotEmpty ?? false;

  TextVariationHelper? _variationHelper;
  TextVariationHelper? get variationHelper => _variationHelper;

  Iterable<FontTag> get fontFeatures => asset?.font?.features ?? [];

  Font? _makeFontVariation() => asset?.font?.withOptions(
        _variations.map(
          (axis) => FontAxisCoord(
            axis.tag,
            axis.axisValue,
          ),
        ),
        _features.map(
          (feature) => FontFeature(
            feature.tag,
            feature.featureValue,
          ),
        ),
      );

  Font? get font => _variationHelper?.font ?? asset?.font;

  List<ShapePaint> get shapePaints =>
      fills.cast<ShapePaint>().toList() + strokes.cast<ShapePaint>().toList();

  /// An identifier used by the shaper to remap style ids as text runs are
  /// converted to glyph runs.
  int shaperId = -1;

  @override
  void fontSizeChanged(double from, double to) => _markShapeDirty();

  void _markShapeDirty() {
    for (final run in _referencers) {
      run.markShapeDirty();
    }
  }

  @override
  void update(int dirt) {}

  /// Let the style know that a run references it.
  void ref(TextValueRun run) {
    _referencers.add(run);
  }

  void deref(TextValueRun run) {
    _referencers.remove(run);
  }

  @override
  String toString() => 'TextStyle(id: $id, size: $fontSize'
      ')';

  @override
  void buildDependencies() {
    parent?.addDependent(this);
    _variationHelper?.buildDependencies();
  }

  void removeVariations() => _variations.toSet().forEach(context.removeObject);

  @override
  set asset(FontAsset? value) {
    if (asset == value) {
      return;
    }

    super.asset = value;
    if (asset?.setFontCallback(_fontDecoded, notifyAlreadySet: false) ??
        false) {
      // Already decoded.
      _markShapeDirty();
      _variationHelper?.addDirt(ComponentDirt.textShape);
    }
  }

  @override
  void copy(covariant TextStyle source) {
    super.copy(source);
    asset = source.asset;
  }

  @override
  void fontAssetIdChanged(int from, int to) {
    asset = context.resolve(to);
  }

  void _fontDecoded() {
    _markShapeDirty();
    _variationHelper?.addDirt(ComponentDirt.textShape);
  }


  @override
  void onDirty(int mask) {
    super.onDirty(mask);
    if ((mask & ComponentDirt.paint) != 0) {
      text?.markPaintDirty();
    }
    if ((mask & ComponentDirt.textShape) != 0) {
      text?.markShapeDirty();
      _variationHelper?.addDirt(ComponentDirt.textShape);
    }
  }

  @override
  void onFillsChanged() {
    text?.markPaintDirty();
  }

  @override
  void onPaintMutatorChanged(ShapePaintMutator mutator) {
    text?.markPaintDirty();
  }

  @override
  void onStrokesChanged() {
    text?.markPaintDirty();
  }

  @override
  Mat2D get worldTransform => text?.worldTransform ?? Mat2D.identity;

  @override
  Vec2D get worldTranslation => text?.worldTranslation ?? Vec2D();

  @override
  void childAdded(Component component) {
    super.childAdded(component);
    if (component is TextStyleAxis) {
      if (_variations.add(component)) {
        _variationHelper ??= TextVariationHelper(this);
        addDirt(ComponentDirt.textShape);
      }
    } else if (component is TextStyleFeature) {
      if (_features.add(component)) {
        _variationHelper ??= TextVariationHelper(this);
        addDirt(ComponentDirt.textShape);
      }
    }
  }

  @override
  void childRemoved(Component component) {
    super.childRemoved(component);
    bool changed = false;
    if (component is TextStyleAxis) {
      if (_variations.remove(component)) {
        changed = true;
      }
    } else if (component is TextStyleFeature) {
      if (_features.remove(component)) {
        changed = true;
      }
    }

    if (changed) {
      addDirt(ComponentDirt.textShape);
      if (_variations.isEmpty && _features.isEmpty) {
        _variationHelper?.dispose();
        _variationHelper = null;
      }
    }
  }

  @override
  void onRemoved() {
    super.onRemoved();
    _variationHelper?.dispose();
    _variationHelper = null;
  }

  @override
  int get assetId => fontAssetId;

  @override
  set assetId(int value) => fontAssetId = value;

  @override
  int get assetIdPropertyKey => TextStyleBase.fontAssetIdPropertyKey;

  final ui.Path _renderPath = ui.Path();
  final HashMap<double, ui.Path> _opacityPaths = HashMap<double, ui.Path>();

  bool _hasContents = false;
  void resetPath() {
    _renderPath.reset();
    _opacityPaths.clear();
    _hasContents = false;
  }

  bool addPath(ui.Path path, double opacity) {
    var hadContents = _hasContents;
    _hasContents = true;
    if (opacity == 1) {
      _renderPath.addPath(path, ui.Offset.zero);
    } else if (opacity > 0) {
      var renderPath = _opacityPaths[opacity];
      if (renderPath == null) {
        _opacityPaths[opacity] = renderPath = ui.Path();
      }
      renderPath.addPath(path, ui.Offset.zero);
    }
    return !hadContents;
  }

  void draw(ui.Canvas canvas) {
    for (final shapePaint in shapePaints) {
      if (!shapePaint.isVisible) {
        continue;
      }
      var paint = shapePaint.paint;
      canvas.drawPath(
        _renderPath,
        paint,
      );
      if (_opacityPaths.entries.isNotEmpty) {
        var oldColor = paint.color;
        for (final entry in _opacityPaths.entries) {
          paint.color = ui.Color.fromRGBO(
            oldColor.red,
            oldColor.green,
            oldColor.blue,
            oldColor.opacity * entry.key,
          );
          canvas.drawPath(
            entry.value,
            paint,
          );
        }
        paint.color = oldColor;
      }
    }
  }

  @override
  bool import(ImportStack stack) {
    if (!registerWithImporter(stack)) {
      return false;
    }
    return super.import(stack);
  }
}
