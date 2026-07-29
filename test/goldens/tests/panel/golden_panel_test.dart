@TestOn('!browser')
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';
import 'package:rive_native/rive_native.dart' as rive;

import '../../src/golden_comparator.dart';
import '../../src/panel_support.dart';
import '../../../src/headless_support.dart';

/// Golden coverage for the panel/surface compositing flow with the real Rive
/// Renderer: two *different* `.riv` files — `rewards.riv` (layout + data
/// binding + text) and `electrified_button_simple.riv` (state machine + text
/// runs + bone constraints) — rendered side by side into one shared texture
/// through the full `RivePanel` → `RiveSurface` → `SharedTextureView`
/// pipeline. This is the pixel regression net for that flow across future
/// runtime changes (draw order, shared frame clear/flush, widget→panel
/// transforms, `actualScale` content fitting).
///
/// Captured from the shared texture via `toImage()` (the test rasterizer
/// never sees texture contents); goldens live in `images/`. Skipped when the
/// native lib lacks the headless symbols.
void main() {
  setUpAll(() async {
    expect(await rive.RiveNative.init(), isTrue);
  });

  testWidgets('RivePanel composites multiple .riv files into one texture',
      (tester) async {
    final rewards = await decodeRiveFile(tester, 'test/assets/rewards.riv');
    final button = await decodeRiveFile(
        tester, 'test/assets/electrified_button_simple.riv');

    final rewardsController = RiveWidgetController(rewards);
    addTearDown(rewardsController.dispose);
    // The rewards scene is data-bound: bind its default view model like a
    // consumer would.
    rewardsController.dataBind(DataBind.auto());
    final buttonController = RiveWidgetController(button);
    addTearDown(buttonController.dispose);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: RivePanel(
          backgroundColor: const Color(0xFF202020),
          child: Row(
            children: [
              Expanded(
                child: RiveWidget(
                  controller: rewardsController,
                  useSharedTexture: true,
                  drawOrder: 1,
                ),
              ),
              Expanded(
                child: RiveWidget(
                  controller: buttonController,
                  useSharedTexture: true,
                  drawOrder: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // Fixed-duration pumps keep the state machines deterministic: settle
    // allocation/first paint (data binding and layout need a couple of
    // frames to apply), then advance fixed 16 ms frames.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 16));

    final image = await captureSharedTexture(tester);
    await expectGoldenMatches(image, 'rive_panel_multi_file.png');

    // Unmount before the test ends so the panel's shared ticker is disposed.
    await tester.pumpWidget(const SizedBox());
    // testWidgets' skip is bool-only (no reason string, unlike group's).
  }, skip: !headlessRendererSupported);
}
