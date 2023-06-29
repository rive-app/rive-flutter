import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:rive/src/generated/text/text_modifier_group_base.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/text/text.dart';
import 'package:rive/src/rive_core/text/text_modifier.dart';
import 'package:rive/src/rive_core/text/text_modifier_range.dart';
import 'package:rive/src/rive_core/text/text_shape_modifier.dart';
import 'package:rive/src/rive_core/text/text_variation_modifier.dart';
import 'package:rive_common/math.dart';
import 'package:rive_common/rive_text.dart';

export 'package:rive/src/generated/text/text_modifier_group_base.dart';

class TextModifierFlags {
  static const int modifyOrigin = 1 << 0;
  static const int modifyTranslation = 1 << 2;
  static const int modifyRotation = 1 << 3;
  static const int modifyScale = 1 << 4;
  static const int modifyOpacity = 1 << 5;
  static const int invertOpacity = 1 << 6;
}

class TextModifierGroup extends TextModifierGroupBase {
  Text? get textComponent => parent as Text?;

  List<TextModifierRange> _ranges = [];
  List<TextShapeModifier> _shapeModifiers = [];
  List<TextModifier> _modifiers = [];
  List<TextModifier> get modifiers => _modifiers;
  Iterable<TextModifierRange> get ranges => _ranges;

  bool get needsShape =>
      _shapeModifiers.isNotEmpty || _ranges.any((range) => range.needsShape);

  void _syncModifiers() {
    _ranges = children.whereType<TextModifierRange>().toList(growable: false);
    _modifiers = children.whereType<TextModifier>().toList(growable: false);
    _shapeModifiers =
        _modifiers.whereType<TextShapeModifier>().toList(growable: false);
  }

  @override
  void onAdded() {
    super.onAdded();
    _syncModifiers();
  }

  void rangeTypeChanged() {
    textComponent?.markShapeDirty();
    addDirt(ComponentDirt.textCoverage);
  }

  void rangeChanged() {
    /// Marking shape dirty should only be done if this modifer group changes
    /// shaping properties (for now we're just testing and we're hardcoding a
    /// shaping change).
    if (_shapeModifiers.isNotEmpty) {
      textComponent?.modifierShapeDirty();

      /// We don't need to add dirt as our coverage will be pre-computed during
      /// the [Text.computeShape] call. This is because coverage is necessary to
      /// properly shape the text.
    } else {
      textComponent?.markPaintDirty();

      /// Coverage will be computed during our update and before
      /// [Text._buildRenderStyles].
      addDirt(ComponentDirt.textCoverage);
    }
  }

  /// Clear any cached selector range maps so they can be recomputed after next
  /// shaping.
  void clearRangeMaps() {
    for (final range in _ranges) {
      range.clearRangeMap();
    }
    addDirt(ComponentDirt.textCoverage);
  }

  /// Coverage is ultimately always expressed per unicode codepoint.
  Float32List _coverage = Float32List(1);
  int _textSize = -1;

  @visibleForTesting
  Float32List get coverageValues => _coverage;

  void computeRangeMap(String text, TextShapeResult? shape,
      BreakLinesResult? lines, GlyphLookup glyphLookup) {
    _textSize = text.length;
    for (final range in _ranges) {
      range.computeRange(text, shape, lines, glyphLookup);
    }
  }

  @override
  void buildDependencies() => parent?.addDependent(this);

  void computeCoverage() {
    if (_textSize == -1) {
      // This can happen if we're still loading the default font.
      return;
    }
    // When the text re-shapes, we udpate our coverage values.
    _coverage = Float32List(_textSize);
    for (final range in _ranges) {
      range.computeCoverage(_coverage);
    }
  }

  /// Coverage at unicodepoint index.
  double coverage(int index) => _coverage[index.clamp(0, _coverage.length - 1)];

  /// Coverage for a glyph.
  double glyphCoverage(LineRunGlyph glyphInfo) {
    var count = textComponent?.glyphCodePointCount(glyphInfo) ?? 1;
    var index = glyphInfo.run.textIndexAt(glyphInfo.index);
    if (count == 1) {
      return coverage(index);
    }
    var c = coverage(index);

    for (int i = 1; i < count; i++) {
      c += coverage(index + i);
    }
    return c /= count;
  }

  @override
  void update(int dirt) {
    if (dirt & ComponentDirt.textCoverage != 0) {
      computeCoverage();
    }
  }

  final List<Font> _cleanupFonts = [];

  TextRun modifyShape(Text text, TextRun run, double strength) {
    var font = text.styleFromShaperId(run.styleId)?.font;
    if (font == null) {
      return run;
    }

    HashMap<int, double> axisVariations = run.userData is HashMap<int, double>
        ? run.userData as HashMap<int, double>
        : HashMap<int, double>();
    double fontSize = run.fontSize;
    for (final modifier in _shapeModifiers) {
      // ignore: parameter_assignments
      fontSize =
          modifier.modify(text, font, axisVariations, fontSize, strength);
    }

    if (axisVariations.isNotEmpty) {
      var varFont = font.withOptions(
        axisVariations.entries
            .map((entry) => FontAxisCoord(entry.key, entry.value)),
        [],
      );
      if (varFont != null) {
        _cleanupFonts.add(varFont);
        font = varFont;
      }
    }
    return run.copyWith(
      font: font,
      userData: axisVariations,
      fontSize: fontSize,
    );
  }

  bool get modifiesOpacity =>
      (modifierFlags & TextModifierFlags.modifyOpacity) != 0;

  bool get opacityInverted =>
      (modifierFlags & TextModifierFlags.invertOpacity) != 0;

  bool get modifiesTranslation =>
      (modifierFlags & TextModifierFlags.modifyTranslation) != 0;

  bool get modifiesOrigin =>
      (modifierFlags & TextModifierFlags.modifyOrigin) != 0;

  bool get modifiesScale =>
      (modifierFlags & TextModifierFlags.modifyScale) != 0;

  bool get modifiesRotation =>
      (modifierFlags & TextModifierFlags.modifyRotation) != 0;

  bool get modifiesTransform =>
      (modifierFlags &
          (TextModifierFlags.modifyTranslation |
              TextModifierFlags.modifyRotation |
              TextModifierFlags.modifyScale |
              TextModifierFlags.modifyOrigin)) !=
      0;

  bool modifiesAxes(int tag) => modifiers
      .whereType<TextVariationModifier>()
      .any((modifier) => modifier.axisTag == tag);

  double computeOpacity(double current, double t) {
    if (opacityInverted) {
      return current * (1 - t) + opacity * t;
    } else {
      return current * opacity * t;
    }
  }

  Mat2D get originTransform {
    Mat2D xform =
        modifiesOrigin ? Mat2D.fromTranslate(-originX, -originY) : Mat2D();
    return xform;
  }

  Mat2D transform(double t, Mat2D glyphTransform) {
    if (t == 0 || !modifiesTransform) {
      return glyphTransform;
    }

    var transform = Mat2D();
    var actualRotation = rotation * t;
    if (actualRotation != 0) {
      Mat2D.fromRotation(transform, actualRotation);
    } else {
      Mat2D.setIdentity(transform);
    }
    transform[4] = x * t;
    transform[5] = y * t;
    Mat2D.scaleByValues(transform, (1 - t) + scaleX * t, (1 - t) + scaleY * t);
    glyphTransform[4] += originX;
    glyphTransform[5] += originY;
    var result = Mat2D.multiply(Mat2D(), transform, glyphTransform);
    result[4] -= originX;
    result[5] -= originY;
    return result;
  }

  List<TextRun> applyShapeModifiers(Text text, List<TextRun> runs) {
    for (final font in _cleanupFonts) {
      font.dispose();
    }
    _cleanupFonts.clear();
    if (_shapeModifiers.isEmpty) {
      return runs;
    }

    // modify the runs
    var nextTextRuns = <TextRun>[];
    var index = 0;
    var lastCoverage = double.maxFinite;
    var extractRunIndex = 0;

    for (final run in runs) {
      // Split the run into sub-runs as necessary based on equal coverage
      // values.
      var end = index + run.unicharCount;

      while (index < end) {
        var coverage = _coverage[index];
        if (coverage != lastCoverage) {
          if (index - extractRunIndex != 0) {
            // Add new run from extractRunStart to index (exclusive)
            if (lastCoverage == 0) {
              nextTextRuns
                  .add(run.copyWith(unicharCount: index - extractRunIndex));
            } else {
              nextTextRuns.add(modifyShape(
                  text,
                  run.copyWith(unicharCount: index - extractRunIndex),
                  lastCoverage));
            }
          }
          lastCoverage = coverage;
          extractRunIndex = index;
        }
        index++;
      }

      assert(extractRunIndex != end);
      // Add new run from extractRunStart to index (exclusive)
      if (lastCoverage == 0) {
        nextTextRuns.add(run.copyWith(unicharCount: end - extractRunIndex));
      } else {
        nextTextRuns.add(modifyShape(text,
            run.copyWith(unicharCount: end - extractRunIndex), lastCoverage));
      }
      extractRunIndex = end;
    }
    return nextTextRuns;
  }

  @override
  void modifierFlagsChanged(int from, int to) {
    textComponent?.markPaintDirty();
  }

  @override
  void opacityChanged(double from, double to) =>
      textComponent?.markPaintDirty();
  @override
  void originXChanged(double from, double to) =>
      textComponent?.markPaintDirty();

  @override
  void originYChanged(double from, double to) =>
      textComponent?.markPaintDirty();
  @override
  void rotationChanged(double from, double to) =>
      textComponent?.markPaintDirty();

  @override
  void scaleXChanged(double from, double to) => textComponent?.markPaintDirty();
  @override
  void scaleYChanged(double from, double to) => textComponent?.markPaintDirty();

  @override
  void xChanged(double from, double to) => textComponent?.markPaintDirty();

  @override
  void yChanged(double from, double to) => textComponent?.markPaintDirty();
}
