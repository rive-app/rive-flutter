import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

const _kGoldenDiffTolerance = 0.005;

class AppFileComparator extends LocalFileComparator {
  AppFileComparator(String testFile) : super(Uri.parse(testFile));

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    if (!result.passed && result.diffPercent > _kGoldenDiffTolerance) {
      final error = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(error);
    }
    if (!result.passed) {
      log(
        'A tolerable difference of ${result.diffPercent * 100}% was found when '
        'comparing $golden.',
      );
    }
    return result.passed || result.diffPercent <= _kGoldenDiffTolerance;
  }
}

/// Expect that the [actual] image matches the golden image identified by
/// [goldenFileKey].
///
/// This is a wrapper around [expectLater] and [matchesGoldenFile] that
/// automatically sets the [goldenFileComparator] to [AppFileComparator] and
/// sets the golden file path to `images/$goldenFileKey`.
///
/// The tolerance for the difference between the golden and actual image is
/// set to [_kGoldenDiffTolerance] - 0.005.
Future<void> expectGoldenMatches(
  dynamic actual,
  String goldenFileKey, {
  String? reason,
  bool skip = false,
}) {
  final goldenPath = path.join('images', goldenFileKey);
  goldenFileComparator = AppFileComparator(
    path.join(
      (goldenFileComparator as LocalFileComparator).basedir.toString(),
      goldenFileKey,
    ),
  );

  return expectLater(
    actual,
    matchesGoldenFile(goldenPath),
    reason: reason,
    skip: skip,
  );
}
