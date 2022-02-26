import 'dart:typed_data';
import 'package:flutter/material.dart';

const int kMove_PathVerb = 0;
const int kLine_PathVerb = 1;
const int kQuad_PathVerb = 2;
const int kConic_PathVerb = 3;
const int kCubic_PathVerb = 4;
const int kClose_PathVerb = 5;

class IPathSink {
  void moveTo(double x, double y) {}
  void lineTo(double x, double y) {}
  void quadTo(double x, double y, double x1, double y1) {}
  void cubicTo(
      double x, double y, double x1, double y1, double x2, double y2) {}
  void close() {}
}

class RawPath {
  Float32List pts;
  Uint8List verbs;

  RawPath(this.pts, this.verbs);

  void sinker(
      Function(double, double) moveTo,
      Function(double, double) lineTo,
      Function(double, double, double, double) quadTo,
      Function(double, double, double, double, double, double) cubicTo,
      Function close) {
    int i = 0;
    for (final int verb in verbs) {
      switch (verb) {
        case kMove_PathVerb:
          moveTo(pts[i + 0], pts[i + 1]);
          i += 2;
          break;
        case kLine_PathVerb:
          lineTo(pts[i + 0], pts[i + 1]);
          i += 2;
          break;
        case kQuad_PathVerb:
          quadTo(pts[i + 0], pts[i + 1], pts[i + 2], pts[i + 3]);
          i += 4;
          break;
        case kConic_PathVerb: // not supported
          assert(false);
          break;
        case kCubic_PathVerb:
          cubicTo(pts[i + 0], pts[i + 1], pts[i + 2], pts[i + 3], pts[i + 4],
              pts[i + 5]);
          i += 6;
          break;
        case kClose_PathVerb:
          close();
          break;
        default:
          throw 'unknown verb $verb';
      }
    }
    assert(i == pts.length);
  }

  RawPath scalexy(double sx, double sy, double tx, double ty) {
    final newp = Float32List(pts.length);
    for (int i = 0; i < pts.length; i += 2) {
      newp[i + 0] = pts[i + 0] * sx + tx;
      newp[i + 1] = pts[i + 1] * sy + ty;
    }
    // we share verbs to save memory -- so don't modify them!
    return RawPath(Float32List.fromList(newp), verbs);
  }
}

class RawPathBuilder {
  List<double> pts = [];
  List<int> vbs = [];

  void reset() {
    pts = [];
    vbs = [];
  }

  double get lastX {
    return pts[pts.length - 2];
  }

  double get lastY {
    return pts[pts.length - 1];
  }

  void moveTo(double x, double y) {
    pts.add(x);
    pts.add(y);
    vbs.add(kMove_PathVerb);
  }

  void lineTo(double x, double y) {
    pts.add(x);
    pts.add(y);
    vbs.add(kLine_PathVerb);
  }

  void quadTo(double x, double y, double x1, double y1) {
    pts.add(x);
    pts.add(y);
    pts.add(x1);
    pts.add(y1);
    vbs.add(kQuad_PathVerb);
  }

  void cubicTo(double x, double y, double x1, double y1, double x2, double y2) {
    pts.add(x);
    pts.add(y);
    pts.add(x1);
    pts.add(y1);
    pts.add(x2);
    pts.add(y2);
    vbs.add(kCubic_PathVerb);
  }

  void close() {
    vbs.add(kClose_PathVerb);
  }

  void addLine(double x0, double y0, double x1, double y1) {
    moveTo(x0, y0);
    lineTo(x1, y1);
  }

  void addLTRB(double l, double t, double r, double b) {
    moveTo(l, t);
    lineTo(r, t);
    lineTo(r, b);
    lineTo(l, b);
    close();
  }

  void addRect(Rect r) {
    addLTRB(r.left, r.top, r.right, r.bottom);
  }

  RawPath detach() {
    final rp = RawPath(Float32List.fromList(pts), Uint8List.fromList(vbs));
    reset();
    return rp;
  }
}
