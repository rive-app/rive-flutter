RiveText["onRuntimeInitialized"] = function () {
  var HEAPU8 = RiveText["HEAPU8"];
  var HEAPU32 = RiveText["HEAPU32"];
  var HEAPF32 = RiveText["HEAPF32"];
  var nativeMakeGlyphPath = RiveText["makeGlyphPath"];
  var move = 0;
  var line = 1;
  var quad = 2;
  var cubic = 4;
  var close = 5;
  RiveText["makeGlyphPath"] = function (font, glyphId) {
    var glyph = nativeMakeGlyphPath(font, glyphId);
    var verbCount = glyph[3];
    var ptsPtr = glyph[1];
    var verbPtr = glyph[2];
    var verbs = HEAPU8["subarray"](verbPtr, verbPtr + verbCount);

    let pointCount = 0;
    for (var verb of verbs) {
      switch (verb) {
        case move:
        case line:
          pointCount++;
          break;
        case quad:
          pointCount += 2;
          break;
        case cubic:
          pointCount += 3;
          break;
        default:
          break;
      }
    }

    const ptsStart = ptsPtr / 4;
    return {
      "rawPath": glyph[0],
      "verbs": verbs,
      "points": HEAPF32["subarray"](ptsStart, ptsStart + pointCount * 2),
    };
  };

  var nativeShapeText = RiveText["shapeText"];
  RiveText["shapeText"] = function (codeUnits, runsList) {
    var shapeResult = nativeShapeText(codeUnits, runsList);
    return {
      "rawResult": shapeResult,
      "results": HEAPU8["subarray"](shapeResult),
    };
  };

  var nativeBreakLines = RiveText["breakLines"];
  RiveText["breakLines"] = function (shape, width, align) {
    var breakResult = nativeBreakLines(shape, width, align);
    return {
      "rawResult": breakResult,
      "results": HEAPU8["subarray"](breakResult),
    };
  };
};
