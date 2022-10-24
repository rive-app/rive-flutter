import 'dart:async';
import 'dart:ui' as ui;

import 'package:rive/math.dart';
import 'package:rive/src/rive_text.dart';
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

  await Font.initialize();

  var robotoData = await rootBundle.load('assets/RobotoFlex.ttf');
  var montserratData = await rootBundle.load('assets/Montserrat.ttf');
  var sansArabicData =
      await rootBundle.load('assets/IBMPlexSansArabic-Regular.ttf');
  var roboto = Font.decode(robotoData.buffer.asUint8List());
  var montserrat = Font.decode(montserratData.buffer.asUint8List());
  var sansArabic = Font.decode(sansArabicData.buffer.asUint8List());
  if (roboto != null && montserrat != null && sansArabic != null) {
    var arabicText = "لمفاتيح ABC DEF\n";
    var text1 = "no one ever left alive in ";
    var text2 = "nineteen hundred";
    var text3 = " and eighty five";
    var text = arabicText + text1 + text2 + text3;
    // print("CODE UNITS ${text.codeUnits}");
    // print("RUN LEN ${text1.length} ${text2.length} ${text3.length}");
    // print(text);

    var shape = roboto.shape(
      text,
      [
        TextRun(
          font: sansArabic,
          fontSize: 32.0,
          unicharCount: arabicText.length,
          styleId: 2,
        ),
        TextRun(
          font: roboto,
          fontSize: 32.0,
          unicharCount: text1.length,
          styleId: 2,
        ),
        TextRun(
          font: montserrat,
          fontSize: 54.0,
          unicharCount: text2.length,
          styleId: 1,
        ),
        TextRun(
          font: roboto,
          fontSize: 32.0,
          unicharCount: text3.length,
          styleId: 4,
        ),
      ],
    );

    var paragraphsLines = shape.breakLines(124, TextAlign.left);

    var paragraphs = shape.paragraphs;
    assert(paragraphs.length == paragraphsLines.length);

    double y = 0;
    var paragraphIndex = 0;
    for (var lines in paragraphsLines) {
      var paragraph = paragraphs[paragraphIndex++];
      for (var line in lines) {
        double x = line.startX;
        for (var glyphInfo in line.glyphs(paragraph)) {
          var run = glyphInfo.run;
          var font = run.font;

          var path = ui.Path();
          var glyphPath = font.getPath(run.glyphIdAt(glyphInfo.index));
          glyphPath.issueCommands(path);
          glyphPath.dispose();

          paintGlyphPath.addPath(
            path,
            ui.Offset.zero,
            matrix4: glyphInfo.renderTransform(x, y + line.baseline),
          );

          x += run.advanceAt(glyphInfo.index);
        }
      }
      if (lines.isNotEmpty) {
        y += lines.last.bottom;
      }
      y += 20;
    }
    paragraphsLines.dispose();
    shape.dispose();
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
