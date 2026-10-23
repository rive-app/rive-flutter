import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

import 'src/utils.dart';

void main() {
  late File riveFile;
  // Settles after its intro, unlike the looping rewards.riv.
  late File settlingFile;

  setUp(() async {
    riveFile = await decodeRiveFixture('test/assets/rewards.riv');
    settlingFile = await decodeRiveFixture('test/assets/focus.riv');
  });

  tearDown(() {
    riveFile.dispose();
    settlingFile.dispose();
  });

  testWidgets('RiveWidget passes drawOptimization to its render object',
      (tester) async {
    final controller = RiveWidgetController(riveFile);
    addTearDown(controller.dispose);
    FlutterRiveRenderBox box() => tester.renderObject(
          find.byType(FlutterRiveRendererWidget),
        );

    await tester.pumpWidget(RiveWidget(controller: controller));
    expect(box().drawOptimization, DrawOptimization.drawWhenChanged);

    await tester.pumpWidget(RiveWidget(
      controller: controller,
      drawOptimization: DrawOptimization.alwaysDraw,
    ));
    expect(box().drawOptimization, DrawOptimization.alwaysDraw);
  });

  testWidgets('RivePanel passes drawOptimization to its shared texture',
      (tester) async {
    SharedRenderTexture? shared;
    Widget panel(DrawOptimization drawOptimization) => Directionality(
          textDirection: TextDirection.ltr,
          child: RivePanel(
            drawOptimization: drawOptimization,
            child: Builder(builder: (context) {
              shared = RiveSharedTexture.of(context);
              return const SizedBox();
            }),
          ),
        );

    await tester.pumpWidget(panel(DrawOptimization.alwaysDraw));
    expect(shared!.drawOptimization, DrawOptimization.alwaysDraw);

    await tester.pumpWidget(panel(DrawOptimization.drawWhenChanged));
    expect(shared!.drawOptimization, DrawOptimization.drawWhenChanged);
  });

  test('drawOptimization asserts on a shared texture', () {
    final controller = RiveWidgetController(riveFile);
    addTearDown(controller.dispose);

    expect(
      () => RiveWidget(
        controller: controller,
        useSharedTexture: true,
        drawOptimization: DrawOptimization.alwaysDraw,
      ),
      throwsAssertionError,
    );
  });

  testWidgets("RiveWidget's draw consumes the artboard's change",
      (tester) async {
    final controller = RiveWidgetController(settlingFile);
    addTearDown(controller.dispose);

    expect(controller.artboard.didChange, isTrue, reason: 'never drawn');

    await tester.pumpWidget(RiveWidget(controller: controller));
    expect(controller.artboard.didChange, isFalse);

    for (var i = 0; i < 100; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(controller.artboard.didChange, isFalse, reason: 'settled');
  });
}
