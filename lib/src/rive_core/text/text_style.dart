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
    _font = style._makeVariableFont();
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
  Iterable<TextStyleAxis> get variations => _variations;

  Iterable<FontAxis> get variableAxes => asset?.font?.axes ?? [];
  bool get hasVariableAxes => asset?.font?.axes.isNotEmpty ?? false;

  TextVariationHelper? _variationHelper;
  TextVariationHelper? get variationHelper => _variationHelper;

  Font? _makeVariableFont() => asset?.font?.makeVariation(
      _variations.map((axis) => FontAxisCoord(axis.tag, axis.axisValue)));

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
  String toString() => '${super.toString()} -> FontSize($fontSize)';

  @override
  void buildDependencies() {
    parent?.addDependent(this);
    _variationHelper?.buildDependencies();
  }

  @override
  set asset(FontAsset? value) {
    if (asset == value) {
      return;
    }
    _variations.toSet().forEach(context.removeObject);
    super.asset = value;
    if (asset?.whenDecoded(_fontDecoded, notifyAlreadyDecoded: false) ??
        false) {
      // Already decoded.
      _markShapeDirty();
    }
  }

  @override
  void fontAssetIdChanged(int from, int to) {
    asset = context.resolve(to);
  }

  void _fontDecoded() => _markShapeDirty();

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    asset = context.resolve(fontAssetId);
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
    }
  }

  @override
  void childRemoved(Component component) {
    super.childRemoved(component);
    if (component is TextStyleAxis) {
      if (_variations.remove(component)) {
        addDirt(ComponentDirt.textShape);
        if (_variations.isEmpty) {
          _variationHelper?.dispose();
          _variationHelper = null;
        }
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
}
