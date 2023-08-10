import 'package:flutter_test/flutter_test.dart';
import 'package:rive/math.dart';
import 'package:rive/rive.dart';

import '../../src/utils.dart';
import '../golden_comparator.dart';

void main() {
  group('Golden - Text tests', () {
    testWidgets('Text runs update with bone constraints',
        (WidgetTester tester) async {
      final riveBytes = loadFile('assets/electrified_button_simple.riv');
      final file = RiveFile.import(riveBytes);
      late Artboard artboard;
      late StateMachineController controller;
      late TextValueRun textRun;

      final widget = RiveAnimation.direct(
        file,
        useArtboardSize: true,
        onInit: (a) {
          artboard = a;
          controller = artboard.stateMachineByName('button')!;
          artboard.addController(controller);
          textRun = artboard.component<TextValueRun>('name')!;
        },
      );
      await tester.pumpWidget(widget);
      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'text_bones_constraint_01.png',
        reason: 'First frame should match golden',
      );

      controller.pointerMove(Vec2D.fromValues(250, 250));
      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'text_bones_constraint_02.png',
        reason:
            'Hovering should trigger a different animation for text and button',
      );

      textRun.text = 'short';
      await tester.pump();
      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'text_bones_constraint_03.png',
        reason: 'Short text runs should update with bone constraints',
      );

      textRun.text = 'Extremely long text. The longest.';
      await tester.pump();
      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'text_bones_constraint_04.png',
        reason: 'Long text runs should update with bone constraints',
      );
    });
  });
}
