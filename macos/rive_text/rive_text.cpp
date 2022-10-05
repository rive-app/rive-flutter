#include <stdint.h>
#include <stdio.h>

#include "rive/text/font_hb.hpp"
// #include "rive/text/line_breaker.hpp"

// #define EXPORT extern "C" __attribute__((visibility("default"))) __attribute__((used))

// EXPORT
// rive::RenderFont* makeRenderFont(const uint8_t* bytes, uint64_t length) {
//     auto result = HBRenderFont::Decode(rive::Span<const uint8_t>(bytes, length));
//     if (result) {
//         auto ptr = result.release();
//         return ptr;
//     }
//     return nullptr;
// }

// EXPORT void deleteRenderFont(rive::RenderFont* renderFont) { delete renderFont; }

// struct GlyphPath {
//     rive::RawPath* rawPath;
//     rive::Vec2D* points;
//     rive::PathVerb* verbs;
//     uint16_t verbCount;
// };

// EXPORT
// GlyphPath makeGlyphPath(rive::RenderFont* renderFont, rive::GlyphID id) {
//     rive::RawPath* path = new rive::RawPath(renderFont->getPath(id));

//     return {
//         .rawPath = path,
//         .points = path->points().data(),
//         .verbs = path->verbs().data(),
//         .verbCount = (uint16_t)path->verbs().size(),
//     };
// }

// EXPORT void deleteRawPath(rive::RawPath* rawPath) { delete rawPath; }

// EXPORT
// rive::SimpleArray<rive::RenderGlyphRun>*
// shapeText(const uint32_t* text, uint64_t length, rive::RenderTextRun* runs, uint64_t runsLength)
// {
//     if (runsLength == 0 || length == 0) {
//         return nullptr;
//     }
//     return new rive::SimpleArray<rive::RenderGlyphRun>(
//         runs[0].font->shapeText(rive::Span(text, length), rive::Span(runs, runsLength)));
// }

// EXPORT void deleteShapeResult(rive::SimpleArray<rive::RenderGlyphRun>* shapeResult) {
//     delete shapeResult;
// }

// struct LinesResult {
//     std::vector<rive::RenderGlyphLine>* result;
//     rive::RenderGlyphLine* lines;
//     uint32_t lineCount;
// };

// EXPORT LinesResult breakLines(rive::SimpleArray<rive::RenderGlyphRun>* runs,
//                               float width,
//                               uint8_t align) {
//     auto result = new std::vector<rive::RenderGlyphLine>(
//         rive::RenderGlyphLine::BreakLines(*runs, width, (rive::RenderTextAlign)align));
//     return {result, result->data(), (uint32_t)result->size()};
// }

// EXPORT void deleteBreakLinesResult(std::vector<rive::RenderGlyphLine>* result) { delete result; }