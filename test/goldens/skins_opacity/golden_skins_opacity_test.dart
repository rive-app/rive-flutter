import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

import '../../src/utils.dart';
import '../golden_comparator.dart';

void main() {
  group('Golden - solo animations', () {
    testWidgets('Play first animation found', (WidgetTester tester) async {
      final riveBytes = loadFile('assets/skins_demo.riv');
      final file = RiveFile.import(riveBytes);
      late SMITrigger trigger;
      late Artboard artboard;
      late StateMachineController controller;

      final widget = RiveAnimation.direct(
        file,
        onInit: (a) {
          artboard = a;
          controller = StateMachineController.fromArtboard(
            artboard,
            'Motion',
          )!;
          controller.isActive = false;
          artboard.addController(controller);
          trigger = controller.getTriggerInput('Skin')!;
        },
      );

      await tester.pumpWidget(widget);
      trigger.fire();
      artboard.advance(0.5, nested: true);
      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'skins_opacity_01.png',
        reason: 'Skins (opacity/animation) should be swapped',
      );

      trigger.fire();
      artboard.advance(0.5, nested: true);
      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'skins_opacity_02.png',
        reason: 'Skins (opacity/animation) should be swapped',
      );

      trigger.fire();
      artboard.advance(0.5, nested: true);
      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'skins_opacity_03.png',
        reason: 'Skins (opacity/animation) should be swapped',
      );

      trigger.fire();
      artboard.advance(0.5, nested: true);
      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'skins_opacity_04.png',
        reason: 'Skins (opacity/animation) should be swapped',
      );

      trigger.fire();
      artboard.advance(0.5, nested: true);
      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'skins_opacity_05.png',
        reason: 'Skins (opacity/animation) should be swapped',
      );
    });
  });
}
