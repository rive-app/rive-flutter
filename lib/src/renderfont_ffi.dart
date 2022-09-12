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

final Pointer<Void> Function(Pointer<Uint8> x, int y) makeRenderFont = nativeLib
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

class RenderFontFFI extends RenderFont {
  Pointer<Void> renderFontPtr;

  RenderFontFFI(this.renderFontPtr);

  @override
  RawPath getPath(int glyphId) {
    var glyphPath = makeGlyphPath(renderFontPtr, glyphId);
    return RawPathFFI._(glyphPath);
  }

  @override
  void dispose() => deleteRenderFont(renderFontPtr);
}

RenderFont? decodeRenderFont(Uint8List bytes) {
  // Copy them to the native heap.
  var pointer = calloc.allocate<Uint8>(bytes.length);
  for (int i = 0; i < bytes.length; i++) {
    pointer[i] = bytes[i];
  }
  // Pass the pointer in to a native method.
  var result = makeRenderFont(pointer, bytes.length);
  return RenderFontFFI(result);
}

Future<void> initRenderFont() async {}
