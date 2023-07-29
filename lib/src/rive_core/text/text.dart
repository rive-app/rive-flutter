import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:rive/src/generated/text/text_base.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
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
}

enum TextOrigin {
  top,
  baseline,
}

class Text extends TextBase with TextStyleContainer {
  TextShapeResult? _shape;
  // A shape result specifically for modifiers.
  StyledText? _modifierStyledText;
  TextShapeResult? _modifierShape;
  BreakLinesResult? _modifierLines;

  // Shapes that should be cleaned before next shaping call.
  final List<TextShapeResult> _cleanupShapes = [];
  BreakLinesResult? _lines;
  // TextShapeResult? get shape => _shape;
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

  /// [defaultFont] will be removed when we add asset font options.
  // TextShapeResult? shape(Font defaultFont) {
  //   if (_shape != null) {
  //     return _shape;
  //   }
  //   var styled = makeStyled(defaultFont);
  //   _shape = defaultFont.shape(
  //     styled.value,
  //     styled.runs,
  //   );
  //   if (_modifierGroups.isNotEmpty && _shape != null) {
  //     _glyphLookup = GlyphLookup.fromShape(_shape!, styled.value.length);
  //   } else {
  //     _glyphLookup = null;
  //   }
  //   return _shape;
  // }

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

  AABB _bounds = AABB.collapsed(Vec2D());
  // Size _size = Size.zero;
  Size get size => Size(_bounds.width, _bounds.height);

  @override
  AABB get localBounds => AABB.fromCoordinates(
        x: _bounds.minX - _bounds.width * originX,
        y: _bounds.minY - _bounds.height * originY,
        width: _bounds.width,
        height: _bounds.height,
      );

  void forEachGlyph(
      bool Function(LineRunGlyph, double, double, GlyphLine) callback) {
    var lines = _lines;
    var shape = _shape;
    if (lines == null || shape == null) {
      return;
    }
    double y = 0;
    double maxX = 0;
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
        if (x > maxX) {
          maxX = x;
        }
      }

      if (paragraphLines.isNotEmpty) {
        y += paragraphLines.last.bottom;
      }
      y += paragraphSpacing;
    }
  }

  final List<rive.TextStyle> _renderStyles = [];

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

    // If we want an ellipsis we need to find the line to put the
    // ellipsis on (line before the one that overflows).
    var wantEllipsis =
        overflow == TextOverflow.ellipsis && sizing == TextSizing.fixed;

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
        if (wantEllipsis && y + line.bottom <= height) {
          ellipsisLine++;
        }
      }

      if (paragraphLines.isNotEmpty) {
        y += paragraphLines.last.bottom;
      }

      y += paragraphSpacing;
    }
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
    if (textOrigin == TextOrigin.baseline &&
        lines.isNotEmpty &&
        lines.first.isNotEmpty) {
      y -= lines.first.first.baseline;
      minY = y;
    }

    switch (sizing) {
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
          width,
          max(minY, y - paragraphSpacing),
        );
        break;
      case TextSizing.fixed:
        _bounds = AABB.fromValues(
          0.0,
          minY,
          width,
          minY + height,
        );
        break;
    }

    y = -_bounds.height * originY;
    paragraphIndex = 0;

    outer:
    for (final paragraphLines in lines) {
      final paragraph = shape.paragraphs[paragraphIndex++];
      for (final line in paragraphLines) {
        switch (overflow) {
          case TextOverflow.hidden:
            if (sizing == TextSizing.fixed && y + line.bottom > height) {
              break outer;
            }
            break;
          case TextOverflow.clipped:
            if (sizing == TextSizing.fixed && y + line.top > height) {
              break outer;
            }
            break;
          default:
            break;
        }

        double x = -_bounds.width * originX + line.startX;
        for (final glyphInfo in lineIndex == ellipsisLine
            ? line.glyphsWithEllipsis(
                width,
                paragraph: paragraph,
                isLastLine: isEllipsisLineLast,
                cleanupShapes: _cleanupShapes,
              )
            : line.glyphs(paragraph)) {
          var run = glyphInfo.run;
          var font = run.font;

          var path = font.getUiPath(run.glyphIdAt(glyphInfo.index));

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
            pathTransform = glyphInfo.pathTransform(x, y + line.baseline);
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
            if (style.addPath(renderPath, opacity)) {
              _renderStyles.add(style);
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
  }

  @override
  void draw(Canvas canvas) {
    var lines = _lines;
    var shape = _shape;
    if (lines == null || shape == null) {
      return;
    }

    if (!clip(canvas)) {
      canvas.save();
    }
    canvas.transform(worldTransform.mat4);
    if (overflow == TextOverflow.clipped) {
      canvas.clipRect(Offset.zero & size);
    }
    for (final style in _renderStyles) {
      style.draw(canvas);
    }
    canvas.restore();
  }

  void markShapeDirty() {
    _disposeShape();
    addDirt(ComponentDirt.path);
    for (final group in _modifierGroups) {
      group.clearRangeMaps();
    }
    markWorldTransformDirty();
  }

  /// Called when a modifier causes the text's shape to change.
  void modifierShapeDirty() {
    _disposeShape();
    addDirt(ComponentDirt.path);
  }

  // TODO: figure out asset system
  static Font? _defaultFont;
  int _unicharCount = 0;

  void markPaintDirty() {
    addDirt(ComponentDirt.paint);
  }

  void computeShape() {
    markPaintDirty();
    _shape = null;
    _lines?.dispose();
    _lines = null;
    if (runs.isEmpty) {
      _bounds = AABB.collapsed(Vec2D());

      return;
    }
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
      _modifierLines = _modifierShape?.breakLines(
          sizing == TextSizing.autoWidth ? -1 : width, align);
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
    _lines =
        _shape?.breakLines(sizing == TextSizing.autoWidth ? -1 : width, align);

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

  @override
  void update(int dirt) {
    super.update(dirt);
    bool rebuildRenderStyles = dirt & ComponentDirt.paint != 0;
    if (dirt & ComponentDirt.path != 0) {
      // TODO: (Luigi) Hardcoded font for now
      const defaultFontAsset = 'assets/fonts/Inter-Regular.ttf';
      if (_defaultFont == null) {
        rootBundle.load(defaultFontAsset).then((fontAsset) {
          _defaultFont = Font.decode(fontAsset.buffer.asUint8List());
          // Reshape now that we have font.
          markShapeDirty();
        });
      } else {
        computeShape();
        rebuildRenderStyles = true;
      }
    }

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

  TextAlign get align => TextAlign.values[alignValue];
  set align(TextAlign value) => alignValue = value.index;

  @override
  void heightChanged(double from, double to) {
    if (sizing == TextSizing.fixed) {
      markShapeDirty();
    }
  }

  TextSizing get sizing => TextSizing.values[sizingValue];
  set sizing(TextSizing value) => sizingValue = value.index;
  TextOverflow get overflow {
    return TextOverflow.values[overflowValue];
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
    }
  }

  @override
  String toString() => 'Text(id: $id, text: $text)';

  @override
  void originXChanged(double from, double to) {
    context.markNeedsAdvance();
  }

  @override
  void originYChanged(double from, double to) {
    context.markNeedsAdvance();
  }

  @override
  void paragraphSpacingChanged(double from, double to) {
    markPaintDirty();
  }

  TextOrigin get textOrigin => TextOrigin.values[originValue];

  @override
  void originValueChanged(int from, int to) => markPaintDirty();
}
