import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:rive/math.dart';
import 'package:rive/src/rive_text.dart';

final DynamicLibrary nativeLib = Platform.isAndroid
    ? DynamicLibrary.open('librive_text.so')
    : DynamicLibrary.process();

class PathPoint extends Struct {
  @Float()
  external double x;
  @Float()
  external double y;

  @override
  String toString() => '[$x, $y]';
}

class GlyphPathStruct extends Struct {
  external Pointer<Void> rawPath;
  external Pointer<PathPoint> points;
  external Pointer<Uint8> verbs;

  @Uint16()
  external int verbCount;
}

class GlyphLineFFI extends Struct implements TextLine {
  @override
  @Uint32()
  external int startRun;

  @override
  @Uint32()
  external int startIndex;

  @override
  @Uint32()
  external int endRun;

  @override
  @Uint32()
  external int endIndex;

  @override
  @Float()
  external double startX;

  @override
  @Float()
  external double top;

  @override
  @Float()
  external double baseline;

  @override
  @Float()
  external double bottom;
}

class LinesResultStruct extends Struct {
  external Pointer<Void> result;
  external Pointer<GlyphLineFFI> lines;

  @Uint32()
  external int lineCount;
}

class SimpleUint16Array extends Struct {
  external Pointer<Uint16> data;
  @Uint64()
  external int size;
}

class SimpleUint32Array extends Struct {
  external Pointer<Uint32> data;
  @Uint64()
  external int size;
}

class SimpleFloatArray extends Struct {
  external Pointer<Float> data;
  @Uint64()
  external int size;
}

class TextRunNative extends Struct {
  external Pointer<Void> font;
  @Float()
  external double size;
  @Uint32()
  external int unicharCount;
  @Uint32()
  external int styleId;
}

class GlyphRunNative extends Struct implements GlyphRun {
  external Pointer<Void> fontPtr;
  @Float()
  external double size;

  @override
  @Uint32()
  external int styleId;

  external SimpleUint16Array glyphs;
  external SimpleUint32Array textIndices;
  external SimpleFloatArray xpos;
  external SimpleUint32Array breaks;

  @override
  double get fontSize => size;

  @override
  int get glyphCount => glyphs.size;

  @override
  int glyphIdAt(int index) => glyphs.data.elementAt(index).value;

  @override
  Font get font => FontFFI(fontPtr);

  @override
  int textIndexAt(int index) => textIndices.data.elementAt(index).value;

  @override
  double xAt(int index) => xpos.data.elementAt(index).value;
}

class DynamicTextRunArray extends Struct {
  external Pointer<GlyphRunNative> data;
  @Uint64()
  external int size;
}

class TextShapeResultFFI extends TextShapeResult {
  final Pointer<DynamicTextRunArray> nativeResult;
  TextShapeResultFFI(this.nativeResult);

  LinesResultStruct? _lineBreakResult;

  @override
  void dispose() {
    if (_lineBreakResult != null) {
      deleteBreakLinesResult(_lineBreakResult!.result);
      _lineBreakResult = null;
    }
    deleteShapeResult(nativeResult);
  }

  @override
  GlyphRun runAt(int index) => nativeResult.ref.data.elementAt(index).ref;

  @override
  int get runCount => nativeResult.ref.size;

  @override
  void breakLines(double width, TextAlign alignment) {
    if (_lineBreakResult != null) {
      deleteBreakLinesResult(_lineBreakResult!.result);
    }
    _lineBreakResult = breakLinesNative(nativeResult, width, alignment.index);
  }

  @override
  TextLine lineAt(int index) => _lineBreakResult!.lines.elementAt(index).ref;

  @override
  int get lineCount => _lineBreakResult?.lineCount ?? 0;
}

final Pointer<DynamicTextRunArray> Function(Pointer<Uint32> text,
        int textLength, Pointer<TextRunNative> runs, int runsLength) shapeText =
    nativeLib
        .lookup<
            NativeFunction<
                Pointer<DynamicTextRunArray> Function(Pointer<Uint32>, Uint64,
                    Pointer<TextRunNative>, Uint64)>>('shapeText')
        .asFunction();

final void Function(Pointer<DynamicTextRunArray> font) deleteShapeResult =
    nativeLib
        .lookup<NativeFunction<Void Function(Pointer<DynamicTextRunArray>)>>(
            'deleteShapeResult')
        .asFunction();

final LinesResultStruct Function(
        Pointer<DynamicTextRunArray>, double width, int align)
    breakLinesNative = nativeLib
        .lookup<
            NativeFunction<
                LinesResultStruct Function(
                    Pointer<DynamicTextRunArray>, Float, Uint8)>>('breakLines')
        .asFunction();

final void Function(Pointer<Void>) deleteBreakLinesResult = nativeLib
    .lookup<NativeFunction<Void Function(Pointer<Void>)>>(
        'deleteBreakLinesResult')
    .asFunction();

final Pointer<Void> Function(Pointer<Uint8> bytes, int count) makeFont =
    nativeLib
        .lookup<NativeFunction<Pointer<Void> Function(Pointer<Uint8>, Uint64)>>(
            'makeFont')
        .asFunction();

final void Function(Pointer<Void> font) deleteFont = nativeLib
    .lookup<NativeFunction<Void Function(Pointer<Void>)>>('deleteFont')
    .asFunction();

final GlyphPathStruct Function(
    Pointer<Void> font,
    int
        glyphId) makeGlyphPath = nativeLib
    .lookup<NativeFunction<GlyphPathStruct Function(Pointer<Void>, Uint16)>>(
        'makeGlyphPath')
    .asFunction();

final void Function(Pointer<Void> font) deleteRawPath = nativeLib
    .lookup<NativeFunction<Void Function(Pointer<Void>)>>('deleteRawPath')
    .asFunction();

class RawPathCommandWasm extends RawPathCommand {
  final Pointer<PathPoint> _points;

  RawPathCommandWasm._(
    RawPathVerb verb,
    this._points,
  ) : super(verb);

  @override
  Vec2D point(int index) {
    var ref = _points.elementAt(index).ref;
    return Vec2D.fromValues(ref.x, ref.y);
  }
}

RawPathVerb _verbFromNative(int nativeVerb) {
  switch (nativeVerb) {
    case 0:
      return RawPathVerb.move;
    case 1:
      return RawPathVerb.line;
    case 2:
      return RawPathVerb.quad;
    case 4:
      return RawPathVerb.cubic;
    case 5:
      return RawPathVerb.close;
    default:
      throw Exception('Unexpected nativeVerb: $nativeVerb');
  }
}

int _ptsAdvanceAfterVerb(RawPathVerb verb) {
  switch (verb) {
    case RawPathVerb.move:
      return 1;
    case RawPathVerb.line:
      return 1;
    case RawPathVerb.quad:
      return 2;
    case RawPathVerb.cubic:
      return 3;
    case RawPathVerb.close:
      return 0;
    default:
      throw Exception('Unexpected nativeVerb: $verb');
  }
}

int _ptsBacksetForVerb(RawPathVerb verb) {
  switch (verb) {
    case RawPathVerb.move:
      return 0;
    case RawPathVerb.line:
      return -1;
    case RawPathVerb.quad:
      return -1;
    case RawPathVerb.cubic:
      return -1;
    case RawPathVerb.close:
      return -1;
    default:
      throw Exception('Unexpected nativeVerb: $verb');
  }
}

class RawPathIterator extends Iterator<RawPathCommand> {
  final GlyphPathStruct _native;
  int _verbIndex = -1;
  int _ptIndex = -1;

  RawPathVerb _verb = RawPathVerb.move;

  RawPathIterator._(this._native);

  @override
  RawPathCommand get current => RawPathCommandWasm._(
        _verb,
        _native.points.elementAt(_ptIndex + _ptsBacksetForVerb(_verb)),
      );

  @override
  bool moveNext() {
    if (++_verbIndex < _native.verbCount) {
      _ptIndex += _ptsAdvanceAfterVerb(_verb);
      _verb = _verbFromNative(_native.verbs.elementAt(_verbIndex).value);
      return true;
    }
    return false;
  }
}

class RawPathFFI extends RawPath {
  final GlyphPathStruct _native;
  RawPathFFI._(this._native);

  @override
  Iterator<RawPathCommand> get iterator => RawPathIterator._(_native);

  @override
  void dispose() => deleteRawPath(_native.rawPath);
}

/// A Font created and owned by Dart code. User is expected to call
/// dispose to release the font when they are done with it.
class StrongFontFFI extends FontFFI {
  StrongFontFFI(Pointer<Void> ptr) : super(ptr);

  @override
  void dispose() => deleteFont(fontPtr);
}

/// A Font reference that should not be explicitly disposed by the user.
/// Returned while shaping.
class FontFFI extends Font {
  Pointer<Void> fontPtr;

  FontFFI(this.fontPtr);

  @override
  RawPath getPath(int glyphId) {
    var glyphPath = makeGlyphPath(fontPtr, glyphId);
    return RawPathFFI._(glyphPath);
  }

  @override
  void dispose() {}

  @override
  TextShapeResult shape(String text, List<TextRun> runs) {
    var textUni = text.codeUnits;

    // Allocate and copy to runs memory.
    var runsMemory =
        calloc.allocate<TextRunNative>(runs.length * sizeOf<TextRunNative>());
    int runIndex = 0;
    for (final run in runs) {
      runsMemory[runIndex++]
        ..font = (run.font as FontFFI).fontPtr
        ..size = run.fontSize
        ..unicharCount = run.unicharCount
        ..styleId = run.styleId;
    }

    // Allocate and copy to text buffer.
    var textBuffer = calloc.allocate<Uint32>(textUni.length * sizeOf<Uint32>());
    for (int i = 0; i < textUni.length; i++) {
      textBuffer[i] = textUni[i];
    }

    var shapeResult =
        shapeText(textBuffer, textUni.length, runsMemory, runs.length);

    // Free memory for structs passed into native that we no longer need.
    calloc.free(textBuffer);
    calloc.free(runsMemory);

    return TextShapeResultFFI(shapeResult);
  }
}

Font? decodeFont(Uint8List bytes) {
  // Copy them to the native heap.
  var pointer = calloc.allocate<Uint8>(bytes.length);
  for (int i = 0; i < bytes.length; i++) {
    pointer[i] = bytes[i];
  }

  // Pass the pointer in to a native method.
  var result = makeFont(pointer, bytes.length);
  calloc.free(pointer);

  // var text = "hi I'm some text";
  // var textUni = text.codeUnits;
  // // print("ALLOC SOME TEXTRUNS");

  // var runs =
  //     calloc.allocate<TextRunNative>(1 * sizeOf<TextRunNative>());
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

  return FontFFI(result);
}

Future<void> initFont() async {}
