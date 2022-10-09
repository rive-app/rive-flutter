#include "hb-ot.h"
#include "hb.h"
#include "rive/text/font_hb.hpp"

#include <emscripten.h>
#include <emscripten/bind.h>
#include <emscripten/val.h>
#include <stdint.h>
#include <stdio.h>

using namespace emscripten;

using WasmPtr = uint32_t;

WasmPtr makeFont(emscripten::val byteArray)
{
    std::vector<unsigned char> bytes;

    const auto l = byteArray["byteLength"].as<unsigned>();
    bytes.resize(l);

    emscripten::val memoryView{emscripten::typed_memory_view(l, bytes.data())};
    memoryView.call<void>("set", byteArray);
    auto result = HBFont::Decode(bytes);
    if (result)
    {
        return (WasmPtr)result.release();
    }
    return (WasmPtr) nullptr;
}

void deleteFont(WasmPtr font) { reinterpret_cast<HBFont*>(font)->unref(); }

struct GlyphPath
{
    WasmPtr rawPath;
    WasmPtr points;
    WasmPtr verbs;
    uint16_t verbCount;
};

GlyphPath makeGlyphPath(WasmPtr fontPtr, rive::GlyphID id)
{
    auto font = reinterpret_cast<HBFont*>(fontPtr);
    rive::RawPath* path = new rive::RawPath(font->getPath(id));

    return {
        .rawPath = (WasmPtr)path,
        .points = (WasmPtr)path->points().data(),
        .verbs = (WasmPtr)path->verbs().data(),
        .verbCount = (uint16_t)path->verbs().size(),
    };
}

void deleteGlyphPath(WasmPtr rawPath) { delete reinterpret_cast<rive::RawPath*>(rawPath); }

void deleteShapeResult(WasmPtr shaperResult)
{
    delete reinterpret_cast<rive::SimpleArray<rive::Paragraph>*>(shaperResult);
}

WasmPtr breakLines(WasmPtr paragraphsPtr, float width, uint8_t align)
{
    bool autoWidth = width == -1.0f;
    auto paragraphs = reinterpret_cast<rive::SimpleArray<rive::Paragraph>*>(paragraphsPtr);
    float paragraphWidth = width;

    rive::SimpleArray<rive::SimpleArray<rive::GlyphLine>>* lines =
        new rive::SimpleArray<rive::SimpleArray<rive::GlyphLine>>(paragraphs->size());
    rive::SimpleArray<rive::SimpleArray<rive::GlyphLine>>& linesRef = *lines;
    size_t paragraphIndex = 0;
    for (auto& para : *paragraphs)
    {
        linesRef[paragraphIndex] =
            rive::GlyphLine::BreakLines(para.runs, autoWidth ? -1.0f : width);
        if (autoWidth)
        {
            paragraphWidth =
                std::max(paragraphWidth,
                         rive::GlyphLine::ComputeMaxWidth(linesRef[paragraphIndex], para.runs));
        }
        paragraphIndex++;
    }
    paragraphIndex = 0;
    for (auto& para : *paragraphs)
    {
        rive::GlyphLine::ComputeLineSpacing(linesRef[paragraphIndex++],
                                            para.runs,
                                            paragraphWidth,
                                            (rive::TextAlign)align);
    }
    return (WasmPtr)lines;
}

void deleteLines(WasmPtr lines)
{
    delete reinterpret_cast<rive::SimpleArray<rive::SimpleArray<rive::GlyphLine>>*>(lines);
}

WasmPtr shapeText(emscripten::val codeUnits, emscripten::val runsList)
{
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

    auto runCount = runsBytes.size() / sizeof(rive::TextRun);
    rive::TextRun* runs = reinterpret_cast<rive::TextRun*>(runsBytes.data());

    if (runCount > 0)
    {
        auto result = (WasmPtr) new rive::SimpleArray<rive::Paragraph>(
            runs[0].font->shapeText(codeUnitArray, rive::Span(runs, runCount)));

        return result;
    }
    return {};
}

#ifdef DEBUG
#define OFFSET_OF(type, member) ((int)(intptr_t) & (((type*)(void*)0)->member))
void assertSomeAssumptions()
{
    // These assumptions are important as our rive_text_wasm.dart integration
    // relies on knowing the exact offsets of these struct elements. When and if
    // we ever move to the proposed Wasm64 (currently not a standard), we'll
    // need to make adjustements here.
    assert(sizeof(rive::TextRun) == 20);
    assert(OFFSET_OF(rive::TextRun, font) == 0);
    assert(OFFSET_OF(rive::TextRun, size) == 4);
    assert(OFFSET_OF(rive::TextRun, unicharCount) == 8);
    assert(OFFSET_OF(rive::TextRun, script) == 12);
    assert(OFFSET_OF(rive::TextRun, styleId) == 16);
    assert(OFFSET_OF(rive::TextRun, dir) == 18);

    assert(sizeof(rive::Paragraph) == 12);
    assert(OFFSET_OF(rive::Paragraph, runs) == 0);
    assert(OFFSET_OF(rive::Paragraph, baseDirection) == 8);

    assert(sizeof(rive::GlyphRun) == 52);
    assert(OFFSET_OF(rive::GlyphRun, font) == 0);
    assert(OFFSET_OF(rive::GlyphRun, size) == 4);
    assert(OFFSET_OF(rive::GlyphRun, glyphs) == 8);
    assert(OFFSET_OF(rive::GlyphRun, textIndices) == 16);
    assert(OFFSET_OF(rive::GlyphRun, advances) == 24);
    assert(OFFSET_OF(rive::GlyphRun, xpos) == 32);
    assert(OFFSET_OF(rive::GlyphRun, breaks) == 40);
    assert(OFFSET_OF(rive::GlyphRun, styleId) == 48);
    assert(OFFSET_OF(rive::GlyphRun, dir) == 50);

    assert(sizeof(rive::GlyphLine) == 32);
}
#endif

EMSCRIPTEN_BINDINGS(RiveText)
{
    function("makeFont", &makeFont, allow_raw_pointers());
    function("deleteFont", &deleteFont);

    value_array<GlyphPath>("GlyphPath")
        .element(&GlyphPath::rawPath)
        .element(&GlyphPath::points)
        .element(&GlyphPath::verbs)
        .element(&GlyphPath::verbCount);

    function("makeGlyphPath", &makeGlyphPath);
    function("deleteGlyphPath", &deleteGlyphPath);

    function("shapeText", &shapeText);
    function("deleteShapeResult", &deleteShapeResult);

    function("breakLines", &breakLines);
    function("deleteLines", &deleteLines);

#ifdef DEBUG
    function("assertSomeAssumptions", &assertSomeAssumptions);
#endif
}