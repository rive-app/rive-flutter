#include "hb-ot.h"
#include "hb.h"
#include "rive/text/renderfont_hb.hpp"

#include <emscripten.h>
#include <emscripten/bind.h>
#include <emscripten/val.h>
#include <stdint.h>
#include <stdio.h>

using namespace emscripten;

using WasmPtr = uint32_t;

WasmPtr makeRenderFont(emscripten::val byteArray) {
    std::vector<unsigned char> bytes;

    const auto l = byteArray["byteLength"].as<unsigned>();
    bytes.resize(l);

    emscripten::val memoryView{emscripten::typed_memory_view(l, bytes.data())};
    memoryView.call<void>("set", byteArray);
    auto result = HBRenderFont::Decode(bytes);
    if (result) {
        return (WasmPtr)result.release();
    }
    return (WasmPtr) nullptr;
}

void deleteRenderFont(WasmPtr renderFont) { delete reinterpret_cast<HBRenderFont*>(renderFont); }

struct GlyphPath {
    WasmPtr rawPath;
    WasmPtr points;
    WasmPtr verbs;
    uint16_t verbCount;
};

GlyphPath makeGlyphPath(WasmPtr renderFontPtr, rive::GlyphID id) {
    auto renderFont = reinterpret_cast<HBRenderFont*>(renderFontPtr);
    rive::RawPath* path = new rive::RawPath(renderFont->getPath(id));

    return {
        .rawPath = (WasmPtr)path,
        .points = (WasmPtr)path->points().data(),
        .verbs = (WasmPtr)path->verbs().data(),
        .verbCount = (uint16_t)path->verbs().size(),
    };
}

void deleteGlyphPath(WasmPtr rawPath) { delete reinterpret_cast<rive::RawPath*>(rawPath); }

WasmPtr shapeText(emscripten::val codeUnits, emscripten::val runsList) {
    std::vector<uint8_t> runsBytes(runsList["byteLength"].as<unsigned>());
    {
        emscripten::val memoryView{
            emscripten::typed_memory_view(runsBytes.size(), runsBytes.data())};
        memoryView.call<void>("set", runsList);
    }
    std::vector<uint32_t> codeUnitArray(codeUnits["length"].as<unsigned>());
    {
        emscripten::val memoryView{
            emscripten::typed_memory_view(codeUnitArray.size(), codeUnitArray.data())};
        memoryView.call<void>("set", codeUnits);
    }

    auto runCount = runsBytes.size() / (4 + 4 + 4);
    rive::RenderTextRun* runs = reinterpret_cast<rive::RenderTextRun*>(runsBytes.data());

    if (runCount > 0) {
        return (WasmPtr) new rive::SimpleArray<rive::RenderGlyphRun>(
            runs[0].font->shapeText(codeUnitArray, rive::Span(runs, runCount)));
    }
    return (WasmPtr) nullptr;
}

EMSCRIPTEN_BINDINGS(RenderFont) {
    function("makeRenderFont", &makeRenderFont, allow_raw_pointers());
    function("deleteRenderFont", &deleteRenderFont);

    value_array<GlyphPath>("GlyphPath")
        .element(&GlyphPath::rawPath)
        .element(&GlyphPath::points)
        .element(&GlyphPath::verbs)
        .element(&GlyphPath::verbCount);

    function("makeGlyphPath", &makeGlyphPath);
    function("deleteGlyphPath", &deleteGlyphPath);

    function("shapeText", &shapeText);
}