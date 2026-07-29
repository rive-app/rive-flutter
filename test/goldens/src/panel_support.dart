import 'dart:io' as io;
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

/// Decode a `.riv` asset with the Rive factory; disposed with the test.
Future<File> decodeRiveFile(WidgetTester tester, String assetPath) async {
  final bytes = io.File(assetPath).readAsBytesSync();
  final file = await tester.runAsync(
    () => File.decode(bytes, riveFactory: Factory.rive),
  );
  expect(file, isNotNull, reason: 'failed to decode $assetPath');
  addTearDown(file!.dispose);
  return file;
}

/// Capture the mounted panel's shared texture (via its internal
/// [RiveSurface]'s public handle) as an image — the test rasterizer never
/// sees texture contents.
Future<ui.Image> captureSharedTexture(WidgetTester tester) async {
  final texture = tester
      .widget<RiveSurface>(find.byType(RiveSurface))
      .sharedTexture
      .texture;
  expect(texture.isReady, isTrue);
  return (await tester.runAsync(() => texture.toImage()))!;
}
