// On-device regression tests for behavior only the real native pipeline can
// exercise - Factory.rive needs a GPU context, and the deferred layer
// (attach/record/replay) does not exist on the headless unit-test path, so
// VM suites stay green when it breaks. The pixel tests here read textures
// back through the true deferred record/replay path.
//
// NOTE: keep every integration test in this ONE file. `flutter test
// integration_test -d macos` relaunches the app for each file, and the
// second launch deterministically fails on macOS desktop ("The log reader
// stopped unexpectedly"), failing the whole suite. One file, one launch.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/advanced/centaur_example/game_widget.dart';


/// A texture "holds content" when more than 1/[_contentDivisor] of its
/// pixels differ from the clear color - the same predicate polls and
/// asserts, so they can never diverge.
const _contentDivisor = 100;

/// Decodes an asset under [Factory.rive], the way every on-device test
/// needs it.
Future<File> _decodeAsset(String name) async {
  await RiveNative.init();
  final bytes = await rootBundle.load('assets/$name');
  final file = await File.decode(
    bytes.buffer.asUint8List(),
    riveFactory: Factory.rive,
  );
  expect(file, isNotNull, reason: '$name failed to decode');
  return file!;
}

/// Polls [texture] (via [findTexture], null while not ready) until more than
/// 1/[_contentDivisor] of its pixels differ from the background
/// [bgR]/[bgG]/[bgB], or 50 attempts pass. The deferred replay runs on a
/// worker thread, so content can land several frames after the widget
/// settles. Returns (contentPixels, sampledPixels).
Future<(int, int)> _pollForContent(
  WidgetTester tester,
  RenderTexture? Function() findTexture,
  int bgR,
  int bgG,
  int bgB,
) async {
  var contentPixels = 0;
  var sampledPixels = 0;
  for (var attempt = 0;
      attempt < 50 && contentPixels <= sampledPixels ~/ _contentDivisor;
      attempt++) {
    await tester.pump(const Duration(milliseconds: 100));
    final texture = findTexture();
    if (texture == null || !texture.isReady) continue;
    final counts = await tester.runAsync(() async {
      final image = await texture.toImage();
      final data = await image.toByteData();
      image.dispose();
      if (data == null) return (0, 0);
      final pixels = data.buffer.asUint8List();
      var content = 0;
      final total = pixels.length ~/ 4;
      // Past the threshold the verdict cannot change; stop scanning.
      final threshold = total ~/ _contentDivisor;
      for (var i = 0; i < pixels.length && content <= threshold; i += 4) {
        final r = pixels[i], g = pixels[i + 1], b = pixels[i + 2];
        final a = pixels[i + 3];
        if (a == 0) continue;
        // Anything that isn't the clear color counts as drawn content.
        if ((r - bgR).abs() + (g - bgG).abs() + (b - bgB).abs() > 24) {
          content++;
        }
      }
      return (content, total);
    });
    contentPixels = counts!.$1;
    sampledPixels = counts.$2;
  }
  return (contentPixels, sampledPixels);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Regression test for the shared-texture controller-swap leak in
  // [RiveWidget]. The bug only fires under [Factory.rive].
  //
  // Before the fix: the wrapping [SharedTextureArtboardWidgetPainter] was
  // constructed once via `late final` and held a [ChangeNotifier] listener on
  // the original controller forever. Swapping the controller without changing
  // the widget [Key] left the painter pointing at the old controller; once
  // the caller disposed it the next frame that reached into the painter (via
  // the shared-texture render path or an advance-request listener) crashed at
  // the FFI boundary with EXC_BAD_ACCESS / SIGABRT.
  //
  // After the fix: [didUpdateWidget] disposes and nulls `_painter` whenever
  // the controller swaps, so the next build rebinds to the new controller.
  testWidgets(
    'swapping the controller on a stable shared-texture RiveWidget does not '
    'leak the wrapping painter or crash when the old controller is disposed',
    (tester) async {
      final file = await _decodeAsset('rating.riv');

      var controller = RiveWidgetController(file);
      late void Function(VoidCallback) hostSetState;

      Widget tree() => MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  hostSetState = setState;
                  return RivePanel(
                    child: Center(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: RiveWidget(
                          controller: controller,
                          useSharedTexture: true,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );

      await tester.pumpWidget(tree());
      await tester.pump(const Duration(milliseconds: 100));

      // Swap the controller several times, disposing the previous one after
      // each swap. Without the fix the leaked painter still listens on the
      // disposed controller and the next frame's shared-texture pass crashes
      // at the native boundary.
      for (var i = 0; i < 5; i++) {
        final previous = controller;
        final next = RiveWidgetController(file);
        hostSetState(() {
          controller = next;
        });
        await tester.pump();
        previous.dispose();
        await tester.pump(const Duration(milliseconds: 100));
      }

      // If we got here the painter was correctly rebuilt on every swap.
      controller.dispose();
      file.dispose();
    },
  );

  // Regression test for the blank-panel bug: the shared paint pass must
  // attach the painters' recording session to the panel texture - a
  // sessionless texture warns and draws nothing under deferred rendering.
  testWidgets(
    'a RivePanel draws its shared-texture content on the native deferred path',
    (tester) async {
      final file = await _decodeAsset('rating.riv');
      final controller = RiveWidgetController(file);

      const bgR = 0x10, bgG = 0x20, bgB = 0x30;
      const background = Color.fromARGB(0xFF, bgR, bgG, bgB);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RivePanel(
              backgroundColor: background,
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: RiveWidget(
                    controller: controller,
                    useSharedTexture: true,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final texture = tester
          .widget<RiveSurface>(find.byType(RiveSurface))
          .sharedTexture
          .texture;

      final (contentPixels, sampledPixels) =
          await _pollForContent(tester, () => texture, bgR, bgG, bgB);

      expect(sampledPixels, greaterThan(0),
          reason: 'the panel texture never produced readable pixels');
      expect(
        contentPixels,
        greaterThan(sampledPixels ~/ _contentDivisor),
        reason: 'the RivePanel texture holds no artwork - the shared paint '
            'pass is not reaching the screen (blank-panel regression: the '
            'panel texture has no deferred session attached, so its frames '
            'never record or replay)',
      );

      controller.dispose();
      file.dispose();
    },
  );

  // Regression test for the own-texture custom-painter path: a
  // RenderTexturePainter subclass must surface the factory its content was
  // made with (riveFactory) so the render box can attach the recording
  // session. The centaur example is that pattern end to end: custom painter,
  // own texture, artboards drawn manually into the renderer.
  testWidgets(
    'the centaur example (custom RenderTexturePainter, own texture) draws '
    'content on the native deferred path',
    (tester) async {
      await RiveNative.init();

      await tester.pumpWidget(const CentaurGameWidget());

      // CentaurGame.background, the painter's clear color.
      const bgR = 0x6F, bgG = 0x8C, bgB = 0x9B;

      final (contentPixels, sampledPixels) = await _pollForContent(
        tester,
        // Exclude shared-texture painters: they extend RiveNativeRenderBox
        // but own an UnimplementedRenderTexture, so a future panel in this
        // tree would otherwise be polled instead of the centaur texture.
        () => tester.allRenderObjects
            .whereType<RiveNativeRenderBox>()
            .where((box) => box is! SharedTextureViewRenderObject)
            .firstOrNull
            ?.renderTexture,
        bgR,
        bgG,
        bgB,
      );

      expect(sampledPixels, greaterThan(0),
          reason: 'the centaur texture never produced readable pixels');
      expect(
        contentPixels,
        greaterThan(sampledPixels ~/ _contentDivisor),
        reason: 'the centaur texture holds no artwork - the custom painter '
            'is not surfacing riveFactory, so the render box never attaches '
            'the deferred recording session and the texture draws nothing',
      );
    },
  );

  testWidgets(
    'keyboard focus: Tab enters the graphic, walks it, Enter reaches the node, '
    'Tab leaves at the end',
    (tester) async {
      // focus.riv (trays/testing/focus), Buttons artboard: four focusable
      // buttons, each recording an Enter press in the host's lastPressed.
      final file = await _decodeAsset('focus.riv');
      final controller = RiveWidgetController(
        file,
        artboardSelector: const ArtboardNamed('Buttons'),
      );
      addTearDown(() {
        controller.dispose();
        file.dispose();
      });
      final before = FocusNode(debugLabel: 'before');
      final after = FocusNode(debugLabel: 'after');
      addTearDown(() {
        before.dispose();
        after.dispose();
      });

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TextButton(
                focusNode: before,
                onPressed: () {},
                child: const Text('before'),
              ),
              SizedBox(
                width: 640,
                height: 360,
                child: RiveWidget(controller: controller),
              ),
              TextButton(
                focusNode: after,
                onPressed: () {},
                child: const Text('after'),
              ),
            ],
          ),
        ),
      ));
      await tester.pump(const Duration(milliseconds: 100));
      expect(controller.stateMachine.hasFocusNodes, isTrue);

      before.requestFocus();
      await tester.pump();
      Future<void> tab() async {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump(const Duration(milliseconds: 50));
      }

      await tab();
      expect(controller.stateMachine.focusState.hasFocus, isTrue);
      expect(after.hasFocus, isFalse);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump(const Duration(milliseconds: 50));
      expect(controller.viewModelInstance!.string('lastPressed')!.value, '1');

      for (var i = 0; i < 3; i++) {
        await tab();
        expect(controller.stateMachine.focusState.hasFocus, isTrue);
      }
      await tab();
      expect(after.hasFocus, isTrue);
      expect(controller.stateMachine.focusState.hasFocus, isFalse);
    },
  );
}
