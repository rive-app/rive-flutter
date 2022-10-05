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

    auto runCount = runsBytes.size() / (4 + 4 + 4 + 4);
    rive::TextRun* runs = reinterpret_cast<rive::TextRun*>(runsBytes.data());

    if (runCount > 0)
    {
        return (WasmPtr) new rive::SimpleArray<rive::Paragraph>(
            runs[0].font->shapeText(codeUnitArray, rive::Span(runs, runCount)));
    }
    return {};
}

void breakLines(WasmPtr paragraphsPtr, float width, uint8_t align)
{
    bool autoWidth = width == -1.0f;
    auto paragraphs = reinterpret_cast<rive::SimpleArray<rive::Paragraph>*>(paragraphsPtr);
    float paragraphWidth = width;
    for (auto& para : *paragraphs)
    {
        para.lines = rive::GlyphLine::BreakLines(para.runs, autoWidth ? -1.0f : width);
        if (autoWidth)
        {
            paragraphWidth =
                std::max(paragraphWidth, rive::GlyphLine::ComputeMaxWidth(para.lines, para.runs));
        }
    }
    for (auto& para : *paragraphs)
    {
        rive::GlyphLine::ComputeLineSpacing(para.lines,
                                            para.runs,
                                            paragraphWidth,
                                            (rive::TextAlign)align);
    }
    // auto result = new std::vector<rive::GlyphLine>(
    //     rive::GlyphLine::BreakLines(*runs, width, (rive::TextAlign)align));
    // return {(WasmPtr)result, (WasmPtr)result->data(), (uint32_t)result->size()};
}

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
}