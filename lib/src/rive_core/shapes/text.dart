import 'dart:ui';

import 'package:rive/src/generated/shapes/text_base.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/shapes/text_run.dart';
import 'package:rive/src/rive_core/src/text/paragraph.dart' as rive;

export 'package:rive/src/generated/shapes/text_base.dart';

class Text extends TextBase with rive.Paragraph {
  List<TextRun> _textRuns = [];
  List<int> _textCodes = [];
  Text() {
    frame = const Rect.fromLTWH(0, 0, 200, 200);
  }
  @override
  List<TextRun> get textRuns => _textRuns;

  @override
  List<int> get textCodes => _textCodes;

  @override
  void removeRun(TextRun run, int index) {
    run.remove();
    sortChildren();
  }

  @override
  bool validate() => super.validate() && areTextRunsValid;
  @override
  void onAddedDirty() {
    super.onAddedDirty();
    _textCodes = value.codeUnits.toList(growable: true);
  }

  @override
  void textCodesChanged() {
    value = String.fromCharCodes(textCodes);
    markTextShapeDirty();
  }

  @override
  void modifyRuns(int start, int end, rive.TextRunMutator mutator) {
    super.modifyRuns(start, end, mutator);
    markTextShapeDirty();
  }


  @override
  void sortChildren() {
    // Cache the runs.
    _textRuns = children.whereType<TextRun>().toList();
    markTextShapeDirty();
  }


  @override
  void valueChanged(String from, String to) {
    _textCodes = value.codeUnits.toList(growable: true);
    super.textCodesChanged();
    markTextShapeDirty();
  }

  void markTextShapeDirty() {
    addDirt(ComponentDirt.textShape);
  }

  @override
  void update(int dirt) {
    super.update(dirt);
    if ((dirt & ComponentDirt.textShape) != 0) {
      for (final textRun in _textRuns) {
        textRun.clearGlyphRuns();
      }
      visitGlyphs((glyphRun, start, end, originX, originY) {
        var textRun = glyphRun.textRun as TextRun;
        textRun.addGlyphRun(glyphRun, start, end, originX, originY);
      });
    }
  }
}
