import 'dart:io' as io;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';
import 'package:rive_native/rive_native.dart' as rive;

/// Tests for the [RenderResolution] plumbing in the rive package:
/// [RiveWidget] rejects the parameter on the shared-texture path (the surface
/// owns that allocation), and [RiveSurface]/[RivePanel] forward their policy
/// to the texture's widget host.
base class _FakeRenderTexture extends rive.RenderTexture {
  rive.RenderResolution? lastWidgetResolution;

  @override
  int get textureId => -1;
  @override
  dynamic get nativeTexture => null;
  @override
  int get actualWidth => 0;
  @override
  int get actualHeight => 0;
  @override
  bool get isReady => false;
  @override
  bool get isDisposed => false;
  @override
  rive.Renderer get renderer => throw UnimplementedError();
  @override
  bool clear(Color color, [bool write = true]) => true;
  @override
  bool flush(double devicePixelRatio) => true;
  @override
  bool needsResize(int width, int height) => false;
  @override
  Future<void> makeRenderTexture(int width, int height) async {}
  @override
  Future<ui.Image> toImage() => throw UnimplementedError();

  @override
  Widget widget({
    rive.RenderTexturePainter? painter,
    rive.RenderResolution resolution = const rive.RenderResolution.display(),
    Key? key,
  }) {
    lastWidgetResolution = resolution;
    return SizedBox.shrink(key: key);
  }

  @override
  void dispose() {}
}

SharedRenderTexture _makeShared(_FakeRenderTexture texture) =>
    SharedRenderTexture(
      texture: texture,
      devicePixelRatio: 1.0,
      backgroundColor: const Color(0x00000000),
      panelKey: GlobalKey(),
    );

void main() {
  group('RiveWidget.renderResolution', () {
    late File riveFile;
    late RiveWidgetController controller;

    setUp(() async {
      final file = io.File('test/assets/rive_file_controller_test.riv');
      riveFile = await File.decode(
        await file.readAsBytes(),
        riveFactory: Factory.flutter,
      ) as File;
      controller = RiveWidgetController(riveFile);
    });

    tearDown(() {
      controller.dispose();
      riveFile.dispose();
    });

    test('asserts when combined with useSharedTexture', () {
      expect(
        () => RiveWidget(
          controller: controller,
          useSharedTexture: true,
          renderResolution: const RenderResolution.layout(),
        ),
        throwsAssertionError,
      );
    });

    test('asserts when combined with an explicit sharedTexture', () {
      final texture = _FakeRenderTexture();
      final shared = _makeShared(texture);
      addTearDown(shared.dispose);

      expect(
        () => RiveWidget(
          controller: controller,
          sharedTexture: shared,
          renderResolution: const RenderResolution.fixed(64, 64),
        ),
        throwsAssertionError,
      );
    });

    test('constructs on the own-texture path', () {
      expect(
        () => RiveWidget(
          controller: controller,
          renderResolution: const RenderResolution.layout(scale: 0.5),
        ),
        returnsNormally,
      );
    });
  });

  group('RiveSurface / RivePanel forwarding', () {
    testWidgets('RiveSurface hands its renderResolution to the texture widget',
        (tester) async {
      final texture = _FakeRenderTexture();
      final shared = _makeShared(texture);
      addTearDown(shared.dispose);

      await tester.pumpWidget(
        RiveSurface(
          sharedTexture: shared,
          renderResolution: const RenderResolution.layout(scale: 0.5),
        ),
      );

      expect(
        texture.lastWidgetResolution,
        const RenderResolution.layout(scale: 0.5),
      );
    });

    testWidgets('RiveSurface defaults to display', (tester) async {
      final texture = _FakeRenderTexture();
      final shared = _makeShared(texture);
      addTearDown(shared.dispose);

      await tester.pumpWidget(RiveSurface(sharedTexture: shared));

      expect(
        texture.lastWidgetResolution,
        const RenderResolution.display(),
      );
    });
  });
}
