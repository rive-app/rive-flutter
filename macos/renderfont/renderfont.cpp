#include <stdint.h>
#include <stdio.h>

#include "hb-ot.h"
#include "hb.h"
#include "renderfont_hb.hpp"

#define EXPORT extern "C" __attribute__((visibility("default"))) __attribute__((used))

EXPORT
rive::RenderFont* makeRenderFont(const uint8_t* bytes, int64_t length) {
    auto result = HBRenderFont::Decode(rive::Span<const uint8_t>(bytes, length));
    if (result) {
        return result.release();
    }
    return nullptr;
}

EXPORT void deleteRenderFont(rive::RenderFont* renderFont) { delete renderFont; }

struct GlyphPath {
    rive::RawPath* rawPath;
    rive::Vec2D* points;
    rive::PathVerb* verbs;
    uint16_t verbCount;
};

EXPORT
GlyphPath makeGlyphPath(rive::RenderFont* renderFont, rive::GlyphID id) {
    rive::RawPath* path = new rive::RawPath(renderFont->getPath(id));

    return {
        .rawPath = path,
        .points = path->points().data(),
        .verbs = path->verbs().data(),
        .verbCount = (uint16_t)path->verbs().size(),
    };
}

EXPORT void deleteRawPath(rive::RawPath* rawPath) { delete rawPath; }