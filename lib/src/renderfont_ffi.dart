import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:rive/src/renderfont.dart';

final DynamicLibrary nativeLib = Platform.isAndroid
    ? DynamicLibrary.open('librenderfont.so')
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

class DynamicUint16Array extends Struct {
  external Pointer<Uint16> data;
  @Uint64()
  external int size;
}

class DynamicUint32Array extends Struct {
  external Pointer<Uint32> data;
  @Uint64()
  external int size;
}

class DynamicFloatArray extends Struct {
  external Pointer<Float> data;
  @Uint64()
  external int size;
}

class RenderTextRunNative extends Struct {
  external Pointer<Void> font;
  @Float()
  external double size;
  @Uint32()
  external int unicharCount;
}

class RenderGlyphRunNative extends Struct implements RenderGlyphRun {
  external Pointer<Void> font;
  @Float()
  external double size;

  external DynamicUint16Array glyphs;
  external DynamicUint32Array textOffsets;
  external DynamicFloatArray xpos;

  @override
  double get fontSize => size;

  @override
  int get glyphCount => glyphs.size;

  @override
  int glyphIdAt(int index) => glyphs.data.elementAt(index).value;

  @override
  RenderFont get renderFont => RenderFontFFI(font);

  @override
  int textOffsetAt(int index) => textOffsets.data.elementAt(index).value;

  @override
  double xAt(int index) => xpos.data.elementAt(index).value;
}

class DynamicRenderTextRunArray extends Struct {
  external Pointer<RenderGlyphRunNative> data;
  @Uint64()
  external int size;
}

class TextShapeResultFFI extends TextShapeResult {
  final Pointer<DynamicRenderTextRunArray> nativeResult;
  TextShapeResultFFI(this.nativeResult);

  @override
  void dispose() => deleteShapeResult(nativeResult);

  @override
  RenderGlyphRun runAt(int index) => nativeResult.ref.data.elementAt(index).ref;

  @override
  int get runCount => nativeResult.ref.size;
}

final Pointer<DynamicRenderTextRunArray> Function(Pointer<Uint32> text,
        int textLength, Pointer<RenderTextRunNative> runs, int runsLength)
    shapeText = nativeLib
        .lookup<
            NativeFunction<
                Pointer<DynamicRenderTextRunArray> Function(Pointer<Uint32>,
                    Uint64, Pointer<RenderTextRunNative>, Uint64)>>('shapeText')
        .asFunction();

final void Function(
    Pointer<DynamicRenderTextRunArray>
        renderFont) deleteShapeResult = nativeLib
    .lookup<NativeFunction<Void Function(Pointer<DynamicRenderTextRunArray>)>>(
        'deleteShapeResult')
    .asFunction();

final Pointer<Void> Function(Pointer<Uint8> bytes, int count) makeRenderFont =
    nativeLib
        .lookup<NativeFunction<Pointer<Void> Function(Pointer<Uint8>, Uint64)>>(
            'makeRenderFont')
        .asFunction();

final void Function(Pointer<Void> renderFont) deleteRenderFont = nativeLib
    .lookup<NativeFunction<Void Function(Pointer<Void>)>>('deleteRenderFont')
    .asFunction();

final GlyphPathStruct Function(
    Pointer<Void> renderFont,
    int
        glyphId) makeGlyphPath = nativeLib
    .lookup<NativeFunction<GlyphPathStruct Function(Pointer<Void>, Uint16)>>(
        'makeGlyphPath')
    .asFunction();

final void Function(Pointer<Void> renderFont) deleteRawPath = nativeLib
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
    return Vec2D(ref.x, ref.y);
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

/// A RenderFont created and owned by Dart code. User is expected to call
/// dispose to release the font when they are done with it.
class StrongRenderFontFFI extends RenderFontFFI {
  StrongRenderFontFFI(Pointer<Void> ptr) : super(ptr);

  @override
  void dispose() => deleteRenderFont(renderFontPtr);
}

/// A RenderFont reference that should not be explicitly disposed by the user.
/// Returned while shaping.
class RenderFontFFI extends RenderFont {
  Pointer<Void> renderFontPtr;

  RenderFontFFI(this.renderFontPtr);

  @override
  RawPath getPath(int glyphId) {
    var glyphPath = makeGlyphPath(renderFontPtr, glyphId);
    return RawPathFFI._(glyphPath);
  }

  @override
  void dispose() {}

  @override
  TextShapeResult shape(String text, List<RenderTextRun> runs) {
    var textUni = text.codeUnits;

    // Allocate and copy to runs memory.
    var runsMemory = calloc.allocate<RenderTextRunNative>(
        runs.length * sizeOf<RenderTextRunNative>());
    int runIndex = 0;
    for (final run in runs) {
      runsMemory[runIndex++]
        ..font = (run.font as RenderFontFFI).renderFontPtr
        ..size = run.fontSize
        ..unicharCount = run.unicharCount;
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

RenderFont? decodeRenderFont(Uint8List bytes) {
  // Copy them to the native heap.
  var pointer = calloc.allocate<Uint8>(bytes.length);
  for (int i = 0; i < bytes.length; i++) {
    pointer[i] = bytes[i];
  }

  // Pass the pointer in to a native method.
  var result = makeRenderFont(pointer, bytes.length);
  calloc.free(pointer);

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

  return RenderFontFFI(result);
}

Future<void> initRenderFont() async {}
