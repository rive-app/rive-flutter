import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:rive/math.dart';

import 'rive_text_ffi.dart' if (dart.library.html) 'rive_text_wasm.dart';

enum RawPathVerb { move, line, quad, cubic, close }

abstract class RawPathCommand {
  final RawPathVerb verb;
  RawPathCommand(this.verb);
  Vec2D point(int index);
}

abstract class RawPath with IterableMixin<RawPathCommand> {
  void dispose();
  void issueCommands(ui.Path path) {
    for (final command in this) {
      switch (command.verb) {
        case RawPathVerb.move:
          var p = command.point(0);
          path.moveTo(p.x, p.y);
          break;
        case RawPathVerb.line:
          var p = command.point(1);
          path.lineTo(p.x, p.y);
          break;
        case RawPathVerb.quad:
          var p1 = command.point(1);
          var p2 = command.point(2);
          path.quadraticBezierTo(p1.x, p1.y, p2.x, p2.y);

          break;
        case RawPathVerb.cubic:
          var p1 = command.point(1);
          var p2 = command.point(2);
          var p3 = command.point(3);
          path.cubicTo(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
          break;
        case RawPathVerb.close:
          path.close();
          break;
      }
    }
  }
}

enum TextDirection { ltr, rtl }

enum TextAlign { left, right, center }

abstract class Paragraph {
  TextDirection get direction;
  List<GlyphRun> get runs;
  List<GlyphRun> get logicalRuns => runs;

  List<GlyphRun> orderVisually(List<GlyphRun> glyphRuns) {
    if (direction == TextDirection.ltr) {
      return glyphRuns;
    }
    var visualOrder = <GlyphRun>[];
    if (glyphRuns.isNotEmpty) {
      var reversed = glyphRuns.reversed;
      GlyphRun previous = reversed.first;
      visualOrder.add(previous);
      int ltrIndex = 0;
      for (final run in reversed.skip(1)) {
        if (run.direction == TextDirection.ltr &&
            previous.direction == run.direction) {
          visualOrder.insert(ltrIndex, run);
        } else {
          if (run.direction == TextDirection.ltr) {
            ltrIndex = visualOrder.length;
          }
          visualOrder.add(run);
        }
        previous = run;
      }
    }
    return visualOrder;
  }

  List<GlyphRun> get visualRuns => orderVisually(runs);
}

abstract class GlyphRun {
  Font get font;
  double get fontSize;
  int get styleId;
  int get glyphCount;
  TextDirection get direction;
  int glyphIdAt(int index);
  int textIndexAt(int index);
  double advanceAt(int index);
}

class LineRunGlyph {
  final GlyphRun run;
  final int index;

  LineRunGlyph(this.run, this.index);

  Float64List renderTransform(double x, double y) {
    var scale = run.fontSize;
    return Float64List.fromList([
      scale,
      0.0,
      0.0,
      0.0,
      0.0,
      scale,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
      x,
      y,
      0.0,
      1.0
    ]);
  }

  @override
  bool operator ==(Object other) =>
      other is LineRunGlyph && other.run == run && other.index == index;
}

abstract class GlyphLine {
  int get startRun;
  int get startIndex;
  int get endRun;
  int get endIndex;
  double get startX;
  double get top;
  double get baseline;
  double get bottom;

  /// Returns an iterator that traverses the glyphs in a line in visual order
  /// taking into account both the paragraph's runs bidi order and the
  /// individual glyphs bidi order within a run.
  Iterable<LineRunGlyph> glyphs(Paragraph paragraph) sync* {
    var displayRuns = <GlyphRun>[];
    var glyphRuns = paragraph.runs;
    int runIndex, bidiEndRun, runInc;
    // if (paragraph.direction == TextDirection.rtl) {
    //   runIndex = endRun;
    //   bidiEndRun = startRun - 1;
    //   runInc = -1;
    // } else {
    runIndex = startRun;
    bidiEndRun = endRun + 1;
    runInc = 1;
    // }
    while (runIndex != bidiEndRun) {
      var run = glyphRuns[runIndex];
      displayRuns.add(run);
      // int startGIndex = runIndex == startRun ? startIndex : 0;
      // int endGIndex = runIndex == endRun ? endIndex : run.glyphCount;

      // int j, end, inc;
      // if (run.direction == TextDirection.rtl) {
      //   j = endGIndex - 1;
      //   end = startGIndex - 1;
      //   inc = -1;
      // } else {
      //   j = startGIndex;
      //   end = endGIndex;
      //   inc = 1;
      // }

      // while (j != end) {
      //   yield LineRunGlyph(run, j);
      //   startGIndex = 0;
      //   j += inc;
      // }
      runIndex += runInc;
    }

    var startRunRef = displayRuns.first;
    var endRunRef = displayRuns.last;

    for (final run in paragraph.orderVisually(displayRuns)) {
      int startGIndex = startRunRef == run ? startIndex : 0;
      int endGIndex = endRunRef == run ? endIndex : run.glyphCount;

      int j, end, inc;
      if (run.direction == TextDirection.rtl) {
        j = endGIndex - 1;
        end = startGIndex - 1;
        inc = -1;
      } else {
        j = startGIndex;
        end = endGIndex;
        inc = 1;
      }

      while (j != end) {
        yield LineRunGlyph(run, j);
        startGIndex = 0;
        j += inc;
      }
    }

    // var glyphRuns = paragraph.visualRuns;
    // int runIndex, bidiEndRun, runInc;
    // if (paragraph.direction == TextDirection.rtl) {
    //   runIndex = endRun;
    //   bidiEndRun = startRun - 1;
    //   runInc = -1;
    // } else {
    //   runIndex = startRun;
    //   bidiEndRun = endRun + 1;
    //   runInc = 1;
    // }
    // while (runIndex != bidiEndRun) {
    //   var run = glyphRuns[runIndex];
    //   int startGIndex = runIndex == startRun ? startIndex : 0;
    //   int endGIndex = runIndex == endRun ? endIndex : run.glyphCount;

    //   int j, end, inc;
    //   if (run.direction == TextDirection.rtl) {
    //     j = endGIndex - 1;
    //     end = startGIndex - 1;
    //     inc = -1;
    //   } else {
    //     j = startGIndex;
    //     end = endGIndex;
    //     inc = 1;
    //   }

    //   while (j != end) {
    //     yield LineRunGlyph(run, j);
    //     startGIndex = 0;
    //     j += inc;
    //   }
    //   runIndex += runInc;
    // }
  }
}

abstract class BreakLinesResult extends ListBase<List<GlyphLine>> {
  void dispose();
}

abstract class TextShapeResult {
  List<Paragraph> get paragraphs;
  void dispose();
  BreakLinesResult breakLines(double width, TextAlign alignment);
}

/// A representation of a styled section of text in Rive.
class TextRun {
  final Font font;
  final double fontSize;
  final int unicharCount;
  final int styleId;

  TextRun({
    required this.font,
    required this.fontSize,
    required this.unicharCount,
    this.styleId = 0,
  });

  TextRun copy({required int copyUnicharCount}) => TextRun(
        font: font,
        fontSize: fontSize,
        unicharCount: copyUnicharCount,
        styleId: styleId,
      );

  @override
  toString() => 'TextRun($fontSize:$unicharCount:$styleId)';
}

abstract class Font {
  static Future<void> initialize() => initFont();
  static Font? decode(Uint8List bytes) => decodeFont(bytes);
  RawPath getPath(int glyphId);
  void dispose();

  TextShapeResult shape(String text, List<TextRun> runs);
}
