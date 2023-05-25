import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:rive/src/generated/text/text_base.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/text/styled_text.dart';
import 'package:rive/src/rive_core/text/text_style.dart' as rive;
import 'package:rive/src/rive_core/text/text_style_container.dart';
import 'package:rive/src/rive_core/text/text_value_run.dart';
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

class Text extends TextBase with TextStyleContainer {
  TextShapeResult? _shape;
  // Shapes that should be cleaned before next shaping call.
  final List<TextShapeResult> _cleanupShapes = [];
  BreakLinesResult? _lines;
  // TextShapeResult? get shape => _shape;
  BreakLinesResult? get lines => _lines;

  bool get isEmpty => runs.isEmpty || !runs.any((run) => run.text.isNotEmpty);

  StyledText makeStyled(Font defaultFont, {bool forEditing = false}) {
    final List<TextRun> textRuns = [];
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
        unicharCount: run.text.codeUnits.length,
        styleId: runIndex++,
      ));
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
  TextShapeResult? shape(Font defaultFont) {
    if (_shape != null) {
      return _shape;
    }
    var styled = makeStyled(defaultFont);
    return _shape = defaultFont.shape(
      styled.value,
      styled.runs,
    );
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
    updateStyles();
  }

  @override
  void onAdded() {
    super.onAdded();
    _syncRuns();
  }

  // We cache the text drawing into a display list so subsequent draws are
  // faster.
  Picture? _textPicture;

  final Size _size = Size.zero;

  static const double paragraphSpacing = 20;

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

  @override
  void draw(Canvas canvas) {
    var lines = _lines;
    var shape = _shape;
    if (lines == null || shape == null) {
      return;
    }
    if (_textPicture == null) {
      var recorder = PictureRecorder();
      var canvas = Canvas(recorder);

      double y = 0;
      double maxX = 0;
      var paragraphIndex = 0;
      int ellipsisLine = -1;
      bool isEllipsisLineLast = false;

      // Find the line to put the ellipsis on (line before the one that
      // overflows).
      if (overflow == TextOverflow.ellipsis && sizing == TextSizing.fixed) {
        int lastLineIndex = -1;
        for (final paragraphLines in lines) {
          for (final line in paragraphLines) {
            lastLineIndex++;
            if (y + line.bottom <= height) {
              ellipsisLine++;
            }
          }

          if (paragraphLines.isNotEmpty) {
            y += paragraphLines.last.bottom;
          }
          y += paragraphSpacing;
        }
        if (ellipsisLine == -1) {
          // Nothing fits, just show the first line and ellipse it.
          ellipsisLine = 0;
        }
        isEllipsisLineLast = lastLineIndex == ellipsisLine;
        y = 0;
      }

      int lineIndex = 0;
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

          double x = line.startX;
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

            // canvas.save();
            // canvas.transform();
            var renderPath =
                path.transform(glyphInfo.pathTransform(x, y + line.baseline));
            var style = styleFromShaperId(run.styleId);
            if (style == null || style.shapePaints.isEmpty) {
              canvas.drawPath(
                renderPath,
                Paint()..color = const Color(0xFFFFFFFF),
              );
            } else {
              for (final shapePaint in style.shapePaints) {
                if (!shapePaint.isVisible) {
                  continue;
                }
                canvas.drawPath(
                  renderPath,
                  shapePaint.paint,
                );
              }
            }
            // canvas.restore();

            x += run.advanceAt(glyphInfo.index);
          }
          if (x > maxX) {
            maxX = x;
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

      _textPicture = recorder.endRecording();
    }

    canvas.save();
    canvas.transform(worldTransform.mat4);
    if (overflow == TextOverflow.clipped) {
      canvas.clipRect(Offset.zero & _size);
    }
    canvas.drawPicture(_textPicture!);
    canvas.restore();
  }

  void markShapeDirty() {
    _disposeShape();
    addDirt(ComponentDirt.path);
  }

  // TODO: figure out asset system
  static Font? _defaultFont;

  void markPaintDirty() {
    _textPicture?.dispose();
    _textPicture = null;
  }

  void computeShape() {
    markPaintDirty();
    _shape = null;
    _lines?.dispose();
    _lines = null;
    if (runs.isEmpty) {
      return;
    }
    _shape = shape(_defaultFont!);
    _cleanupShapes.add(_shape!);

    _lines =
        _shape?.breakLines(sizing == TextSizing.autoWidth ? -1 : width, align);
  }

  @override
  void update(int dirt) {
    super.update(dirt);
    if (dirt & ComponentDirt.path != 0) {
      // Hardcode font for now.
      if (_defaultFont == null) {
        rootBundle.load('assets/fonts/Inter-Regular.ttf').then((fontAsset) {
          _defaultFont = Font.decode(fontAsset.buffer.asUint8List());
          // Reshape now that we have font.
          markShapeDirty();
        });
      } else {
        computeShape();
      }
    }
    if (dirt & ComponentDirt.worldTransform != 0) {
      for (final style in styles) {
        for (final paint in style.shapePaints) {
          paint.renderOpacity = renderOpacity;
        }
      }
      markPaintDirty();
    }
  }

  @override
  void onRemoved() {
    super.onRemoved();
    _disposeShape();
    _lines?.dispose();
    disposeStyleContainer();
    _lines = null;
  }

  @override
  void alignValueChanged(int from, int to) => markShapeDirty();

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
}
