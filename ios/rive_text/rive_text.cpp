#include <stdint.h>
#include <stdio.h>

#include "rive/text/font_hb.hpp"

#if defined(_MSC_VER)
#define EXPORT extern "C" __declspec(dllexport)
#else
#define EXPORT extern "C" __attribute__((visibility("default"))) __attribute__((used))
#endif

EXPORT
rive::Font* makeFont(const uint8_t* bytes, uint64_t length)
{
    auto result = HBFont::Decode(rive::Span<const uint8_t>(bytes, length));
    if (result)
    {
        auto ptr = result.release();
        return ptr;
    }
    return nullptr;
}

EXPORT void deleteFont(rive::Font* font) { delete font; }

struct GlyphPath
{
    rive::RawPath* rawPath;
    rive::Vec2D* points;
    rive::PathVerb* verbs;
    uint16_t verbCount;
};

EXPORT
GlyphPath makeGlyphPath(rive::Font* font, rive::GlyphID id)
{
    rive::RawPath* path = new rive::RawPath(font->getPath(id));

    return {
        .rawPath = path,
        .points = path->points().data(),
        .verbs = path->verbs().data(),
        .verbCount = (uint16_t)path->verbs().size(),
    };
}

EXPORT void deleteGlyphPath(rive::RawPath* rawPath) { delete rawPath; }

EXPORT
rive::SimpleArray<rive::Paragraph>*
shapeText(const uint32_t* text, uint64_t length, rive::TextRun* runs, uint64_t runsLength)
{
    if (runsLength == 0 || length == 0)
    {
        return nullptr;
    }
    return new rive::SimpleArray<rive::Paragraph>(
        runs[0].font->shapeText(rive::Span(text, length), rive::Span(runs, runsLength)));
}

EXPORT void deleteShapeResult(rive::SimpleArray<rive::Paragraph>* shapeResult)
{
    delete shapeResult;
}

EXPORT rive::SimpleArray<rive::SimpleArray<rive::GlyphLine>>*
breakLines(rive::SimpleArray<rive::Paragraph>* paragraphs, float width, uint8_t align)
{
    bool autoWidth = width == -1.0f;
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
    return lines;
}

EXPORT void deleteLines(rive::SimpleArray<rive::SimpleArray<rive::GlyphLine>>* result)
{
    delete result;
}

std::vector<rive::Font*> fallbackFonts;

EXPORT
void setFallbackFonts(rive::Font** fonts, uint64_t fontsLength)
{
    if (fontsLength == 0)
    {
        fallbackFonts = std::vector<rive::Font*>();
        return;
    }
    fallbackFonts = std::vector<rive::Font*>(fonts, fonts + fontsLength);
}

static rive::rcp<rive::Font> pickFallbackFont(rive::Span<const rive::Unichar> missing)
{
    size_t length = fallbackFonts.size();
    for (size_t i = 0; i < length; i++)
    {
        HBFont* font = static_cast<HBFont*>(fallbackFonts[i]);
        if (i == length - 1 || font->hasGlyph(missing))
        {
            rive::rcp<rive::Font> rcFont = rive::rcp<rive::Font>(font);
            // because the font was released at load time, we need to give it an
            // extra ref whenever we bump it to a reference counted pointer.
            rcFont->ref();
            return rcFont;
        }
    }
    return nullptr;
}
EXPORT
void init()
{
    fallbackFonts.clear();
    HBFont::gFallbackProc = pickFallbackFont;
}