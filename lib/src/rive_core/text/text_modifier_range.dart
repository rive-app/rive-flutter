import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/text/text_modifier_range_base.dart';
import 'package:rive/src/rive_core/animation/cubic_interpolator_component.dart';
import 'package:rive/src/rive_core/animation/interpolator.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/enum_helper.dart';
import 'package:rive/src/rive_core/text/text_modifier_group.dart';
import 'package:rive/src/rive_core/text/text_value_run.dart';
import 'package:rive/src/rive_core/text/text_wrappers.dart';
import 'package:rive_common/rive_text.dart';

export 'package:rive/src/generated/text/text_modifier_range_base.dart';

enum TextRangeUnits { characters, charactersExcludingSpaces, words, lines }

enum TextRangeMode { add, subtract, multiply, min, max, difference }

enum TextRangeType { percentage, unitIndex }

enum TextRangeInterpolator { linear, cubic }

class TextModifierRange extends TextModifierRangeBase {
  TextModifierGroup? get modifierGroup =>
      parent is TextModifierGroup ? parent as TextModifierGroup : null;

  /// Marking shape dirty should only be done if this modifer group changes
  /// shaping properties (for now we're just testing and we're hardcoding a
  /// shaping change).
  @override
  void modifyFromChanged(double from, double to) =>
      modifierGroup?.rangeChanged();

  @override
  void modifyToChanged(double from, double to) => modifierGroup?.rangeChanged();

  TextRangeInterpolator get interpolatorType =>
      _interpolator is CubicInterpolatorComponent
          ? TextRangeInterpolator.cubic
          : TextRangeInterpolator.linear;

  Interpolator? _interpolator;
  Interpolator? get interpolator => _interpolator;

  @override
  void update(int dirt) {}

  @override
  void onDirty(int mask) {
    if ((mask & ComponentDirt.interpolator) != 0) {
      modifierGroup?.rangeChanged();
    }
  }

  @override
  void childAdded(Component child) {
    super.childAdded(child);
    if (child is Interpolator) {
      _interpolator = child as Interpolator;
      modifierGroup?.rangeTypeChanged();
    }
  }

  @override
  void childRemoved(Component child) {
    super.childRemoved(child);

    if (child is Interpolator && _interpolator == (child as Interpolator)) {
      _interpolator = children
          .firstWhereOrNull((child) => child is Interpolator) as Interpolator?;
      modifierGroup?.rangeTypeChanged();
    }
  }

  double get offsetModifyFrom => modifyFrom + offset;
  double get offsetModifyTo => modifyTo + offset;
  double get offsetFalloffFrom => falloffFrom + offset;
  double get offsetFalloffTo => falloffTo + offset;

  @override
  void falloffFromChanged(double from, double to) =>
      modifierGroup?.rangeChanged();

  @override
  void falloffToChanged(double from, double to) =>
      modifierGroup?.rangeChanged();

  @override
  void offsetChanged(double from, double to) => modifierGroup?.rangeChanged();

  // Cache indices.
  double _indexFrom = 0;
  double _indexTo = 0;
  double _indexFalloffFrom = 0;
  double _indexFalloffTo = 0;
  double get indexFrom => _indexFrom;
  double get indexTo => _indexTo;
  double get indexFalloffFrom => _indexFalloffFrom;
  double get indexFalloffTo => _indexFalloffTo;

  bool get needsShape => units == TextRangeUnits.lines;

  RangeMapper? _rangeMapper;

  void clearRangeMap() => _rangeMapper = null;

  void computeRange(String text, TextShapeResult? shape,
      BreakLinesResult? lines, GlyphLookup glyphLookup) {
    // Check if range mapper is still valid.
    if (_rangeMapper != null) {
      return;
    }
    int start = 0;
    int end = text.length;
    if (run != null) {
      start = run!.offset;
      end = start + run!.text.length;
    }
    switch (units) {
      case TextRangeUnits.charactersExcludingSpaces:
        _rangeMapper = RangeMapper.fromCharacters(
          text,
          start,
          end,
          glyphLookup,
          withoutSpaces: true,
        );
        break;
      case TextRangeUnits.words:
        _rangeMapper = RangeMapper.fromWords(text, start, end);
        break;
      case TextRangeUnits.lines:
        if (shape != null && lines != null) {
          _rangeMapper = RangeMapper.fromLines(
              text, start, end, shape, lines, glyphLookup);
        }
        break;
      default:
        _rangeMapper = RangeMapper.fromCharacters(
          text,
          start,
          end,
          glyphLookup,
        );
        break;
    }
  }

  void computeCoverage(Float32List coverage) {
    if (_rangeMapper == null) {
      return;
    }

    _computeRangeMappedCoverage(coverage, _rangeMapper!);
  }

  double _coverageAt(double t) {
    var c = 0.0;
    if (_indexTo >= _indexFrom) {
      if (t < _indexFrom || t > _indexTo) {
        c = 0;
      } else if (t < _indexFalloffFrom) {
        var range = max(0, _indexFalloffFrom - _indexFrom);
        c = range == 0 ? 1 : max(0, t - _indexFrom) / range;
        if (_interpolator != null) {
          c = _interpolator!.transform(c);
        }
      } else if (t > _indexFalloffTo) {
        var range = max(0, _indexTo - _indexFalloffTo);
        c = range == 0 ? 1 : 1.0 - min(1, (t - _indexFalloffTo) / range);
        if (_interpolator != null) {
          c = _interpolator!.transform(c);
        }
      } else {
        c = 1;
      }
    }
    return c;
  }

  void _computeRangeMappedCoverage(Float32List coverage, RangeMapper mapper) {
    var count = mapper.unitCount;
    switch (type) {
      case TextRangeType.unitIndex:
        _indexFrom = offsetModifyFrom;
        _indexTo = offsetModifyTo;
        _indexFalloffFrom = offsetFalloffFrom;
        _indexFalloffTo = offsetFalloffTo;
        break;
      case TextRangeType.percentage:
        _indexFrom = count * offsetModifyFrom;
        _indexTo = count * offsetModifyTo;
        _indexFalloffFrom = count * offsetFalloffFrom;
        _indexFalloffTo = count * offsetFalloffTo;
        break;
    }

    var mode = this.mode;
    for (int unitIndex = 0; unitIndex < count; unitIndex++) {
      var unitLength = mapper.unitLengths[unitIndex];
      var characterIndex = mapper.unitIndices[unitIndex];
      double c = strength * _coverageAt(unitIndex + 0.5);
      for (int i = 0; i < unitLength; i++) {
        var current = coverage[characterIndex + i];
        switch (mode) {
          case TextRangeMode.add:
            current += c;
            break;
          case TextRangeMode.subtract:
            current -= c;
            break;
          case TextRangeMode.max:
            current = max(current, c);
            break;
          case TextRangeMode.min:
            current = min(current, c);
            break;
          case TextRangeMode.multiply:
            current *= c;
            break;
          case TextRangeMode.difference:
            current = (current - c).abs();
            break;
        }
        coverage[characterIndex + i] = clamp ? current.clamp(0, 1) : current;
      }

      // Set space between units coverage to 0.
      if (unitIndex < mapper.unitIndices.length - 1) {
        var nextUnitIndex = mapper.unitIndices[unitIndex + 1];
        for (int i = characterIndex + unitLength; i < nextUnitIndex; i++) {
          coverage[i] = 0;
        }
      }
    }
  }

  TextRangeUnits get units => enumAt(TextRangeUnits.values, unitsValue);
  set units(TextRangeUnits units) => unitsValue = units.index;

  @override
  void unitsValueChanged(int from, int to) => modifierGroup?.rangeTypeChanged();

  TextRangeMode get mode => TextRangeMode.values[modeValue];
  set mode(TextRangeMode mode) => modeValue = mode.index;

  @override
  void modeValueChanged(int from, int to) => modifierGroup?.rangeChanged();

  TextRangeType get type => enumAt(TextRangeType.values, typeValue);
  set type(TextRangeType value) => typeValue = value.index;

  @override
  void typeValueChanged(int from, int to) => modifierGroup?.rangeChanged();

  @override
  void clampChanged(bool from, bool to) => modifierGroup?.rangeChanged();

  @override
  void strengthChanged(double from, double to) => modifierGroup?.rangeChanged();

  @override
  void runIdChanged(int from, int to) {
    run = to == Core.missingId ? null : context.resolve(to);
    modifierGroup?.rangeTypeChanged();
  }

  @override
  void onAddedDirty() {
    run = context.resolve(runId);
    super.onAddedDirty();
  }

  TextValueRun? _run;

  TextValueRun? get run => _run;

  set run(TextValueRun? value) {
    if (_run == value) {
      return;
    }

    _run = value;
  }
}

// See word indices and word lengths implementation above, we basically want the
// same thing but for different range types (Glyphs, Characters without spaces,
// lines, etc).
class RangeMapper {
  /// Each item in this list represents the index (in unicode codepoints) of the
  /// selectable element. Always has length 1+unitLengths.length as it's
  /// expected to always include the final index with 0 length.
  final Uint32List unitIndices;

  /// Each item in this list represents the length of the matching element at
  /// the same index in the _unitIndices list.
  final Uint32List unitLengths;

  int get unitCount => unitLengths.length;

  RangeMapper(List<int> indices, List<int> lengths)
      : assert(indices.length == lengths.length + 1),
        unitIndices = Uint32List.fromList(indices),
        unitLengths = Uint32List.fromList(lengths);

  /// Build a RangeMapper from the words in [text].
  static RangeMapper? fromWords(String text, int start, int end) {
    if (text.isEmpty) {
      return null;
    }
    List<int> indices = [];
    List<int> lengths = [];
    bool wantWhiteSpace = false;

    int characterCount = 0;
    int index = 0;
    int indexFrom = 0;
    for (final unit in text.codeUnits) {
      if (wantWhiteSpace == isWhiteSpace(unit)) {
        if (!wantWhiteSpace) {
          indexFrom = index;
        } else {
          var indexTo = indexFrom + characterCount;
          if (indexTo > start && end > indexFrom) {
            var actualStart = max(start, indexFrom);
            int selected = min(end, indexTo) - actualStart;
            if (selected > 0) {
              indices.add(actualStart);
              lengths.add(selected);
            }
          }

          characterCount = 0;
        }
        wantWhiteSpace = !wantWhiteSpace;
      }
      if (wantWhiteSpace) {
        characterCount++;
      }
      index++;
    }
    if (characterCount > 0) {
      var indexTo = indexFrom + characterCount;
      if (indexTo > start && end > indexFrom) {
        var actualStart = max(start, indexFrom);
        int selected = min(end, indexTo) - actualStart;
        if (selected > 0) {
          indices.add(actualStart);
          lengths.add(selected);
        }
      }
    }
    indices.add(end);
    return RangeMapper(indices, lengths);
  }

  /// Build a RangeMapper from the words in [text].
  static RangeMapper? fromCharacters(
      String text, int start, int end, GlyphLookup glyphLookup,
      {bool withoutSpaces = false}) {
    if (text.isEmpty) {
      return null;
    }
    List<int> indices = [];
    List<int> lengths = [];
    for (int i = start; i < end;) {
      var unit = text.codeUnits[i];
      if (withoutSpaces && isWhiteSpace(unit)) {
        i++;
        continue;
      }
      // Don't break ligated glyphs.
      var codePoints = glyphLookup.count(i);
      indices.add(i);
      lengths.add(codePoints);
      i += codePoints;
    }

    indices.add(end);
    return RangeMapper(indices, lengths);
  }

  static RangeMapper? fromLines(String text, int start, int end,
      TextShapeResult shape, BreakLinesResult lines, GlyphLookup glyphLookup) {
    if (text.isEmpty) {
      return null;
    }
    List<int> indices = [];
    List<int> lengths = [];

    var paragraphIndex = 0;
    for (final paragraphLines in lines) {
      final paragraph = ParagraphWrapper(shape.paragraphs[paragraphIndex++]);
      var glyphRuns = paragraph.runs;
      for (final line in paragraphLines) {
        var rf = glyphRuns[line.startRun];
        var indexFrom = rf.textIndexAt(line.startIndex);

        var rt = glyphRuns[line.endRun];
        var endGlyphIndex = max(0, line.endIndex - 1);
        var indexTo = rt.textIndexAt(endGlyphIndex);
        indexTo += glyphLookup.count(indexTo);

        if (indexTo > start && end > indexFrom) {
          var actualStart = max(start, indexFrom);
          int selected = min(end, indexTo) - actualStart;
          if (selected > 0) {
            indices.add(actualStart);
            lengths.add(selected);
          }
        }
      }
    }
    indices.add(end);
    return RangeMapper(indices, lengths);
  }

  double unitToCharacterRange(double word) {
    if (unitIndices.isEmpty) {
      return 0;
    }
    var clampedUnit = word.clamp(0, unitIndices.length - 1);
    var intUnit = clampedUnit.floor();
    double characters = unitIndices[intUnit].toDouble();
    if (intUnit < unitLengths.length) {
      var fraction = clampedUnit - intUnit;
      characters += unitLengths[intUnit] * fraction;
    }
    return characters;
  }
}