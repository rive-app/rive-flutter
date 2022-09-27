import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:rive/math.dart';
import 'package:rive/src/renderfont.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Stored at text indices
class CursorPosition {
  final int line;
  final int character;

  CursorPosition({
    required this.line,
    required this.character,
  });
  CursorPosition.zero()
      : this.line = 0,
        this.character = 0;

  @override
  String toString() => '($line:$character)';
}

class Cursor {
  final CursorPosition start;
  final CursorPosition end;

  Cursor.collapsed(CursorPosition position)
      : start = position,
        end = position;

  Cursor(this.start, this.end);
  Cursor.start()
      : this(
          CursorPosition.zero(),
          CursorPosition.zero(),
        );

  @override
  String toString() => 'Cursor: $start->$end';
}

T? iterateLine<T>(TextShapeResult shape, TextLine line,
    T? eachGlyph(double x, double nextX, int index, int nextIndex)) {
  var x0 = -shape.runAt(line.startRun).xAt(line.startIndex) + line.startX;
  int startGlyphIndex = line.startIndex;

  double lastX = 0;
  int lastIndex = -1;
  for (int runIndex = line.startRun; runIndex <= line.endRun; runIndex++) {
    var run = shape.runAt(runIndex);
    int endGlyphIndex =
        runIndex == line.endRun ? line.endIndex + 1 : run.glyphCount;

    for (int j = startGlyphIndex; j < endGlyphIndex; j++) {
      var x = x0 + run.xAt(j);
      var index = run.textIndexAt(j);
      if (lastIndex != -1) {
        var result = eachGlyph(lastX, x, lastIndex, index);
        if (result != null) {
          return result;
        }
      }
      lastIndex = index;
      lastX = x;
    }
    startGlyphIndex = 0;
  }
  return null;
}

class LinePoint {
  final double x;
  final double nextX;
  final int index;
  final int nextIndex;

  LinePoint(this.x, this.nextX, this.index, this.nextIndex);
}

List<LinePoint> linePoints(TextShapeResult shape, TextLine line) {
  List<LinePoint> points = [];
  iterateLine(shape, line, (x, nextX, index, nextIndex) {
    points.add(LinePoint(x, nextX, index, nextIndex));
  });
  return points;
}

class TextEdit {
  final String text;
  final List<RenderTextRun> runs;
  final TextShapeResult shape;

  TextEdit({
    required this.text,
    required this.runs,
    required this.shape,
  });

  Cursor moveCursorTo(Vec2D position) {
    for (int i = 0; i < shape.lineCount; i++) {
      var line = shape.lineAt(i);
      if (position.y < line.top) {
        // print("SAD ${line.top} ${line.bottom}");
        break;
      }
      if (position.y > line.bottom) {
        continue;
      }

      late Cursor cursor;

      var points = linePoints(shape, line);
      if (position.x < points.first.x) {
        var firstRun = shape.runAt(line.startRun);
        cursor = Cursor.collapsed(
          CursorPosition(
            line: i,
            character: firstRun.textIndexAt(line.startIndex),
          ),
        );
      } else if (position.x > points.last.nextX) {
        var endRun = shape.runAt(line.endRun);
        cursor = Cursor.collapsed(
          CursorPosition(
            line: i,
            character: endRun.textIndexAt(line.endIndex),
          ),
        );
      } else {
        for (final pt in points) {
          if (position.x <= pt.nextX) {
            var ratio = (position.x - pt.x) / (pt.nextX - pt.x);

            // print("OH X IS LESS $ratio $index $nextIndex");
            // var idx = run.textIndexAt(ratio > 0.5 ? j : j - 1);
            var cursorPosition = CursorPosition(
                line: i, character: ratio > 0.5 ? pt.nextIndex : pt.index);
            cursor = Cursor(cursorPosition, cursorPosition);
            break;
          }
        }

        // cursor = iterateLine(
        //       shape,
        //       line,
        //       ((x, nextX, index, nextIndex) {
        //         if (position.x <= nextX) {
        //           var ratio = (position.x - x) / (nextX - x);

        //           print("OH X IS LESS $ratio $index $nextIndex");
        //           // var idx = run.textIndexAt(ratio > 0.5 ? j : j - 1);
        //           var cursorPosition = CursorPosition(
        //               line: i, character: ratio > 0.5 ? nextIndex : index);
        //           return Cursor(cursorPosition, cursorPosition);
        //         }
        //         return null;
        //       }),
        //     ) ??
        //     Cursor.collapsed(
        //       CursorPosition(
        //         line: i,
        //         character: shape.runAt(line.endRun).textIndexAt(line.endIndex),
        //       ),
        //     );
      }
      return cursor;

      // var x0 = -shape.runAt(line.startRun).xAt(line.startIndex) + line.startX;
      // int startGlyphIndex = line.startIndex;
      // if (position.x < x0) {
      //   print("OH LESS: ${position.x} $x0");
      //   // TODO: Set at start of this line
      //   break;
      // }
      // for (int runIndex = line.startRun; runIndex <= line.endRun; runIndex++) {
      //   var run = shape.runAt(runIndex);
      //   int endGlyphIndex =
      //       runIndex == line.endRun ? line.endIndex : run.glyphCount;

      //   // TODO: make a line iterator that iterates glyphs
      //   // Returns something lke {
      //   // run:
      //   //  x: 34.0,
      //   //  idx: 3,
      //   //  nextX: 35.0f,
      //   //  nextIdx: 4
      //   // nextRun:
      //   // }
      //   for (int j = startGlyphIndex + 1; j <= endGlyphIndex; j++) {
      //     var px = run.xAt(j - 1);
      //     var cx = run.xAt(j);

      //     print(":: $j $endGlyphIndex ${run.glyphCount}");
      //     if (position.x <= x0 + cx) {
      //       var ratio = (position.x - (x0 + px)) / (cx - px);

      //       print("OH X IS LESS $j $ratio");
      //       var idx = run.textIndexAt(ratio > 0.5 ? j : j - 1);
      //       var cursorPosition = CursorPosition(line: i, character: idx);
      //       return Cursor(cursorPosition, cursorPosition);
      //     }
      //   }
      //   startGlyphIndex = 0;
    }
    // break;
    return Cursor.start();
  }
}

class DemoTextEditor {
  final RenderFont roboto;
  final RenderFont montserrat;
  final ui.Path uiPath = ui.Path();
  late TextShapeResult glyphRuns;
  late List<RenderTextRun> textRuns;
  late String text;
  Cursor cursor = Cursor.start();

  DemoTextEditor(this.roboto, this.montserrat) {
    var text1 = "no one ever left alive in ";
    var text2 = "nineteen hundre";
    var text3 = "d and eighty >= five !== ok";
    text = text1 + text2 + text3;
    textRuns = [
      RenderTextRun(
        font: roboto,
        fontSize: 32.0,
        unicharCount: text1.length,
        styleId: 2,
      ),
      RenderTextRun(
        font: montserrat,
        fontSize: 54.0,
        unicharCount: text2.length,
        styleId: 1,
      ),
      RenderTextRun(
        font: roboto,
        fontSize: 32.0,
        unicharCount: text3.length,
        styleId: 4,
      ),
    ];

    glyphRuns = roboto.shape(
      text,
      textRuns,
    );

    glyphRuns.breakLines(200, TextAlign.left);
    updatePath();
  }

  void reshape() {
    // glyphRuns.dispose();
    // montserrat.dispose();
    // roboto.dispose();
  }

  void dispose() {
    glyphRuns.dispose();
    montserrat.dispose();
    roboto.dispose();
  }

  void updatePath() {
    uiPath.reset();
    for (int i = 0; i < glyphRuns.lineCount; i++) {
      var line = glyphRuns.lineAt(i);

      var x0 = glyphRuns.runAt(line.startRun).xAt(line.startIndex);
      int startGlyphIndex = line.startIndex;

      for (int runIndex = line.startRun; runIndex <= line.endRun; runIndex++) {
        var run = glyphRuns.runAt(runIndex);
        int endGlyphIndex =
            runIndex == line.endRun ? line.endIndex : run.glyphCount;

        var font = run.renderFont;
        var scale = Mat2D.fromScale(run.fontSize, run.fontSize);
        for (int j = startGlyphIndex; j < endGlyphIndex; j++) {
          var path = ui.Path();
          var glyph = font.getPath(run.glyphIdAt(j));
          glyph.issueCommands(path);
          glyph.dispose();

          var translation = Mat2D.fromTranslate(
              -x0 + line.startX + run.xAt(j), line.baseline);
          var transform = Mat2D.multiply(Mat2D(), translation, scale);
          uiPath.addPath(path, ui.Offset.zero, matrix4: transform.mat4);
        }
        startGlyphIndex = 0;
      }
    }
  }

  void draw(Canvas canvas, ui.Size size) {
    canvas.save();
    // canvas.translate(-300, -200);
    // canvas.scale(100, 100);

    // Draw Cursor

    var cursorPosition = cursor.start;
    var line = glyphRuns.lineAt(cursorPosition.line);
    //var points = linePoints(shape, line);

    double lastX = 0;
    var cursorRect = iterateLine(
          glyphRuns,
          line,
          ((x, nextX, index, nextIndex) {
            print("ITR: ${text[index]} ${text[nextIndex]}");
            if (nextIndex >= cursorPosition.character) {
              var steps = cursorPosition.character - index;
              var range = (nextX - x) / max(1, steps);

              // Find line

              return Rect.fromLTWH(
                x + range * steps,
                line.top,
                1,
                line.bottom - line.top,
              );
            } else {
              lastX = nextX;
            }
            return null;
          }),
        ) ??
        Rect.fromLTWH(
          lastX,
          line.top,
          1,
          line.bottom - line.top,
        );

    canvas.drawRect(cursorRect, Paint());
    canvas.drawPath(
      uiPath,
      Paint()..isAntiAlias = true,
    );
    canvas.restore();
  }

  void moveCursorTo(Vec2D position, bool rangeSelect) {
    var editOp = TextEdit(runs: textRuns, shape: glyphRuns, text: text);
    cursor = editOp.moveCursorTo(position);
    print("MOVE $cursor $position");
  }
}

DemoTextEditor? editor;
Future<void> renderFontDemo() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RenderFont.initialize();

  var robotoData =
      await rootBundle.load('assets/FiraCode-VariableFont_wght.ttf');
  var montserratData = await rootBundle.load('assets/Montserrat.ttf');
  var roboto = RenderFont.decode(robotoData.buffer.asUint8List());
  var montserrat = RenderFont.decode(montserratData.buffer.asUint8List());

  if (roboto != null && montserrat != null) {
    editor = DemoTextEditor(roboto, montserrat);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: editor == null
            ? SizedBox()
            : Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: (event) {
                  Vec2D position = Vec2D.fromValues(
                      event.localPosition.dx, event.localPosition.dy);
                  editor!.moveCursorTo(position, false);
                  setState(() {});
                },
                child: CustomPaint(
                  painter: PathPainter(editor!),
                  child: new ConstrainedBox(
                    constraints: new BoxConstraints.expand(),
                  ),
                ),
              ),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  final DemoTextEditor editor;
  PathPainter(this.editor);
  @override
  void paint(Canvas canvas, ui.Size size) {
    editor.draw(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
