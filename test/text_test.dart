import 'dart:ffi';
import 'package:flutter_test/flutter_test.dart';
// ignore: implementation_imports
import 'package:rive/src/rive_text.dart';
import 'src/utils.dart';

void main() {
  test('text shaping works', () {
    final bytes = loadFile('assets/RobotoFlex.ttf');
    expect(bytes.lengthInBytes, 1654412);

    DynamicLibrary.open('shared_lib/build/bin/debug/librive_text.dylib');

    var roboto = Font.decode(bytes.buffer.asUint8List());
    expect(roboto, isNotNull);

    var text = 'ffi test';

    var runs = [
      TextRun(
        font: roboto!,
        fontSize: 32.0,
        unicharCount: text.length,
        styleId: 0,
      )
    ];

    var result = runs.first.font.shape(text, runs);
    expect(result.paragraphs.length, 1);
    expect(result.paragraphs.first.runs.length, 1);
    var glyphRun = result.paragraphs.first.runs.first;

    // ffi gets ligated as a single glyph
    expect(glyphRun.glyphCount, 6);
    expect(glyphRun.textIndexAt(0), 0); // ffi
    expect(glyphRun.textIndexAt(1), 3); // space after ffi

    var breakLinesResult = result.breakLines(60, TextAlign.left);
    expect(breakLinesResult.length, 1); // 1 paragraph
    expect(breakLinesResult.first.length, 2); // 2 lines in the paragraph
    // first line shows first glyph on the left
    expect(breakLinesResult.first.first.startIndex, 0);
    // second line shows third glyph on the left, which is the start of 'test'
    expect(breakLinesResult.first[1].startIndex, 2);
  });
}
