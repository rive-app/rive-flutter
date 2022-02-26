import 'dart:typed_data';

import 'rive_font.dart';

abstract class TextRun {
  RiveFont get font;
  double get pointSize;
  int get textLength;
  set textLength(int value);

  TextRun cloneRun();
}

class GlyphRun {
  TextRun textRun; // the run this glyph run was generated from
  RiveFont font; // possibly different from TextRun (substitution)
  double pointSize; // possibly different from TextRun

  int textOffset;
  Uint16List glyphs;
  Float32List xpos; // #glyphs + 1

  GlyphRun(
    this.textRun,
    this.font,
    this.pointSize,
    this.textOffset,
    this.glyphs,
    this.xpos,
  ) {
    assert(glyphs.length + 1 == xpos.length);
  }

  double get left {
    return xpos.first;
  }

  double get right {
    return xpos.last;
  }

  double get width {
    return right - left;
  }

  int get textStart {
    return textOffset;
  }

  int get textEnd {
    return textOffset + glyphs.length;
  }

  static bool ws(int code) {
    return code <= 32;
  }

  static List<GlyphRun> shapeText(List<int> chars, List<TextRun> textRuns) {
    final glyphRuns = <GlyphRun>[];
    int offset = 0;
    double x = 0;

    for (final TextRun run in textRuns) {
      if (run.textLength > 0) {
        final glyphs =
            run.font.textToGlyphs(chars, offset, offset + run.textLength);
        final advances = run.font.getAdvances(glyphs);
        final int n = glyphs.length;
        final xpos = Float32List(n + 1);
        for (int i = 0; i < n; ++i) {
          xpos[i] = x;
          x += advances[i] * run.pointSize;
        }
        xpos[n] = x;
        glyphRuns
            .add(GlyphRun(run, run.font, run.pointSize, offset, glyphs, xpos));
        offset += run.textLength;
      }
    }
    return glyphRuns;
  }

  static List<int> findWordBreaks(List<int> chars) {
    List<int> breaks = [];
    for (int i = 0; i < chars.length;) {
      // skip ws
      while (i < chars.length && ws(chars[i])) {
        ++i;
      }
      breaks.add(i); // word start
      // skip non-ws
      while (i < chars.length && !ws(chars[i])) {
        ++i;
      }
      breaks.add(i); // word end
    }
    assert(breaks.last == chars.length);
    return breaks;
  }

  int offsetToIndex(int offset) {
    assert(textOffset <= offset);
    assert(offset - textOffset <= glyphs.length);
    return offset - textOffset;
  }
}

class GlyphLine {
  List<GlyphRun> runs;
  int startRun;
  int startIndex;
  int endRun;
  int endIndex;
  int wsRun;
  int wsIndex;
  double startX;
  double top = 0, baseline = 0, bottom = 0;

  void validate() {
    void val(int r, int i) {
      final run = runs[r];
      assert(i >= 0 && i <= run.glyphs.length);
    }

    val(startRun, startIndex);
    val(endRun, endIndex);
    val(wsRun, wsIndex);
    assert(startRun < endRun || (startRun == endRun && startIndex <= endIndex));
    assert(endRun < wsRun || (endRun == wsRun && endIndex <= wsIndex));
  }

  GlyphLine(this.runs, this.startRun, this.startIndex, this.endRun,
      this.endIndex, this.wsRun, this.wsIndex, this.startX);

  int get textStart {
    return runs[startRun].textStart + startIndex;
  }

  int get textEnd {
    return runs[wsRun].textStart + wsIndex;
  }

  double offsetToX(int textOffset) {
    assert(textOffset <= runs[endRun].textEnd);
    for (int i = startRun; i <= endRun; ++i) {
      final run = runs[i];
      if (textOffset <= run.textEnd) {
        return run.xpos[textOffset - run.textStart] - startX;
      }
    }
    assert(false);
    return 0;
  }

  static int _offsetToRunIndex(
      List<GlyphRun> runs, int offset, int charLength) {
    assert(offset >= 0);
    for (int i = 1; i < runs.length; ++i) {
      final run = runs[i];
      if (run.textOffset >= offset) {
        return i - 1;
      }
    }
    return runs.length - 1;
  }

  static List<GlyphLine> lineBreak(
      List<int> chars, List<int> breaks, List<GlyphRun> runs, double width) {
    List<GlyphLine> lines = [];
    int startRun = 0;
    int startIndex = 0;
    double xlimit = width;

    int prevRun = 0;
    int prevIndex = 0;

    int wordStart = breaks[0];
    int wordEnd = breaks[1];
    int nextBreakIndex = 2;
    int lineStartTextOffset = wordStart;

    for (;;) {
      assert(wordStart <= wordEnd); // == means trailing spaces?

      int endRun = _offsetToRunIndex(runs, wordEnd, chars.length);
      int endIndex = runs[endRun].offsetToIndex(wordEnd);
      double pos = runs[endRun].xpos[endIndex];
      bool bumpBreakIndex = true;
      if (pos > xlimit) {
        int wsRun = _offsetToRunIndex(runs, wordStart, chars.length);
        int wsIndex = runs[wsRun].offsetToIndex(wordStart);

        bumpBreakIndex = false;
        // does just one word not fit?
        if (lineStartTextOffset == wordStart) {
          // walk backwards a letter at a time until we fit, stopping at
          // 1 letter.
          int wend = wordEnd;
          while (pos > xlimit && wend - 1 > wordStart) {
            wend -= 1;
            prevRun = _offsetToRunIndex(runs, wend, chars.length);
            prevIndex = runs[prevRun].offsetToIndex(wend);
            pos = runs[prevRun].xpos[prevIndex];
          }
          assert(wend < wordEnd || wend == wordEnd && wordStart + 1 == wordEnd);
          if (wend == wordEnd) {
            bumpBreakIndex = true;
          }

          // now reset our "whitespace" marker to just be prev, since
          // by defintion we have no extra whitespace on this line
          wsRun = prevRun;
          wsIndex = prevIndex;
          wordStart = wend;
        }

        // bulid the line
        final lineStartX = runs[startRun].xpos[startIndex];
        lines.add(GlyphLine(runs, startRun, startIndex, prevRun, prevIndex,
            wsRun, wsIndex, lineStartX));

        // update for the next line
        xlimit = runs[wsRun].xpos[wsIndex] + width;
        startRun = prevRun = wsRun;
        startIndex = prevIndex = wsIndex;
        lineStartTextOffset = wordStart;
      } else {
        // we didn't go too far, so remember this word-end boundary
        prevRun = endRun;
        prevIndex = endIndex;
      }

      if (bumpBreakIndex) {
        if (nextBreakIndex < breaks.length) {
          wordStart = breaks[nextBreakIndex++];
          wordEnd = breaks[nextBreakIndex++];
        } else {
          break; // bust out of the loop
        }
      }
    }
    // scoop up the last line (if present)
    final int tailRun = runs.length - 1;
    final int tailIndex = runs[tailRun].glyphs.length;
    if (startRun != tailRun || startIndex != tailIndex) {
      final double startX = runs[startRun].xpos[startIndex];
      lines.add(GlyphLine(runs, startRun, startIndex, tailRun, tailIndex,
          tailRun, tailIndex, startX));
    }
    return lines;
  }
}
