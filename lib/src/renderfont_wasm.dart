// ignore: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:typed_data';

import 'package:rive/src/renderfont.dart';

late js.JsFunction _makeRenderFont;
late js.JsFunction _deleteRenderFont;
late js.JsFunction _makeGlyphPath;
late js.JsFunction _deleteGlyphPath;

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

class RenderFontWasm extends RenderFont {
  final int renderFontPtr;
  RenderFontWasm(this.renderFontPtr);

  @override
  @override
  void dispose() => _deleteRenderFont.apply(<dynamic>[renderFontPtr]);

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
}

RenderFont? decodeRenderFont(Uint8List bytes) {
  int ptr = _makeRenderFont.apply(<dynamic>[bytes]) as int;
  if (ptr == 0) {
    return null;
  }
  return RenderFontWasm(ptr);
}

Future<void> initRenderFont() async {
  var script = html.ScriptElement()
    ..src =
        'assets/packages/dartbuzz/wasm/build/bin/release/render_font.js' // ignore: unsafe_html
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
        completer.complete();
      }
    ],
    thisArg: promise,
  );
  return completer.future;
}
