import 'dart:async';
import 'dart:ui' as ui;

import 'package:rive/math.dart';
import 'package:rive/src/renderfont.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ui.Path paintGlyphPath = ui.Path();

// var text = "hi I'm some text";
// var textUni = text.codeUnits;
// // print("ALLOC SOME RENDERTEXTRUNS");

// var runs =
//     calloc.allocate<RenderTextRunNative>(1 * sizeOf<RenderTextRunNative>());
// runs[0]
//   ..font = result
//   ..size = 32.0
//   ..unicharCount = textUni.length;

// var textBuffer = calloc.allocate<Uint32>(textUni.length * sizeOf<Uint32>());
// for (int i = 0; i < textUni.length; i++) {
//   textBuffer[i] = textUni[i];
// }
// var shapeResult = shapeText(textBuffer, textUni.length, runs, 1);

// calloc.free(textBuffer);
// calloc.free(runs);

Future<void> renderFontDemo() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RenderFont.initialize();

  var robotoData = await rootBundle.load('assets/RobotoFlex.ttf');
  var montserratData = await rootBundle.load('assets/Montserrat.ttf');
  var roboto = RenderFont.decode(robotoData.buffer.asUint8List());
  var montserrat = RenderFont.decode(montserratData.buffer.asUint8List());
  if (roboto != null && montserrat != null) {
    var text1 = "no one ever left alive in ";
    var text2 = "nineteen hundred";
    var text3 = " and eighty five";
    var text = text1 + text2 + text3;
    print("CODE UNITS ${text.codeUnits}");
    print("RUN LEN ${text1.length} ${text2.length} ${text3.length}");
    print(text);
    var glyphRuns = roboto.shape(
      text,
      [
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
      ],
    );

    print("PRE BROKE IT ${glyphRuns.lineCount}");
    glyphRuns.breakLines(200, TextAlign.right);
    print(" BROKE IT ${glyphRuns.lineCount}");

    for (int i = 0; i < glyphRuns.lineCount; i++) {
      var line = glyphRuns.lineAt(i);

      var x0 = glyphRuns.runAt(line.startRun).xAt(line.startIndex);
      int startGlyphIndex = line.startIndex;
      print("LINE ${line.startRun} ${line.endRun}");
      for (int runIndex = line.startRun; runIndex <= line.endRun; runIndex++) {
        var run = glyphRuns.runAt(runIndex);
        print("RUN STYLE: ${run.styleId}");
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
          paintGlyphPath.addPath(path, ui.Offset.zero, matrix4: transform.mat4);
          startGlyphIndex = 0;
        }
      }
    }
    // for (int i = 0; i < glyphRuns.runCount; i++) {
    //   var run = glyphRuns.runAt(i);
    //   for (int j = 0; j < run.glyphCount; j++) {
    //     var path = ui.Path();

    //     var glyph = run.renderFont.getPath(run.glyphIdAt(j));
    //     glyph.issueCommands(path);
    //     glyph.dispose();

    //     // auto trans = rive::Mat2D::fromTranslate(origin.x + run.xpos[i], origin.y);
    //     // auto rawpath = font->getPath(run.glyphs[i]);
    //     // rawpath.transformInPlace(trans * scale);
    //     var scale = Mat2D.fromScale(run.fontSize, run.fontSize);
    //     var translation = Mat2D.fromTranslate(run.xAt(j), 0);
    //     var transform = Mat2D.multiply(Mat2D(), translation, scale);
    //     paintGlyphPath.addPath(path, ui.Offset.zero, matrix4: transform.mat4);
    //   }
    //   // run.fontSize
    //   // run.xAt(index)
    // }
    glyphRuns.dispose();
    montserrat.dispose();
    roboto.dispose();
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
        body: Center(
            // child: Text('Running on: $_platformVersion\n'),
            child: CustomPaint(
          painter: PathPainter(paintGlyphPath),
        )),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  final Path path;
  PathPainter(this.path);
  @override
  void paint(Canvas canvas, ui.Size size) {
    canvas.save();
    canvas.translate(-300, -200);
    //canvas.scale(100, 100);
    canvas.drawPath(
      path,
      Paint()..isAntiAlias = true,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
