import 'dart:math' hide log;
import 'dart:ui';

import 'package:rive/src/generated/text/text_base.dart';
import 'package:rive/src/rive_core/bounds_provider.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/rive_core/enum_helper.dart';
import 'package:rive/src/rive_core/layout_component.dart';
import 'package:rive/src/rive_core/text/styled_text.dart';
import 'package:rive/src/rive_core/text/text_modifier_group.dart';
import 'package:rive/src/rive_core/text/text_style.dart' as rive;
import 'package:rive/src/rive_core/text/text_style_container.dart';
import 'package:rive/src/rive_core/text/text_value_run.dart';
import 'package:rive_common/math.dart';
import 'package:rive_common/rive_text.dart';

export 'package:rive/src/generated/text/text_base.dart';

enum TextSizing {
  autoWidth,
  autoHeight,
  fixed,
}

enum TextOverflow {
  visible,
  hidden,
  clipped,
  ellipsis,
  fit,
}

enum TextOrigin {
  top,
  baseline,
}

enum VerticalTextAlign {
  top,
  bottom,
  middle,
}

class Text extends TextBase with TextStyleContainer implements Sizable {
  Path? _clipRenderPath;

  double? _layoutWidth;
  double? _layoutHeight;
  Mat2D _transform = Mat2D();

  double get effectiveWidth => _layoutWidth ?? super.width;
  double get effectiveHeight => _layoutHeight ?? super.height;

  @override
  Size computeIntrinsicSize(Size min, Size max) {
    var size = _measure(max);
    return size;
  }

  @override
  void controlSize(Size size) {
    if (_layoutWidth != size.width || _layoutHeight != size.height) {
      _layoutWidth = size.width;
      _layoutHeight = size.height;
      markShapeDirty(sendToLayout: false);
    }
  }

  TextShapeResult? _shape;
  // A shape result specifically for modifiers.
  StyledText? _modifierStyledText;
  TextShapeResult? _modifierShape;
  BreakLinesResult? _modifierLines;

  // Shapes that should be cleaned before next shaping call.
  final List<TextShapeResult> _cleanupShapes = [];
  BreakLinesResult? _lines;

  /// STOKANAL-FORK-EDIT: exposing
  TextShapeResult? get shape => _shape;
  BreakLinesResult? get lines => _lines;

  // Used by text effectors.
  GlyphLookup? _glyphLookup;

  double tValueOf(LineRunGlyph glyphInfo) {
    var index = glyphInfo.run.textIndexAt(glyphInfo.index);
    double t;
    if (_glyphLookup != null) {
      t = index + _glyphLookup!.count(index) / 2;
    } else {
      t = index + 0.5;
    }
    return t;
  }

  int glyphCodePointCount(LineRunGlyph glyphInfo) {
    var index = glyphInfo.run.textIndexAt(glyphInfo.index);
    if (_glyphLookup != null) {
      return _glyphLookup!.count(index);
    }
    return 1;
  }

  List<TextModifierGroup> _modifierGroups = [];
  Iterable<TextModifierGroup> get modifierGroups => _modifierGroups;

  bool get isEmpty => runs.isEmpty;

  final List<rive.TextStyle> auxStyles = [];

  int get unicharCount => _unicharCount;

  Font? getFirstAvailableFont() {
    for (final run in runs) {
      if (run.style?.font != null) {
        return run.style?.font;
      }
    }
    return null;
  }

  StyledText makeStyled(
    Font defaultFont, {
    bool forEditing = false,
    bool withModifiers = true,
  }) {
    List<TextRun> textRuns = [];
    final buffer = StringBuffer();
    int runIndex = 0;
    for (final run in runs) {
      if (run.text.isEmpty) {
        runIndex++;
        continue;
      }
      buffer.write(run.text);
      textRuns.add(TextRun(
        font: run.style?.font ?? defaultFont,
        fontSize: run.style?.fontSize ?? 16,
        lineHeight: run.style?.lineHeight ?? -1,
        letterSpacing: run.style?.letterSpacing ?? 0,
        unicharCount: run.text.codeUnits.length,
        styleId: runIndex++,
      ));
    }
    if (withModifiers) {
      // Make sure to split on glyphs from TextModifiers.
      for (final modifierGroup in _modifierGroups) {
        textRuns = modifierGroup.applyShapeModifiers(this, textRuns);
      }
    }

    // Couldn't fit anything?
    if (textRuns.isEmpty && runs.isNotEmpty) {
      var run = runs.first;
      textRuns.add(TextRun(
        font: run.style?.font ?? defaultFont,
        fontSize: run.style?.fontSize ?? 16,
        unicharCount: run.text.codeUnits.length,
        styleId: 0,
      ));
    }

    // We keep an empty space at the end of the buffer if it's for editing
    // purposes (we need to know where the final cursor goes and we want some
    // sense of shape even when completely empty).
    return forEditing || buffer.isEmpty
        ? StyledText(buffer.toString(), textRuns)
        : StyledText.exact(buffer.toString(), textRuns);
  }

  String get text {
    final buffer = StringBuffer();
    for (final run in runs) {
      buffer.write(run.text);
    }
    return buffer.toString();
  }

  void _disposeShape() {
    for (final shape in _cleanupShapes) {
      shape.dispose();
    }
    _cleanupShapes.clear();
    _shape = null;
  }

  rive.TextStyle? styleFromShaperId(int id) => runFromShaperId(id)?.style;
  TextValueRun? runFromShaperId(int id) => id < _runs.length ? _runs[id] : null;

  List<TextValueRun> _runs = [];
  Iterable<TextValueRun> get runs => _runs;

  void _syncRuns() {
    _runs = children.whereType<TextValueRun>().toList(growable: false);
    _modifierGroups =
        children.whereType<TextModifierGroup>().toList(growable: false);

    updateStyles();
  }

  @override
  void onAdded() {
    super.onAdded();
    _syncRuns();
  }

  Mat2D get originTransform => Mat2D.multiply(
        Mat2D(),
        worldTransform,
        Mat2D.fromTranslate(
          _bounds.minX - _bounds.width * originX,
          _bounds.minY - _bounds.height * originY,
        ),
      );

  double verticalAlignOffset = 0;

  AABB _bounds = AABB.collapsed(Vec2D());
  // Size _size = Size.zero;
  Size get size => Size(_bounds.width, _bounds.height);

  @override
  AABB get localBounds => AABB.fromLTWH(
        _bounds.minX - _bounds.width * originX,
        _bounds.minY - _bounds.height * originY,
        _bounds.width,
        _bounds.height,
      );

  @override
  AABB get constraintBounds => localBounds;

  void forEachGlyph(
      bool Function(LineRunGlyph, double, double, GlyphLine) callback) {
    var lines = _lines;
    var shape = _shape;
    if (lines == null || shape == null) {
      return;
    }
    double y = 0;
    var paragraphIndex = 0;

    for (final paragraphLines in lines) {
      final paragraph = shape.paragraphs[paragraphIndex++];
      for (final line in paragraphLines) {
        double x = line.startX;
        for (final glyphInfo in line.glyphs(paragraph)) {
          var run = glyphInfo.run;

          if (!callback(glyphInfo, x, y, line)) {
            return;
          }

          x += run.advanceAt(glyphInfo.index);
        }
      }

      if (paragraphLines.isNotEmpty) {
        y += paragraphLines.last.bottom;
      }
      y += paragraphSpacing;
    }
  }

  final List<rive.TextStyle> _renderStyles = [];
  
  /// STOKANAL-FORK-EDIT: exposing
  List<rive.TextStyle> get renderStyles => _renderStyles;

  Size _measuredSizeMax = Size.zero;
  Size _measuredSize = Size.zero;
  
  Size _measure(Size maxSize) {
    if (_measuredSizeMax == maxSize) {
      return _measuredSize;
    }
    var defaultFont = _defaultFont;
    if (defaultFont == null) {
      return Size.zero;
    }
    var styled = makeStyled(defaultFont, withModifiers: false);
    var shape = defaultFont.shape(
      styled.value,
      styled.runs,
    );
    _cleanupShapes.add(shape);

    var lines = shape.breakLines(
        min(maxSize.width, sizing == TextSizing.autoWidth ? -1 : width),
        align,
        wrap);

    double y = 0;
    double computedHeight = 0;
    double minY = 0;
    var paragraphIndex = 0;
    int ellipsisLine = -1;

    double maxWidth = 0;
    if (textOrigin == TextOrigin.baseline &&
        lines.isNotEmpty &&
        lines.first.isNotEmpty) {
      y -= lines.first.first.baseline;
      minY = y;
    }

    var wantEllipsis = overflow == TextOverflow.ellipsis &&
        sizing == TextSizing.fixed &&
        verticalAlign == VerticalTextAlign.top;

    // We iterate in a pre-path building pass to compute dimensions.
    outer:
    for (final paragraphLines in lines) {
      final paragraph = shape.paragraphs[paragraphIndex++];
      for (final line in paragraphLines) {
        var width = line.width(paragraph);
        if (width > maxWidth) {
          maxWidth = width;
        }
        if (wantEllipsis && y + line.bottom > maxSize.height) {
          if (ellipsisLine == -1) {
            // Nothing fits, just show the first line and ellipse it.
            computedHeight = y + line.bottom;
          }
          break outer;
        }
        ellipsisLine++;
        computedHeight = y + line.bottom;
      }

      if (paragraphLines.isNotEmpty) {
        y += paragraphLines.last.bottom;
      }

      y += paragraphSpacing;
    }

    late AABB bounds;
    switch (sizing) {
      case TextSizing.autoWidth:
        bounds = AABB.fromValues(
          0.0,
          minY,
          maxWidth,
          max(minY, computedHeight),
        );
        break;
      case TextSizing.autoHeight:
        bounds = AABB.fromValues(
          0.0,
          minY,
          width,
          max(minY, computedHeight),
        );
        break;
      case TextSizing.fixed:
        bounds = AABB.fromValues(
          0.0,
          minY,
          width,
          minY + height,
        );
        break;
    }
    lines.dispose();

    _measuredSizeMax = maxSize;
    return _measuredSize = Size(min(maxSize.width, bounds.width.ceilToDouble()),
        min(maxSize.height, bounds.height.ceilToDouble()));
  }

  /// STOKANAL-FORK-EDIT: expose method
  void buildRenderStyles() => _buildRenderStyles();

  void _buildRenderStyles() {
    var lines = _lines;
    var shape = _shape;
    if (lines == null || shape == null) {
      return;
    }
    for (final style in _renderStyles) {
      style.resetPath();
    }
    _renderStyles.clear();

    double y = 0;
    double minY = 0;
    var paragraphIndex = 0;
    int ellipsisLine = -1;
    bool isEllipsisLineLast = false;
    double maxWidth = 0;
    if (textOrigin == TextOrigin.baseline &&
        lines.isNotEmpty &&
        lines.first.isNotEmpty) {
      y -= lines.first.first.baseline;
      minY = y;
    }

    // If we want an ellipsis we need to find the line to put the
    // ellipsis on (line before the one that overflows).
    var wantEllipsis = overflow == TextOverflow.ellipsis &&
        effectiveSizing == TextSizing.fixed &&
        verticalAlign == VerticalTextAlign.top;

    // We iterate in a pre-path building pass to compute dimensions.
    int lastLineIndex = -1;
    for (final paragraphLines in lines) {
      final paragraph = shape.paragraphs[paragraphIndex++];
      for (final line in paragraphLines) {
        var width = line.width(paragraph);
        if (width > maxWidth) {
          maxWidth = width;
        }
        lastLineIndex++;
        if (wantEllipsis && y + line.bottom <= effectiveHeight) {
          ellipsisLine++;
        }
      }

      if (paragraphLines.isNotEmpty) {
        y += paragraphLines.last.bottom;
      }

      y += paragraphSpacing;
    }
    final totalHeight = y;
    if (wantEllipsis && ellipsisLine == -1) {
      // Nothing fits, just show the first line and ellipse it.
      ellipsisLine = 0;
    }
    isEllipsisLineLast = lastLineIndex == ellipsisLine;

    bool haveModifiers = _modifierGroups.isNotEmpty;
    if (haveModifiers) {
      for (final modifier in _modifierGroups) {
        modifier.computeCoverage(_unicharCount);
      }
    }

    int lineIndex = 0;
    paragraphIndex = 0;

    switch (effectiveSizing) {
      case TextSizing.autoWidth:
        _bounds = AABB.fromValues(
          0.0,
          minY,
          maxWidth,
          max(minY, y - paragraphSpacing),
        );
        break;
      case TextSizing.autoHeight:
        _bounds = AABB.fromValues(
          0.0,
          minY,
          effectiveWidth == 0 ? maxWidth : effectiveWidth,
          max(minY, y - paragraphSpacing),
        );
        break;
      case TextSizing.fixed:
        _bounds = AABB.fromValues(
          0.0,
          minY,
          effectiveWidth == 0 ? maxWidth : effectiveWidth,
          minY + effectiveHeight,
        );
        break;
    }

    verticalAlignOffset = 0;
    switch (verticalAlign) {
      case VerticalTextAlign.middle:
        verticalAlignOffset = (totalHeight - _bounds.height) / 2;
        break;
      case VerticalTextAlign.bottom:
        verticalAlignOffset = totalHeight - _bounds.height;
        break;
      default:
        break;
    }

    if (overflow == TextOverflow.clipped) {
      if (_clipRenderPath != null) {
        _clipRenderPath?.reset();
      } else {
        _clipRenderPath = Path();
      }
      _clipRenderPath?.addRect(localBounds.rect.translate(
          _bounds.width * originX,
          verticalAlignOffset + _bounds.height * originY));
    } else {
      _clipRenderPath?.reset();
      _clipRenderPath = null;
    }

    y = 0;
    if (textOrigin == TextOrigin.baseline &&
        lines.isNotEmpty &&
        lines.first.isNotEmpty) {
      y -= lines.first.first.baseline;
    }
    paragraphIndex = 0;
    double minX = double.maxFinite;
    bool drawLine = true;

    outer:
    for (final paragraphLines in lines) {
      final paragraph = shape.paragraphs[paragraphIndex++];
      for (final line in paragraphLines) {
        drawLine = true;
        switch (overflow) {
          case TextOverflow.hidden:
            if (effectiveSizing == TextSizing.fixed) {
              switch (verticalAlign) {
                case VerticalTextAlign.top:
                  if (y + line.bottom > effectiveHeight) {
                    break outer;
                  }
                  break;
                case VerticalTextAlign.middle:
                  if (y + line.top < totalHeight / 2 - effectiveHeight / 2) {
                    drawLine = false;
                  }
                  if (y + line.bottom > totalHeight / 2 + effectiveHeight / 2) {
                    drawLine = false;
                    break outer;
                  }
                  break;
                case VerticalTextAlign.bottom:
                  if (y + line.top < totalHeight - effectiveHeight) {
                    continue;
                  }
                  break;
              }
            }
            break;
          case TextOverflow.clipped:
            if (effectiveSizing == TextSizing.fixed) {
              switch (verticalAlign) {
                case VerticalTextAlign.top:
                  if (y + line.top > effectiveHeight) {
                    break outer;
                  }
                  break;
                case VerticalTextAlign.middle:
                  if (y + line.bottom < totalHeight / 2 - effectiveHeight / 2) {
                    drawLine = false;
                  }
                  if (y + line.top > totalHeight / 2 + effectiveHeight / 2) {
                    break outer;
                  }
                  break;
                case VerticalTextAlign.bottom:
                  if (y + line.bottom < totalHeight - effectiveHeight) {
                    drawLine = false;
                  }
                  break;
              }
            }
            break;
          default:
            break;
        }

        double x = line.startX;
        minX = min(x, minX);
        for (final glyphInfo in lineIndex == ellipsisLine
            ? line.glyphsWithEllipsis(
                effectiveWidth,
                paragraph: paragraph,
                isLastLine: isEllipsisLineLast,
                cleanupShapes: _cleanupShapes,
              )
            : line.glyphs(paragraph)) {
          var run = glyphInfo.run;
          var font = run.font;

          final glyphId = run.glyphIdAt(glyphInfo.index);
          var path = font.getUiPath(glyphId);

          late Float64List pathTransform;
          if (haveModifiers) {
            var centerX = glyphInfo.center;
            var transform = Mat2D.fromScaleAndTranslation(
                glyphInfo.run.fontSize, glyphInfo.run.fontSize, -centerX, 0);
            for (final modifier in _modifierGroups) {
              transform = modifier.transform(
                  modifier.glyphCoverage(glyphInfo), transform);
            }
            var offset = glyphInfo.offset;
            transform = Mat2D.multiply(
                transform,
                Mat2D.fromTranslate(
                    centerX + x + offset.x, y + line.baseline + offset.y),
                transform);
            pathTransform = transform.mat4;
          } else {
            pathTransform = glyphInfo.pathTransform(x, y + line.baseline).mat4;
          }
          var renderPath = path.transform(pathTransform);
          var style = styleFromShaperId(run.styleId);
          if (style != null) {
            double opacity = 1.0;
            if (haveModifiers) {
              for (final modifier in _modifierGroups) {
                if (modifier.modifiesOpacity) {
                  opacity = modifier.computeOpacity(
                      opacity, modifier.glyphCoverage(glyphInfo));
                }
              }
            }
            if (drawLine) {
              if (style.addPath(renderPath, opacity)) {
                _renderStyles.add(style);
              }
            }
          }

          x += run.advanceAt(glyphInfo.index);
        }
        if (lineIndex == ellipsisLine) {
          break outer;
        }
        lineIndex++;
      }
      if (paragraphLines.isNotEmpty) {
        y += paragraphLines.last.bottom;
      }
      y += paragraphSpacing;
    }
    double scale = 1;
    double xOffset = -_bounds.width * originX;
    double yOffset = -_bounds.height * originY;
    if (overflow == TextOverflow.fit) {
      double xScale =
          (effectiveSizing != TextSizing.autoWidth && maxWidth > _bounds.width)
              ? _bounds.width / maxWidth
              : 1;
      double baseline = fitFromBaseline ? lines[0][0].baseline : 0;
      double yScale =
          (effectiveSizing == TextSizing.fixed && totalHeight > _bounds.height)
              ? (_bounds.height - baseline) / (totalHeight - baseline)
              : 1;
      if (xScale != 1 || yScale != 1) {
        scale = max(0, xScale > yScale ? yScale : xScale);
        yOffset += baseline * (1 - scale);
        switch (align) {
          case TextAlign.center:
            xOffset += (_bounds.width - maxWidth * scale) / 2 - minX * scale;
            break;
          case TextAlign.right:
            xOffset += _bounds.width - maxWidth * scale - minX * scale;
            break;
          default:
            break;
        }
      }
    }
    if (verticalAlignValue != VerticalTextAlign.top.index) {
      if (effectiveSizing == TextSizing.fixed) {
        yOffset = -_bounds.height * originY;
        if (verticalAlignValue == VerticalTextAlign.middle.index) {
          yOffset += (_bounds.height - totalHeight * scale) / 2;
        } else if (verticalAlignValue == VerticalTextAlign.bottom.index) {
          yOffset += _bounds.height - totalHeight * scale;
        }
      }
    }
    _transform = Mat2D.fromScaleAndTranslation(scale, scale, xOffset, yOffset);
  }

  @override
  void draw(Canvas canvas) {
    var lines = _lines;
    var shape = _shape;
    if (lines == null || shape == null) {
      return;
    }

    /// STOKANAL-FORK-EDIT: logging
    // if (text == 'F' && Random().nextDouble() < 0.01) {
    //   log('TEXT DRAW F > ${hashCode} lines=${_lines?.length} shape=${_shape!=null} styles=${_renderStyles.length} runs=${runs.map((r) => '${r.name}=${r.text}').join(",")}');
    // } else if (text == 'C' && Random().nextDouble() < 0.01) {
    //   log('TEXT DRAW C > ${hashCode} lines=${_lines?.length} shape=${_shape!=null} styles=${_renderStyles.length} runs=${runs.map((r) => '${r.name}=${r.text}').join(",")}');
    // }

    if (!clip(canvas)) {
      canvas.save();
    }
    canvas.transform(worldTransform.mat4);
    canvas.transform(_transform.mat4);
    if (overflow == TextOverflow.clipped && _clipRenderPath != null) {
      canvas.clipPath(_clipRenderPath!);
    }
    for (final style in _renderStyles) {
      style.draw(canvas);
    }
    canvas.restore();
  }

  void markShapeDirty({bool sendToLayout = true}) {
    _measuredSizeMax = Size.zero;
    _disposeShape();
    addDirt(ComponentDirt.path);
    for (final group in _modifierGroups) {
      group.clearRangeMaps();
    }
    markWorldTransformDirty();

    if (sendToLayout) {
      _markLayoutNodeDirty();
    }
  }

  void _markLayoutNodeDirty() {
    for (ContainerComponent? p = parent; p != null; p = p.parent) {
      if (p is LayoutComponent) {
        p.markLayoutNodeDirty();
      }
    }
  }

  /// Called when a modifier causes the text's shape to change.
  void modifierShapeDirty() {
    _measuredSizeMax = Size.zero;
    _disposeShape();
    addDirt(ComponentDirt.path);
  }

  // TODO: figure out asset system
  static Font? _defaultFont;
  int _unicharCount = 0;

  void markPaintDirty() => addDirt(ComponentDirt.paint);

  void computeShape() {
    markPaintDirty();
    _shape = null;
    _lines?.dispose();
    _lines = null;
    if (runs.isEmpty) {
      _bounds = AABB.collapsed(Vec2D());

      return;
    }

    double breakWidth =
        effectiveSizing == TextSizing.autoWidth ? -1 : effectiveWidth;

    // Question (max): is it safer to simply skip computing Shape if we
    // have no default font?
    assert(_defaultFont != null);
    var defaultFont = _defaultFont!;
    _modifierShape?.dispose();
    _modifierLines?.dispose();
    // We have modifiers that need shaping we'll need to compute the coverage
    // right before we build the actual shape.
    bool precomputeModifierCoverage = modifierRangesNeedShape;
    if (precomputeModifierCoverage) {
      // TODO: we could not re-compute this shape if the rangeMappers are all
      // still valid. We'd only have to run group.computeCoverage below.
      _modifierStyledText = makeStyled(defaultFont, withModifiers: false);
      _modifierShape = defaultFont.shape(
        _modifierStyledText!.value,
        _modifierStyledText!.runs,
      );
      _modifierLines = _modifierShape?.breakLines(breakWidth, align, wrap);
      _glyphLookup = GlyphLookup.fromShape(
          _modifierShape!, _modifierStyledText!.value.length);
      _unicharCount = _modifierStyledText!.value.length;
      for (final group in _modifierGroups) {
        group.computeRangeMap(_modifierStyledText!.value, _modifierShape!,
            _modifierLines!, _glyphLookup!);
        group.computeCoverage(_unicharCount);
      }
    } else {
      _modifierShape = null;
      _modifierLines = null;
      _glyphLookup = null;
    }

    bool haveModifiers = _modifierGroups.isNotEmpty;

    var styled = makeStyled(defaultFont, withModifiers: haveModifiers);
    _shape = defaultFont.shape(
      styled.value,
      styled.runs,
    );
    _unicharCount = styled.value.length;
    _cleanupShapes.add(_shape!);
    _lines = _shape?.breakLines(breakWidth, align, wrap);

    // If we did not pre-compute the range then we can do it now.
    if (!precomputeModifierCoverage && haveModifiers && _shape != null) {
      _glyphLookup ??= GlyphLookup.fromShape(_shape!, _unicharCount);
      for (final group in _modifierGroups) {
        group.computeRangeMap(styled.value, _shape, _lines, _glyphLookup!);
      }
    }
  }

  bool get modifierRangesNeedShape =>
      _modifierGroups.any((group) => group.needsShape);

  bool _computeShapeWhenNecessary(int dirt) {
    if (dirt & ComponentDirt.path != 0) {
      // TODO: (Luigi) Hardcoded font for now
      if (_defaultFont == null) {
        _defaultFont = getFirstAvailableFont();
        if (_defaultFont != null) {
          markShapeDirty();
        }
      } else {
        computeShape();
        return true;
      }
    }
    return false;
  }

  @override
  void update(int dirt) {
    super.update(dirt);
    bool rebuildRenderStyles =
        _computeShapeWhenNecessary(dirt) || (dirt & ComponentDirt.paint != 0);
    // Could optimize this to do what the C++ runtime does by propagating
    // opacity to the styles instead of rebuilding render styles.
    if (dirt & ComponentDirt.worldTransform != 0) {
      for (final style in styles) {
        for (final paint in style.shapePaints) {
          if (paint.renderOpacity != renderOpacity) {
            paint.renderOpacity = renderOpacity;
            rebuildRenderStyles = true;
          }
        }
      }
    }
    if (rebuildRenderStyles) {
      _buildRenderStyles();
    }
  }

  @override
  void onRemoved() {
    super.onRemoved();
    _disposeShape();
    _modifierShape?.dispose();
    _modifierLines?.dispose();
    _lines?.dispose();
    disposeStyleContainer();
    _lines = null;
  }

  @override
  void alignValueChanged(int from, int to) {
    markShapeDirty();
  }

  @override
  void verticalAlignValueChanged(int from, int to) {
    markShapeDirty();
  }

  @override
  void fitFromBaselineChanged(bool from, bool to) {
    markShapeDirty();
  }

  TextAlign get align => enumAt(TextAlign.values, alignValue);
  set align(TextAlign value) => alignValue = value.index;

  @override
  void heightChanged(double from, double to) {
    if (sizing == TextSizing.fixed) {
      markShapeDirty();
    }
  }

  TextSizing get sizing => TextSizing.values[sizingValue];
  TextSizing get effectiveSizing =>
      _layoutHeight != null ? TextSizing.fixed : TextSizing.values[sizingValue];
  TextWrap get wrap => TextWrap.values[wrapValue];

  set sizing(TextSizing value) => sizingValue = value.index;
  TextOverflow get overflow {
    return enumAt(TextOverflow.values, overflowValue);
  }

  VerticalTextAlign get verticalAlign {
    return enumAt(VerticalTextAlign.values, verticalAlignValue);
  }

  set overflow(TextOverflow value) => overflowValue = value.index;

  @override
  void sizingValueChanged(int from, int to) {
    markShapeDirty();
  }

  @override
  void widthChanged(double from, double to) {
    if (sizing != TextSizing.autoWidth) {
      markShapeDirty();
    }
  }

  @override
  void overflowValueChanged(int from, int to) {
    if (sizing != TextSizing.autoWidth) {
      markShapeDirty();
    } else {
      markPaintDirty();
    }
  }

  @override
  void wrapValueChanged(int from, int to) {
    markShapeDirty();
  }

  @override
  String toString() => 'Text(id: $id, text: $text)';

  @override
  void originXChanged(double from, double to) {
    markPaintDirty();
    // Mostly for constraints.
    markWorldTransformDirty();
  }

  @override
  void originYChanged(double from, double to) {
    markPaintDirty();
    // Mostly for constraints.
    markWorldTransformDirty();
  }

  @override
  void paragraphSpacingChanged(double from, double to) {
    markPaintDirty();
  }

  TextOrigin get textOrigin => TextOrigin.values[originValue];

  @override
  void originValueChanged(int from, int to) {
    markPaintDirty();
    markWorldTransformDirty();
  }
}
