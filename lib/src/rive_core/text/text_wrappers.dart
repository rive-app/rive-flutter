/// Text Wrappers to force TextDirection.ltr

import 'package:rive/math.dart';
import 'package:rive_common/rive_text.dart';

/// Created to override the TextDirection property of GlyphRun
class ParagraphWrapper extends Paragraph {

  final Paragraph paragraph;
  ParagraphWrapper(this.paragraph);

  @override
  TextDirection get direction => TextDirection.ltr;
  @override
  List<GlyphRun> get runs => paragraph.runs
      .map((r) => r is GlyphRunWrapper ? r : GlyphRunWrapper(r))
      .toList();
}

/// Created to override the TextDirection property of GlyphRun
class GlyphRunWrapper extends GlyphRun {

  final GlyphRun run;
  GlyphRunWrapper(this.run);

  @override
  TextDirection get direction => TextDirection.ltr;

  @override
  double advanceAt(int index) => run.advanceAt(index);
  @override
  Font get font => run.font;
  @override
  double get fontSize => run.fontSize;
  @override
  int get glyphCount => run.glyphCount;
  @override
  int glyphIdAt(int index) => run.glyphIdAt(index);
  @override
  double get letterSpacing => run.letterSpacing;
  @override
  double get lineHeight => run.lineHeight;
  @override
  Vec2D offsetAt(int index) => run.offsetAt(index);
  @override
  int get styleId => run.styleId;
  @override
  int textIndexAt(int index) => run.textIndexAt(index);
  @override
  double xAt(int index) => run.xAt(index);
}