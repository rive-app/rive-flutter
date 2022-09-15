// ignore: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:typed_data';

import 'package:rive/src/renderfont.dart';
import 'package:rive/src/utilities/binary_buffer/binary_reader.dart';
import 'package:rive/src/utilities/binary_buffer/binary_writer.dart';

late js.JsFunction _makeRenderFont;
late js.JsFunction _deleteRenderFont;
late js.JsFunction _makeGlyphPath;
late js.JsFunction _deleteGlyphPath;
late js.JsFunction _shapeText;

class RawPathWasm extends RawPath {
  final int rawPathPtr;
  final Uint8List verbs;
  final Float32List points;

  RawPathWasm({
    required this.rawPathPtr,
    required this.verbs,
    required this.points,
  });

  @override
  void dispose() => _deleteGlyphPath.apply(<dynamic>[rawPathPtr]);

  @override
  Iterator<RawPathCommand> get iterator => RawPathIterator._(verbs, points);
}

class RawPathCommandWasm extends RawPathCommand {
  final Float32List _points;
  final int _pointsOffset;

  RawPathCommandWasm._(
    RawPathVerb verb,
    this._points,
    this._pointsOffset,
  ) : super(verb);

  @override
  Vec2D point(int index) {
    var base = _pointsOffset + index * 2;
    return Vec2D(_points[base], _points[base + 1]);
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
  final Uint8List verbs;
  final Float32List points;
  int _verbIndex = -1;
  int _ptIndex = -1;

  RawPathVerb _verb = RawPathVerb.move;

  RawPathIterator._(this.verbs, this.points);

  @override
  RawPathCommand get current => RawPathCommandWasm._(
        _verb,
        points,
        (_ptIndex + _ptsBacksetForVerb(_verb)) * 2,
      );

  @override
  bool moveNext() {
    if (++_verbIndex < verbs.length) {
      _ptIndex += _ptsAdvanceAfterVerb(_verb);
      _verb = _verbFromNative(verbs[_verbIndex]);
      return true;
    }
    return false;
  }
}

class TextShapeResultWasm extends TextShapeResult {
  final List<RenderGlyphRun> runs;

  TextShapeResultWasm(this.runs);
  @override
  void dispose() {}

  @override
  RenderGlyphRun runAt(int index) => runs[index];

  @override
  int get runCount => runs.length;
}

extension ByteDataWasm on ByteData {
  WasmDynamicArray readDynamicArray(int offset) {
    return WasmDynamicArray(
      ByteData.view(buffer, getUint32(offset, Endian.little)),
      getUint32(
        offset + 4,
        Endian.little,
      ),
    );
  }
}

class WasmDynamicArray {
  final ByteData data;
  final int size;
  WasmDynamicArray(this.data, this.size);

  // int get size => data.getUint32(4);
}

class RenderGlyphRunWasm extends RenderGlyphRun {
  final ByteData byteData;
  final WasmDynamicArray glyphs;
  final WasmDynamicArray textOffsets;
  final WasmDynamicArray xPositions;

  RenderGlyphRunWasm(this.byteData)
      : glyphs = byteData.readDynamicArray(8),
        textOffsets = byteData.readDynamicArray(16),
        xPositions = byteData.readDynamicArray(24);

  @override
  double get fontSize => byteData.getFloat32(4, Endian.little);

  @override
  int get glyphCount => glyphs.size;

  @override
  int glyphIdAt(int index) => glyphs.data.getUint16(index * 2, Endian.little);

  @override
  RenderFont get renderFont =>
      RenderFontWasm(byteData.getUint32(0, Endian.little));

  @override
  int textOffsetAt(int index) =>
      textOffsets.data.getUint32(index * 4, Endian.little);

  @override
  double xAt(int index) => xPositions.data.getFloat32(index * 4, Endian.little);
}

/// A RenderFont reference that should not be explicitly disposed by the user.
/// Returned while shaping.
class RenderFontWasm extends RenderFont {
  final int renderFontPtr;
  RenderFontWasm(this.renderFontPtr);

  @override
  void dispose() {}

  @override
  RawPath getPath(int glyphId) {
    var object =
        _makeGlyphPath.apply(<dynamic>[renderFontPtr, glyphId]) as js.JsObject;
    var rawPathPtr = object['rawPath'] as int;
    var verbs = object['verbs'] as Uint8List;
    var points = object['points'] as Float32List;
    return RawPathWasm(
      rawPathPtr: rawPathPtr,
      verbs: verbs,
      points: points,
    );
  }

  static const int sizeOfNativeRenderTextRun = 4 + 4 + 4;

  @override
  TextShapeResult shape(String text, List<RenderTextRun> runs) {
    var writer = BinaryWriter(
      alignment: runs.length * sizeOfNativeRenderTextRun,
    );
    for (final run in runs) {
      writer.writeUint32((run.font as RenderFontWasm).renderFontPtr);
      writer.writeFloat32(run.fontSize);
      writer.writeUint32(run.unicharCount);
    }
    print(
        "SIZE OF UNITS: ${Uint32List.fromList(text.codeUnits).length} ${text.codeUnits.length}");

    var result = _shapeText.apply(
      <dynamic>[
        Uint32List.fromList(text.codeUnits),
        writer.uint8Buffer,
      ],
    ) as Uint8List;

    var reader = BinaryReader.fromList(result);
    var dataPointer = reader.readUint32();
    var dataSize = reader.readUint32();
    print("RUN COUNTe ${dataSize}");
    var runList = <RenderGlyphRunWasm>[];
    for (int i = 0; i < dataSize; i++) {
      // var data = ByteData.view(result.buffer, dataPointer);
      // var fontSizeOfRun = data.getFloat32(4, Endian.little);
      // print("RFS $fontSizeOfRun");
      runList
          .add(RenderGlyphRunWasm(ByteData.view(result.buffer, dataPointer)));
      // print("FONT SIZE: ${run.fontSize}");
      dataPointer += 4 + 4 + 8 + 8 + 8;
    }
    // var view = ByteData.view(
    //     result.buffer, result.offsetInBytes, result.lengthInBytes);
    // // size_t is 32 bit (4 bytes) in wasm
    // var resultRunCount = view.getUint32(4, Endian.little);
    // var resultRunCount = view.getUint32(4, Endian.little);
    // for (int i = 0; i < resultRunCount; i++) {}

    return TextShapeResultWasm(runList);
  }
}

/// A RenderFont created and owned by Dart code. User is expected to call
/// dispose to release the font when they are done with it.
class StrongRenderFontWasm extends RenderFontWasm {
  StrongRenderFontWasm(int renderFontPtr) : super(renderFontPtr);

  @override
  void dispose() => _deleteRenderFont.apply(<dynamic>[renderFontPtr]);
}

RenderFont? decodeRenderFont(Uint8List bytes) {
  int ptr = _makeRenderFont.apply(<dynamic>[bytes]) as int;
  if (ptr == 0) {
    return null;
  }
  return StrongRenderFontWasm(ptr);
}

Future<void> initRenderFont() async {
  var script = html.ScriptElement()
    ..src =
        'assets/packages/rive/wasm/build/bin/release/render_font.js' // ignore: unsafe_html
    ..type = 'application/javascript'
    ..defer = true;

  html.document.body!.append(script);
  await script.onLoad.first;

  var init = js.context['RenderFont'] as js.JsFunction;
  var promise = init.apply(<dynamic>[]) as js.JsObject;
  var thenFunction = promise['then'] as js.JsFunction;
  var completer = Completer<void>();
  thenFunction.apply(
    <dynamic>[
      (js.JsObject module) {
        _makeRenderFont = module['makeRenderFont'] as js.JsFunction;
        _deleteRenderFont = module['deleteRenderFont'] as js.JsFunction;
        _makeGlyphPath = module['makeGlyphPath'] as js.JsFunction;
        _deleteGlyphPath = module['deleteGlyphPath'] as js.JsFunction;
        _shapeText = module['shapeText'] as js.JsFunction;
        completer.complete();
      }
    ],
    thisArg: promise,
  );
  return completer.future;
}
