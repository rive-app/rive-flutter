import 'package:flutter_test/flutter_test.dart';
import 'package:rive/math.dart';
import 'package:rive/rive.dart';

import '../../src/utils.dart';
import '../golden_comparator.dart';

void main() {
  group('Golden - Joystick tests', () {
    // See: https://github.com/rive-app/rive/pull/5589
    testWidgets('Joystick handle source', (WidgetTester tester) async {
      final riveBytes = loadFile('assets/joystick_handle_source.riv');
      final file = RiveFile.import(riveBytes);
      late Artboard artboard;
      late StateMachineController controller;

      final widget = RiveAnimation.direct(
        file,
        useArtboardSize: true,
        onInit: (a) {
          artboard = a;
          controller = artboard.stateMachineByName('State Machine 1')!;
          artboard.addController(controller);
        },
      );
      await tester.pumpWidget(widget);
      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'joystick_handle_source_01.png',
        reason: 'Handle source on joystick should be updated by listeners',
      );

      controller.pointerMove(Vec2D.fromValues(85, 60));
      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'joystick_handle_source_02.png',
        reason: 'Handle source on joystick should be updated by listeners',
      );

      controller.pointerMove(Vec2D.fromValues(370, 65));
      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'joystick_handle_source_03.png',
        reason: 'Handle source on joystick should be updated by listeners',
      );

      artboard.advance(0.5, nested: true);
      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'joystick_handle_source_04.png',
        reason: 'Handle source on joystick should be updated by listeners'
            ' when advanding time',
      );
    });
  });
}
