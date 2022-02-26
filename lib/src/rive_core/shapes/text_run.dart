import 'dart:ui';

import 'package:rive/src/generated/shapes/text_run_base.dart';
import 'package:rive/src/rive_core/shapes/text.dart';
import 'package:rive/src/rive_core/src/text/raw_path.dart' as rive;
import 'package:rive/src/rive_core/src/text/rive_font.dart';
import 'package:rive/src/rive_core/src/text/shape_text.dart' as rive;

export 'package:rive/src/generated/shapes/text_run_base.dart';

class _DrawableGlyphRun {
  final rive.GlyphRun run;
  final int start;
  final int end;
  final double ox;
  final double oy;

  _DrawableGlyphRun(this.run, this.start, this.end, this.ox, this.oy);
}

class TextRun extends TextRunBase implements rive.TextRun {
  @override
  RiveFont font = RiveFont.builtIn;
  final List<_DrawableGlyphRun> _glyphRuns = [];

  void clearGlyphRuns() => _glyphRuns.clear();

  void addGlyphRun(
      rive.GlyphRun glyphRun, int start, int end, double x, double y) {
    _glyphRuns.add(_DrawableGlyphRun(glyphRun, start, end, x, y));
  }

  Object? attr;
  @override
  bool validate() {
    return super.validate() && parent is Text;
  }

  Text get text => parent as Text;

  @override
  void draw(Canvas canvas) {
    canvas.save();
    canvas.transform(text.worldTransform.mat4);
    for (final drawableRun in _glyphRuns) {
      _visitRawPaths(drawableRun.run, drawableRun.start, drawableRun.end,
          drawableRun.ox, drawableRun.oy, (rive.RawPath rp) {
        canvas.drawPath(_toPath(rp), Paint()..color = const Color(0xFFFFFFFF));
      });
    }
    canvas.restore();
  }

  @override
  void pointSizeChanged(double from, double to) {
    text.markTextShapeDirty();
  }

  @override
  void textLengthChanged(int from, int to) {}

  @override
  rive.TextRun cloneRun() {
    var cloned = super.clone();
    assert(cloned is TextRun);
    return cloned as TextRun;
  }
}

// Should generalize all of this...
Path _toPath(rive.RawPath rp) {
  Path p = Path();
  rp.sinker(p.moveTo, p.lineTo, p.quadraticBezierTo, p.cubicTo, p.close);
  return p;
}

void _visitRawPaths(rive.GlyphRun run, int start, int end, double x, double y,
    Function(rive.RawPath) visitor) {
  for (int i = start; i < end; ++i) {
    final rive.RawPath? p = run.font.getRawPath(run.glyphs[i]);
    if (p != null) {
      visitor(p.scalexy(run.pointSize, run.pointSize, x + run.xpos[i], y));
    }
  }
}
