import 'dart:async';
import 'dart:ui' as ui;

import 'package:rive/src/renderfont.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ui.Path paintGlyphPath = ui.Path();

Future<void> renderFontDemo() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RenderFont.initialize();

  var robotoData = await rootBundle.load('assets/RobotoFlex.ttf');
  var roboto = RenderFont.decode(robotoData.buffer.asUint8List());
  if (roboto != null) {
    var glyph = roboto.getPath(222);
    glyph.issueCommands(paintGlyphPath);
    glyph.dispose();
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
    canvas.scale(100, 100);
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
