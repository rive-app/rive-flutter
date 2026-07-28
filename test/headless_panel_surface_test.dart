@TestOn('!browser')
library;

import 'dart:io' as io;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';
import 'package:rive_native/rive_native.dart' as rive;

import 'src/headless_support.dart';

/// Pixel-level tests for the panel/surface compositing path with real `.riv`
/// content rendered by the Rive Renderer (headless Metal): painter draw
/// order, background clear, and each [RenderResolution] policy on the
/// surface, including a panel laid out smaller than it is displayed (via
/// FittedBox).
///
/// Uses `rive_file_controller_test.riv`, whose artboards render
/// deterministically under [Fit.fill] (verified by pixel probe):
/// - `Artboard1`: dark grey `[49,49,49]` with a centered red square;
/// - `Artboard2`: solid red `[255,0,0]`.
///
/// Skipped when the native lib lacks the headless symbols (only
/// `./build.sh shared` without `flutter_runtime` exports them, macOS only).
void main() {
  const grey = [49, 49, 49, 255];
  const red = [255, 0, 0, 255];
  const green = [0, 255, 0, 255];

  late File file;

  setUpAll(() async {
    expect(await rive.RiveNative.init(), isTrue);
  });

  setUp(() async {
    final bytes =
        io.File('test/assets/rive_file_controller_test.riv').readAsBytesSync();
    final decoded = await File.decode(bytes, riveFactory: Factory.rive);
    expect(decoded, isNotNull);
    file = decoded!;
    addTearDown(file.dispose);
  });

  RiveWidgetController controllerFor(String artboardName) {
    final controller = RiveWidgetController(
      file,
      artboardSelector: ArtboardSelector.byName(artboardName),
    );
    addTearDown(controller.dispose);
    return controller;
  }

  void setDpr(WidgetTester tester, double dpr) {
    tester.view.devicePixelRatio = dpr;
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  /// The panel's texture, via its internal [RiveSurface]'s public handle.
  rive.RenderTexture textureOf(WidgetTester tester) => tester
      .widget<RiveSurface>(find.byType(RiveSurface))
      .sharedTexture
      .texture;

  Future<Uint8List> readPixels(
          WidgetTester tester, rive.RenderTexture texture) async =>
      (await tester.runAsync(() async {
        final image = await texture.toImage();
        final data =
            await image.toByteData(format: ui.ImageByteFormat.rawStraightRgba);
        return data!.buffer.asUint8List();
      }))!;

  List<int> rgbaAt(Uint8List pixels, int width, int x, int y) {
    final i = (y * width + x) * 4;
    return [pixels[i], pixels[i + 1], pixels[i + 2], pixels[i + 3]];
  }

  /// Settle allocation/first paint, then advance fixed 16 ms frames so any
  /// state-machine animation stays deterministic.
  Future<void> pumpSettled(WidgetTester tester, Widget widget) async {
    await tester.pumpWidget(
      Directionality(textDirection: TextDirection.ltr, child: widget),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 16));
  }

  /// Unmount so the panel's shared ticker is disposed before the test ends.
  Future<void> unmount(WidgetTester tester) =>
      tester.pumpWidget(const SizedBox());

  group('headless RivePanel with .riv content', () {
    testWidgets('later drawOrder renders on top', (tester) async {
      Widget panel({required int artboard1Order}) => RivePanel(
            child: Stack(
              children: [
                Positioned.fill(
                  child: RiveWidget(
                    controller: controllerFor('Artboard1'),
                    fit: Fit.fill,
                    useSharedTexture: true,
                    drawOrder: artboard1Order,
                  ),
                ),
                Positioned.fill(
                  child: RiveWidget(
                    controller: controllerFor('Artboard2'),
                    fit: Fit.fill,
                    useSharedTexture: true,
                    drawOrder: 3 - artboard1Order,
                  ),
                ),
              ],
            ),
          );

      // Artboard1 (grey corners) above the solid-red Artboard2: the corner
      // shows Artboard1's grey.
      await pumpSettled(tester, panel(artboard1Order: 2));
      var texture = textureOf(tester);
      var pixels = await readPixels(tester, texture);
      expect(rgbaAt(pixels, texture.actualWidth, 24, 24), grey);

      // Swapped orders in a fresh panel: solid-red Artboard2 covers
      // Artboard1. (Each phase remounts deliberately — drawOrder is applied
      // when a painter attaches; SharedRenderTexture.painters is only sorted
      // in addPainter, so mutating drawOrder on a mounted widget does not
      // restack.)
      await unmount(tester);
      await pumpSettled(tester, panel(artboard1Order: 1));
      texture = textureOf(tester);
      pixels = await readPixels(tester, texture);
      expect(rgbaAt(pixels, texture.actualWidth, 24, 24), red);

      await unmount(tester);
    });

    testWidgets(
        'ancestor transform above the panel is composite-only '
        '(no double-apply in texture space)', (tester) async {
      setDpr(tester, 2.0);
      await pumpSettled(
        tester,
        Center(
          child: Transform(
            transform: Matrix4.diagonal3Values(2, 2, 1),
            alignment: Alignment.center,
            child: SizedBox(
              width: 100,
              height: 80,
              child: RivePanel(
                child: Row(
                  children: [
                    Expanded(
                      child: RiveWidget(
                        controller: controllerFor('Artboard2'),
                        fit: Fit.fill,
                        useSharedTexture: true,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      final texture = textureOf(tester);
      // The display policy folds the ancestor scale into the backing…
      expect(texture.actualWidth, 400);
      expect(texture.actualHeight, 320);
      // …but content is composed in panel-logical space: the artboard still
      // covers exactly the left half. If the ancestor transform reached the
      // widget→panel draw, the red region would span the full width.
      final pixels = await readPixels(tester, texture);
      expect(rgbaAt(pixels, 400, 100, 160), red);
      expect(rgbaAt(pixels, 400, 300, 160)[3], 0);

      await unmount(tester);
    });

    testWidgets('background clear shows where artboards do not cover',
        (tester) async {
      await pumpSettled(
        tester,
        RivePanel(
          backgroundColor: const Color(0xFF00FF00),
          child: Row(
            children: [
              Expanded(
                child: RiveWidget(
                  controller: controllerFor('Artboard2'),
                  fit: Fit.fill,
                  useSharedTexture: true,
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );

      final texture = textureOf(tester);
      final (w, h) = (texture.actualWidth, texture.actualHeight);
      final pixels = await readPixels(tester, texture);
      // Left half: the solid-red artboard; right half: the clear color.
      expect(rgbaAt(pixels, w, w ~/ 4, h ~/ 2), red);
      expect(rgbaAt(pixels, w, (w * 3) ~/ 4, h ~/ 2), green);

      await unmount(tester);
    });
  }, skip: headlessRendererSupported ? false : headlessSkipReason);

  group('headless RiveSurface with .riv content', () {
    /// Surface laid out at 100×80 logical, displayed at 400×320 via
    /// FittedBox (4× upscale). The artboard paints into the surface's shared
    /// texture from a sibling widget.
    Widget fittedHost(SharedRenderTexture shared,
            {required RenderResolution resolution}) =>
        Center(
          child: SizedBox(
            width: 400,
            height: 320,
            child: FittedBox(
              child: SizedBox(
                width: 100,
                height: 80,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: RiveSurface(
                        sharedTexture: shared,
                        renderResolution: resolution,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RiveWidget(
                            controller: controllerFor('Artboard2'),
                            fit: Fit.fill,
                            sharedTexture: shared,
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

    for (final (description, resolution, expectedWidth, expectedHeight) in [
      (
        'display policy allocates the display footprint',
        const RenderResolution.display(),
        800,
        640,
      ),
      (
        'layout policy keeps the layout footprint',
        const RenderResolution.layout(),
        200,
        160,
      ),
      (
        'fixed policy allocates exactly the requested pixels',
        const RenderResolution.fixed(64, 32),
        64,
        32,
      ),
    ]) {
      testWidgets(description, (tester) async {
        setDpr(tester, 2.0);
        final shared = SharedRenderTexture.create();
        addTearDown(shared.dispose);

        await pumpSettled(tester, fittedHost(shared, resolution: resolution));

        expect(shared.texture.actualWidth, expectedWidth);
        expect(shared.texture.actualHeight, expectedHeight);

        // The same logical content fills the backing whatever policy
        // allocated it: left half is the solid-red artboard, right half the
        // transparent clear color.
        final pixels = await readPixels(tester, shared.texture);
        expect(
          rgbaAt(
              pixels, expectedWidth, expectedWidth ~/ 4, expectedHeight ~/ 2),
          red,
          reason: 'left half under $resolution',
        );
        expect(
          rgbaAt(pixels, expectedWidth, (expectedWidth * 3) ~/ 4,
              expectedHeight ~/ 2)[3],
          0,
          reason: 'right half stays clear under $resolution',
        );

        await unmount(tester);
      });
    }
  }, skip: headlessRendererSupported ? false : headlessSkipReason);
}
