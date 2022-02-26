import 'dart:math' as math;
import 'dart:ui';

import 'raw_path.dart';
import 'shape_text.dart';

bool contains(Rect r, double x, double y) {
  return r.left <= x && x <= r.right && r.top <= y && y <= r.bottom;
}

Rect outset(Rect r, double dx, double dy) {
  return Rect.fromLTRB(r.left - dx, r.top - dy, r.right + dx, r.bottom + dy);
}

double pin(double min, double max, double value) {
  return math.min(math.max(value, min), max);
}

// DO NOT MODIFY the run
typedef TextRunVisitor = void Function(TextRun);

// Returns either the original, or a new (cloned+modified) run.
// DO NOT MODIFY run.textLength
typedef TextRunMutator = TextRun Function(TextRun);

// Given a shaped run and lineIndex (e.g. for drawing)
// DO NOT MODIFY the GlyphRun
typedef GlyphRunVisitor = void Function(
    GlyphRun, int start, int end, double originX, double originY);

enum LinePref {
  start,
  end,
}

class VBar {
  double x, top, bottom;

  VBar(this.x, this.top, this.bottom);
}

abstract class Paragraph {
  Rect _frame = const Rect.fromLTRB(0, 0, 0, 0);
  List<int> get textCodes;
  List<TextRun> get textRuns;
// cached output
  List<GlyphRun> _runs = [];
  List<GlyphLine> _lines = [];
  bool _dirty = true;

  bool get areTextRunsValid {
    int len = 0;
    textRuns.forEach((run) => len += run.textLength);
    return len == textCodes.length;
  }

  void _validateTextRuns() {
    assert(areTextRunsValid);
  }

  String get text => String.fromCharCodes(textCodes);

  void _validateShaping() {
    if (textCodes.isEmpty) {
      assert(_lines.length == 1);
      assert(_runs.length == 1);
      // ignore: prefer_is_empty
      assert(_runs[0].glyphs.length == 0);
      assert(_runs[0].xpos.length == 1);
      return;
    }

    GlyphLine line = _lines[0];
    line.validate();
    for (int i = 1; i < _lines.length; ++i) {
      final GlyphLine nextLine = _lines[i];
      nextLine.validate();
      assert(line.textEnd == nextLine.textStart);
      line = nextLine;
    }
    assert(line.textEnd == textCodes.length);
  }

  void _makeAligned() {
    double Y = _frame.top;
    for (final line in _lines) {
      double asc = 0;
      double des = 0;
      for (int i = line.startRun; i <= line.wsRun; ++i) {
        final run = _runs[i];
        asc = math.min(asc, run.font.ascent * run.pointSize);
        des = math.max(des, run.font.descent * run.pointSize);
      }
      line.top = Y;
      Y -= asc;
      line.baseline = Y;
      Y += des;
      line.bottom = Y;
    }
    // TODO: good place to perform left/center/right alignment
  }

  void _ensureShapedLines() {
    if (_dirty) {
      _validateTextRuns();
      if (textCodes.isEmpty) {
        return;
        // _runs = [
        //   GlyphRun(_defaultRun.font, _defaultRun.size, null, 0,
        //       Uint16List.fromList([]), Float32List.fromList([0]))
        // ];
        // _lines = [GlyphLine(_runs, 0, 0, 0, 0, 0, 0, 0)];
      } else {
        final breaks = GlyphRun.findWordBreaks(textCodes);
        _runs = GlyphRun.shapeText(textCodes, textRuns);
        _lines = GlyphLine.lineBreak(textCodes, breaks, _runs, _frame.width);
        _makeAligned();
      }
      _validateShaping();
      _dirty = false;
    }
  }

  void trunsChanged() {
    _dirty = true;
  }

  void textCodesChanged() {
    _dirty = true;
  }

  void _layoutChanged() {
    _dirty = true;
  }

  bool get isEmpty {
    return textLength == 0;
  }

  bool get isNotEmpty {
    return textLength != 0;
  }

  int get textLength {
    return textCodes.length;
  }

  Rect get bounds {
    _ensureShapedLines();
    if (_lines.isEmpty) {
      return Rect.zero;
    } else {
      return Rect.fromLTRB(
          _frame.left, _frame.top, _frame.right, _lines.last.bottom);
    }
  }

  Rect get frame {
    return _frame;
  }

  set frame(Rect rect) {
    if (rect == _frame) {
      return;
    }
    if (_frame.width != rect.width) {
      _layoutChanged();
    }
    _frame = rect;
  }

  List<GlyphLine> get lines {
    _ensureShapedLines();
    return _lines;
  }

  double offsetToFrameX(GlyphLine line, int textOffset) {
    return _frame.left + line.offsetToX(textOffset);
  }

  int offsetToLineIndex(int textOffset, LinePref pref) {
    assert(textOffset >= 0 && textOffset <= textLength);
    _ensureShapedLines();
    for (int i = 0; i < _lines.length; ++i) {
      final line = _lines[i];
      assert(line.textStart <= textOffset);
      if (textOffset <= line.textEnd) {
        if (pref == LinePref.start && textOffset == line.textEnd) {
          continue;
        }
        return i;
      }
    }
    return _lines.length - 1;
  }

  GlyphLine offsetToLine(int textOffset, LinePref pref) {
    int index = offsetToLineIndex(textOffset, pref);
    return _lines[index];
  }

// [ index, offset ]
  List<int> _findRunIndexOffset(int offset) {
    assert(offset >= 0 && offset <= textCodes.length);

    int prevLenths = 0;
    for (int i = 0; i < textRuns.length; ++i) {
      final int len = textRuns[i].textLength;
      if (offset < len) {
        return [i, prevLenths];
      }
      prevLenths += len;
      // ignore: parameter_assignments
      offset -= len;
    }
    return [textRuns.length - 1, textCodes.length]; // last run
  }

  int insert(int offset, String str) {
    if (str.isEmpty) {
      return 0;
    }
    assert(textRuns.isNotEmpty);
    final pair = _findRunIndexOffset(offset);
    final int index = pair[0];
    textRuns[index].textLength += str.length;
    trunsChanged();
    final units = str.codeUnits;
    textCodes.insertAll(offset, units);
    textCodesChanged();
    return units.length;
  }

  void delete(int start, int end) {
    assert(start <= end);
    assert(start >= 0);
    assert(end <= textLength);
    if (start == end) {
      return;
    }

    textCodes.removeRange(start, end);
    textCodesChanged();

    int i;
    for (i = 0;; ++i) {
      final run = textRuns[i];
      if (start < run.textLength) {
        break;
      }
      // ignore: parameter_assignments
      start -= run.textLength;
      // ignore: parameter_assignments
      end -= run.textLength;
    }
    TextRun run = textRuns[i];
    assert(start >= 0 && start < run.textLength);
    if (start > 0) {
      // trim leading run
      final int amount = math.min(end, run.textLength) - start;
      assert(amount > 0 && amount < run.textLength);
      run.textLength -= amount;
      // ignore: parameter_assignments
      start += amount;
      assert(start <= end);
      // ignore: parameter_assignments
      end = end - start; // now end is just a length
      i += 1;
    }
    // remove whole runs
    while (end > 0 && end >= textRuns[i].textLength) {
      var run = textRuns[i];
      // ignore: parameter_assignments
      end -= run.textLength;
      _removeRunAt(i);
    }
    if (end > 0) {
      textRuns[i].textLength -= end;
    }
    trunsChanged();
  }

  void setRun(int start, int end, TextRun newRun) {
    modifyRuns(start, end, (TextRun orig) {
      return newRun;
    });
  }

  void removeRun(covariant TextRun run, int index) {
    textRuns.removeAt(index);
  }

  void insertRun(covariant TextRun run, covariant TextRun? before,
      covariant TextRun? after, int index) {
    textRuns.insert(index, run);
  }

  void _removeRunAt(int index) {
    var run = textRuns[index];
    removeRun(run, index);
  }

  void _insertRun(int index, TextRun run) {
    TextRun? before, after;
    if (index > 0 && index <= textRuns.length) {
      before = textRuns[index - 1];
    }
    if (index < textRuns.length) {
      after = textRuns[index];
    }

    insertRun(run, before, after, index);
  }

  /// Resets everything to just the [text] with the [run].
  void setAll(String text, TextRun run) {
    run.textLength = text.length;
    while (textRuns.isNotEmpty) {
      _removeRunAt(0);
    }
    _insertRun(0, run);
    textCodes.clear();
    textCodes.insertAll(0, text.codeUnits);
    _validateTextRuns();
    _dirty = true;
  }

// Lambda returns a new TextRun, or null to indicated that the run
// assed in need not be changed.
  void modifyRuns(int start, int end, TextRunMutator mutator) {
    assert(start >= 0 && start <= end);
    assert(end <= textCodes.length);
    int modLength = end - start;
    if (modLength == 0) {
      return; // snothing to modify
    }

    final first = _findRunIndexOffset(start);
    int trunIndex = first[0];
    int globalOffset = first[1];
    assert(globalOffset < textCodes.length);

    // Handle splitting the first run
    if (start > globalOffset) {
      TextRun origRun = textRuns[trunIndex];
      TextRun newRun = mutator(origRun);
      if (origRun != newRun) {
        final int skipLength = start - globalOffset;
        newRun.textLength = origRun.textLength - skipLength;
        origRun.textLength = skipLength;
        _insertRun(++trunIndex, newRun);
        trunsChanged();
        if (newRun.textLength > modLength) {
          // oops, need to trim and readd oldRun afterwards
          origRun = origRun.cloneRun();
          origRun.textLength = newRun.textLength - modLength;
          newRun.textLength = modLength;
          _insertRun(++trunIndex, origRun);
          return;
        }
        modLength -= newRun.textLength;
      }
      trunIndex += 1;
    }

    // Replace whole runs?
    while (modLength > 0 && modLength >= textRuns[trunIndex].textLength) {
      TextRun origRun = textRuns[trunIndex];
      modLength -= origRun.textLength;
      TextRun newRun = mutator(origRun);
      if (origRun != newRun) {
        removeRun(origRun, trunIndex);
        _insertRun(trunIndex, newRun);
        trunsChanged();
      }
      trunIndex += 1;
    }

    // Trim the last run?
    if (modLength > 0) {
      TextRun origRun = textRuns[trunIndex];
      assert(modLength < origRun.textLength);
      TextRun newRun = mutator(origRun);
      if (origRun != newRun) {
        newRun.textLength = modLength;
        origRun.textLength -= modLength;
        _insertRun(trunIndex, newRun);
        trunsChanged();
      }
    }

// HOW CAN WE COMPARE RUNS?
    if (false) {
      // consolidate equal runs...
      for (int i = 1; i < textRuns.length; ++i) {
        if (textRuns[i - 1] == textRuns[i]) {
          textRuns[i - 1].textLength += textRuns[i].textLength;
          var run = textRuns[i - 1];
          _removeRunAt(i);
          i -= 1; // to undo the loop's ++i
        }
      }
    }
  }

  void visitGlyphs(GlyphRunVisitor visitor) {
    _ensureShapedLines();

    for (final GlyphLine line in _lines) {
      int start = line.startIndex;
      for (int i = line.startRun; i <= line.wsRun; ++i) {
        final run = _runs[i];
        int wsEnd = run.glyphs.length;
        if (i == line.wsRun) {
          // last run on this line
          wsEnd = line.wsIndex;
        }
        visitor(run, start, wsEnd, _frame.left - line.startX, line.baseline);
        start = 0;
      }
    }
  }

  List<GlyphRun> rawGlyphRuns() {
    _ensureShapedLines();
    return _runs;
  }

  void visitText(TextRunVisitor visitor) {
    textRuns.forEach(visitor);
  }

  Rect offsetsToRect(GlyphLine line, int start, int end) {
    assert(start >= line.textStart);
    assert(end <= line.textEnd);
    final double left = offsetToFrameX(line, start);
    final double right = offsetToFrameX(line, end);
    return Rect.fromLTRB(left, line.top, right, line.bottom);
  }

  int xyToOffset(double x, double y) {
    // ignore: parameter_assignments
    x = pin(_frame.left, _frame.right, x);
    // ignore: parameter_assignments
    y = pin(_lines.first.top, _lines.last.bottom, y);

    // move x into xpos coordinates
    // ignore: parameter_assignments
    x -= _frame.left;

    for (final GlyphLine line in _lines) {
      if (y <= line.bottom) {
        // ignore: parameter_assignments
        x += line.startX; // now we're relative to the xpos in this line
        GlyphRun run = line.runs.last;
        for (final GlyphRun r in line.runs) {
          if (x < r.right) {
            run = r;
            break;
          }
        }
        int index = run.xpos.length - 1;
        for (int i = 1; i < run.xpos.length; ++i) {
          if (x < run.xpos[i]) {
            final mid = (run.xpos[i] + run.xpos[i - 1]) * 0.5;
            index = x < mid ? i - 1 : i;
            break;
          }
        }
        return run.textStart + index;
      }
    }
    assert(false);
    return 0;
  }

  VBar getVBar(int textOffset, LinePref pref) {
    final line = offsetToLine(textOffset, pref);
    final x = offsetToFrameX(line, textOffset);
    return VBar(x, line.top, line.bottom);
  }
}

/////////////////////

enum CursorType {
  line,
  path,
}

class Cursor {
  Paragraph para;
  // these are logical, not necessarily sorted
  int _start = 0;
  int _end = 0;

  Cursor(this.para);

  CursorType get type {
    return _start == _end ? CursorType.line : CursorType.path;
  }

  String get text =>
      String.fromCharCodes(para.textCodes.sublist(fromIndex, toIndex));

  int get start {
    return _start;
  }

  int get end {
    return _end;
  }

  int get fromIndex {
    return math.min(_start, _end);
  }

  int get toIndex {
    return math.max(_start, _end);
  }

  bool get isCollapsed => _start == _end;

  int _legalize(int index) {
    return math.max(math.min(index, para.textLength), 0);
  }

  void setIndex(int index) {
    setRange(index, index);
  }

  void setRange(int start, int end) {
    _start = _legalize(start);
    _end = _legalize(end);
  }

  void insert(String str) {
    final int from = fromIndex;
    para.delete(from, toIndex);
    _start = _end = from + para.insert(from, str);
  }

  void delete() {
    if (_start == _end) {
      if (_start > 0) {
        para.delete(_start - 1, _start);
        _start = _end = _start - 1;
      }
    } else {
      para.delete(fromIndex, toIndex);
      _start = _end = fromIndex;
    }
  }

  void arrowLeft(bool extend) {
    if (extend) {
      _end = _legalize(_end - 1);
    } else {
      if (_start == _end) {
        _start = _end = _legalize(_end - 1);
      }
      _start = _end = fromIndex;
    }
  }
  // todo: need to not pre-swap _start and _end

  void arrowRight(bool extend) {
    if (extend) {
      _end = _legalize(_end + 1);
    } else {
      if (_start == _end) {
        _start = _end = _legalize(_end + 1);
      } else {
        _start = _end = toIndex;
      }
    }
  }

  void arrowUp(bool extend) {
    LinePref pref = LinePref.end; // store this somehow?

    int index = para.offsetToLineIndex(_end, pref);
    if (index == 0) {
      _end = 0;
    } else {
      final double currX = para.offsetToFrameX(para._lines[index], _end);
      {
        int i = para.xyToOffset(currX, para._lines[index].baseline);
        assert(i == _end);
      }
      index -= 1;
      _end = para.xyToOffset(currX, para._lines[index].baseline);
    }
    if (!extend) {
      _start = _end;
    }
  }

  void arrowDown(bool extend) {
    LinePref pref = LinePref.end; // store this somehow?

    int index = para.offsetToLineIndex(_end, pref);
    if (index == para._lines.length - 1) {
      _end = para.textLength;
    } else {
      final double currX = para.offsetToFrameX(para._lines[index], _end);
      index += 1;
      _end = para.xyToOffset(currX, para._lines[index].baseline);
    }
    if (!extend) {
      _start = _end;
    }
  }

  void pointerDown(double x, double y) {
    // ignore: parameter_assignments
    x = pin(para.frame.left, para.frame.right, x);
    // ignore: parameter_assignments
    y = pin(para.frame.top, para.frame.bottom, y);
    _start = _end = para.xyToOffset(x, y);
  }

  bool pointerMove(double x, double y) {
    final newEnd = para.xyToOffset(x, y);
    final changed = _end != newEnd;
    _end = newEnd;
    return changed;
  }

  void pointerUp(double x, double y) {}

  // PointerTracker pointerTracker(double x, double y) {
  //   final t = _CursorPointerTracker(this);
  //   t.down(x, y);
  //   return t;
  // }

  void modifyRuns(TextRunMutator mutator) {
    para.modifyRuns(fromIndex, toIndex, mutator);
  }

  VBar getVBar(LinePref pref) {
    return para.getVBar(_end, pref);
  }

  RawPath getRawPath([LinePref pref = LinePref.end]) {
    final b = RawPathBuilder();
    if (type == CursorType.line) {
      final bar = getVBar(pref);
      const width = 1.0;
      b.addLTRB(bar.x, bar.top, bar.x + width, bar.bottom);
    } else {
      final int from = fromIndex;
      final int to = toIndex;
      int index = para.offsetToLineIndex(from, LinePref.start);
      int last = para.offsetToLineIndex(to, LinePref.end);
      if (index == last) {
        GlyphLine line = para.lines[index];
        b.addRect(para.offsetsToRect(line, from, to));
      } else {
        GlyphLine line = para.lines[index];
        b.addRect(para.offsetsToRect(line, from, line.textEnd));
        while (++index < last) {
          line = para.lines[index];
          b.addRect(para.offsetsToRect(line, line.textStart, line.textEnd));
        }
        line = para.lines[last];
        b.addRect(para.offsetsToRect(line, line.textStart, to));
      }
    }
    return b.detach();
  }
}

class SimpleParagraph extends Paragraph {
  final List<int> _textCodes = [];
  final List<TextRun> _truns = [];

  @override
  List<int> get textCodes => _textCodes;

  @override
  List<TextRun> get textRuns => _truns;
}
