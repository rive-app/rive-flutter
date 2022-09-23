import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'renderfont_ffi.dart' if (dart.library.html) 'renderfont_wasm.dart';

class Vec2D {
  final double x;
  final double y;

  Vec2D(this.x, this.y);
}

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

abstract class RenderGlyphRun {
  RenderFont get renderFont;
  double get fontSize;
  int get styleId;
  int get glyphCount;
  int glyphIdAt(int index);
  int textOffsetAt(int index);
  double xAt(int index);
}

enum TextAlign { left, right, center }

abstract class TextLine {
  int get startRun;
  int get startIndex;
  int get endRun;
  int get endIndex;
  double get startX;
  double get top;
  double get baseline;
  double get bottom;
}

abstract class TextShapeResult {
  int get runCount;
  RenderGlyphRun runAt(int index);
  void dispose();

  void breakLines(double width, TextAlign alignment);
  int get lineCount;
  TextLine lineAt(int index);
}

/// A representation of a styled section of text in Rive.
class RenderTextRun {
  final RenderFont font;
  final double fontSize;
  final int styleId;
  final int unicharCount;

  RenderTextRun({
    required this.font,
    required this.fontSize,
    required this.unicharCount,
    this.styleId = 0,
  });
}

abstract class RenderFont {
  static Future<void> initialize() => initRenderFont();
  static RenderFont? decode(Uint8List bytes) => decodeRenderFont(bytes);
  RawPath getPath(int glyphId);
  void dispose();

  TextShapeResult shape(String text, List<RenderTextRun> runs);
}
