import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tolerant golden comparison for this package's VM suites, mirroring
/// rive_native's `test/goldens/src/golden_comparator_io.dart` (see there for
/// the rationale behind the two-tier tolerance).
const _kGoldenDiffTolerance = 0.003;
const _kChannelEpsilon = 2;
const _kSignificantDiffTolerance = 0.005;

class AppFileComparator extends LocalFileComparator {
  AppFileComparator(String testFile) : super(Uri.parse(testFile));

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final goldenBytes = await getGoldenBytes(golden);
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      goldenBytes,
    );

    if (result.passed) {
      return true;
    }
    if (result.diffPercent <= _kGoldenDiffTolerance) {
      log(
        'A tolerable difference of ${result.diffPercent * 100}% was found when '
        'comparing $golden.',
      );
      return true;
    }

    final significant = await _significantDiffPercent(imageBytes, goldenBytes);
    if (significant != null && significant <= _kSignificantDiffTolerance) {
      log(
        'Golden $golden differs on ${result.diffPercent * 100}% of pixels but '
        'only ${significant * 100}% exceed the per-channel epsilon of '
        '$_kChannelEpsilon (renderer dithering noise); treating as a match.',
      );
      return true;
    }

    final error = await generateFailureOutput(result, golden, basedir);
    throw FlutterError(error);
  }

  static Future<double?> _significantDiffPercent(
      List<int> aBytes, List<int> bBytes) async {
    final a = await _decode(aBytes);
    final b = await _decode(bBytes);
    if (a.width != b.width || a.height != b.height) {
      return null;
    }
    final aData =
        await a.toByteData(format: ui.ImageByteFormat.rawStraightRgba);
    final bData =
        await b.toByteData(format: ui.ImageByteFormat.rawStraightRgba);
    if (aData == null || bData == null) {
      return null;
    }
    final aPixels = aData.buffer.asUint8List();
    final bPixels = bData.buffer.asUint8List();
    var significant = 0;
    for (var i = 0; i < aPixels.length; i += 4) {
      if ((aPixels[i] - bPixels[i]).abs() > _kChannelEpsilon ||
          (aPixels[i + 1] - bPixels[i + 1]).abs() > _kChannelEpsilon ||
          (aPixels[i + 2] - bPixels[i + 2]).abs() > _kChannelEpsilon ||
          (aPixels[i + 3] - bPixels[i + 3]).abs() > _kChannelEpsilon) {
        significant++;
      }
    }
    return significant / (a.width * a.height);
  }

  static Future<ui.Image> _decode(List<int> bytes) async {
    final codec = await ui.instantiateImageCodec(
        bytes is Uint8List ? bytes : Uint8List.fromList(bytes));
    final frame = await codec.getNextFrame();
    return frame.image;
  }
}

/// Compare [actual] (anything `matchesGoldenFile` accepts, e.g. a
/// [ui.Image]) against `images/$goldenFileKey` next to the test file.
Future<void> expectGoldenMatches(
  dynamic actual,
  String goldenFileKey, {
  String? reason,
  bool skip = false,
}) {
  final goldenPath = 'images/$goldenFileKey';
  // Seed the comparator with the key's basename only: joining a key that
  // contains a subdirectory would shift the comparator's basedir and
  // compound on every subsequent call in the test. (These suites are
  // macOS-only — plain '/' handling is fine.)
  final basedir = (goldenFileComparator as LocalFileComparator).basedir;
  goldenFileComparator =
      AppFileComparator('$basedir${goldenFileKey.split('/').last}');

  return expectLater(
    actual,
    matchesGoldenFile(goldenPath),
    reason: reason,
    skip: skip,
  );
}
