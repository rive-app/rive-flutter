import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rive/src/rive_core/src/text/built_in_font.dart';

import 'raw_path.dart';

// for diagnostic/debugging purposes
const bool enableFontDump = false;

class Reader {
  ByteData data;
  int offset = 0;

  Reader(this.data);

  int u8() {
    offset += 1;
    return data.getUint8(offset - 1);
  }

  int s16() {
    offset += 2;
    return data.getInt16(offset - 2, Endian.little);
  }

  int u16() {
    offset += 2;
    return data.getUint16(offset - 2, Endian.little);
  }

  int u32() {
    offset += 4;
    return data.getUint32(offset - 4, Endian.little);
  }

  void skipPad16() {
    offset += offset & 1;
  }

  Uint8List u8list(int count) {
    offset += count;
    return Uint8List.sublistView(data, offset - count, offset);
  }

  int available() {
    return data.lengthInBytes - offset;
  }

  bool eof() {
    return offset == data.lengthInBytes;
  }
}

int Tag(int a, int b, int c, int d) {
  return (a << 24) | (b << 16) | (c << 8) | d;
}

String fromTag(int tag) {
  final int a = (tag >> 24) & 0xFF;
  final int b = (tag >> 16) & 0xFF;
  final int c = (tag >> 8) & 0xFF;
  final int d = (tag >> 0) & 0xFF;
  return '' +
      String.fromCharCode(a) +
      String.fromCharCode(b) +
      String.fromCharCode(c) +
      String.fromCharCode(d);
}

const int kCMap_TableTag = 1668112752; // cmap
const int kAdvances_TableTag = 1751213174; // hadv
const int kInfo_TableTag = 1768842863; // info
const int kPaths_TableTag = 1885434984; // path
const int kOffsets_TableTag = 1886348902; // poff

ByteData find_table(List<int> dir, int tag, ByteData data) {
  for (int i = 0; i < dir.length; i += 3) {
    if (dir[i] == tag) {
      return ByteData.view(data.buffer, dir[i + 1], dir[i + 2]);
    }
  }
  throw 'missing ${fromTag(tag)} table';
}

class RiveFont {
  final double _ascent = -0.9; // TODO: get from file
  final double _descent = 0.2; // TODO: get from file

  final _cmap = <int, int>{};
  final _advances = <double>[];
  final _rawpaths = <RawPath?>[];

  RiveFont() {
    _advances.add(0);
    _rawpaths.add(null);
  }

  double get ascent {
    return _ascent;
  }

  double get descent {
    return _descent;
  }

  double get height {
    return _descent - _ascent;
  }

  int charToGlyph(int charCode) {
    int? glyph = _cmap[charCode];
    return glyph ?? 0;
  }

  double getAdvance(int glyph) {
    return _advances[glyph];
  }

  Path? getPath(int glyph) {
    final rp = getRawPath(glyph);
    if (rp != null) {
      Path p = Path();
      rp.sinker(p.moveTo, p.lineTo, p.quadraticBezierTo, p.cubicTo, p.close);
      return p;
    }
    return null;
  }

  RawPath? getRawPath(int glyph) {
    return _rawpaths[glyph];
  }

  Uint16List textToGlyphs(List<int> chars, int start, int end) {
    final int n = end - start;
    Uint16List glyphs = Uint16List(n);
    for (int i = 0; i < n; ++i) {
      glyphs[i] = charToGlyph(chars[i + start]);
    }
    return glyphs;
  }

  Float32List getAdvances(Uint16List glyphs) {
    Float32List advances = Float32List(glyphs.length);
    for (int i = 0; i < glyphs.length; ++i) {
      advances[i] = getAdvance(glyphs[i]);
    }
    return advances;
  }

  void _build_cmap(int glyphCount, ByteData cmapD) {
    final reader = Reader(cmapD);
    final int count = reader.u16();
    if (enableFontDump) {
      print('cmap has $count entries');
    }
    for (int i = 0; i < count; ++i) {
      final int charCode = reader.u16();
      final int glyphID = reader.u16();
      assert(glyphID < glyphCount);
      _cmap.putIfAbsent(charCode, () => glyphID);
    }
  }

  void _build_advances(int glyphCount, double scale, ByteData advD) {
    assert(advD.lengthInBytes == glyphCount * 2);
    final advances = Reader(advD);
    for (int i = 0; i < glyphCount; ++i) {
      _advances.add(advances.u16() * scale);
    }
  }

  RawPath _build_rawpath(double scale, ByteData pathD) {
    final reader = Reader(pathD);

    final int verbCount = reader.u16();
    assert(verbCount > 0);
    final int pointCount = reader.u16();
    final Float32List pts = Float32List(pointCount * 2);

    final verbs = reader.u8list(verbCount);
    reader.skipPad16();
    for (int i = 0; i < pointCount * 2; ++i) {
      pts[i] = reader.s16() * scale;
    }
    assert(reader.eof());
    return RawPath(pts, verbs);
  }

  void _build_rawpaths(
      int glyphCount, double scale, ByteData offD, ByteData pathD) {
    final offsets = Reader(offD);
    int start = offsets.u32();
    for (int i = 0; i < glyphCount; ++i) {
      int end = offsets.u32();
      assert(start <= end);

      RawPath? path;
      if (start < end) {
        path = _build_rawpath(scale, ByteData.sublistView(pathD, start, end));
      }
      _rawpaths.add(path);

      start = end;
    }
  }

  RiveFont.fromBinary(ByteData data) {
    final Reader reader = Reader(data);

    {
      int signature = reader.u32();
      int version = reader.u32();
      assert(signature == 0x23581321);
      assert(version == 1);
    }
    final int tableCount = reader.u32();
    if (enableFontDump) {
      print('tables $tableCount');
    }

    final List<int> dir = [];
    for (int i = 0; i < tableCount; ++i) {
      int tag = reader.u32();
      int off = reader.u32();
      int len = reader.u32();
      if (enableFontDump) {
        print('tag: ${fromTag(tag)} offset:$off length:$len');
      }
      dir.add(tag); // tag
      dir.add(off); // offset
      dir.add(len); // length
    }

    final infoReader = Reader(find_table(dir, kInfo_TableTag, data));
    final int glyphCount = infoReader.u16();
    final int upem = infoReader.u16();
    final double scale = 1.0 / upem;
    if (enableFontDump) {
      print('glyphs $glyphCount, upem $upem');
    }

    _build_cmap(glyphCount, find_table(dir, kCMap_TableTag, data));

    _build_advances(
        glyphCount, scale, find_table(dir, kAdvances_TableTag, data));

    _build_rawpaths(glyphCount, scale, find_table(dir, kOffsets_TableTag, data),
        find_table(dir, kPaths_TableTag, data));
  }

  static final builtIn = RiveFont.fromBinary(
      ByteData.view(const Base64Decoder().convert(builtInFontBase64).buffer));
}
