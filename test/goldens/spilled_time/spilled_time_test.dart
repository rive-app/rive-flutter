import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

import '../../src/utils.dart';
import '../golden_comparator.dart';

class RiveAnimationMatcher {
  final WidgetTester tester;
  final String name;
  var _matchCount = 0;

  RiveAnimationMatcher(this.tester, this.name);

  Future<void> match(String reason) async {
    await tester.pump();
    print('${name}_${_matchCount.toString().padLeft(2, '0')}.png');
    await expectGoldenMatches(
      find.byType(RiveAnimation),
      '${name}_${_matchCount.toString().padLeft(2, '0')}.png',
      reason: reason,
    );
    _matchCount++;
  }
}

void main() {
  group('Golden - spilled time test', () {
    testWidgets('Test with Spilled time', (WidgetTester tester) async {
      final matcher = RiveAnimationMatcher(tester, 'spilled_time');
      final riveBytes = loadFile('assets/spilled_time.riv');
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
            'State Machine 1',
          )!;
          controller.isActive = false;
          artboard.addController(controller);
          trigger = controller.getTriggerInput('Trigger 1')!;
        },
      );
      await tester.pumpWidget(widget);

      // first fire after fire just changes the state, this time gets lost
      // i suspect the "entry state" eats this time.
      trigger.fire();
      artboard.advance(0.5);
      await matcher.match('one shot & loop lines line up at left hand side');

      artboard.advance(0.25);
      await matcher.match('one shot & loop lines line up 25% across');

      artboard.advance(1.25);
      await matcher
          .match('one shot is finished at 100%, loop looped back to 50%');

      // we advance an extra time before trigger
      artboard.advance(0.1);
      await matcher.match('one shot stays at 100%, loop advanced to 60%');

      // once again advance after fire, the whole time gets lost
      // TODO: without the spilled time fix, the one shot animation
      // does advance, the loop does not. the fix might be the wrong
      // way around
      trigger.fire();
      artboard.advance(0.3);
      await matcher.match('one shot & loop lines line up at left hand side');

      artboard.advance(0.1);
      await matcher.match('top and bottom lines line up 10% across width');
    });

    testWidgets('Test with Spilled time overshoot',
        (WidgetTester tester) async {
      final matcher = RiveAnimationMatcher(tester, 'spilled_time_overshoot');
      final riveBytes = loadFile('assets/spilled_time.riv');
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
            'State Machine 1',
          )!;
          controller.isActive = false;
          artboard.addController(controller);
          trigger = controller.getTriggerInput('Trigger 1')!;
        },
      );
      await tester.pumpWidget(widget);

      trigger.fire();
      artboard.advance(0);
      await matcher.match('one shot & loop lines line up at left hand side');

      artboard.advance(1.5);
      await matcher.match('one shot gets stuck at 100% & loop advances to 50%');

      trigger.fire();
      artboard.advance(0.25);
      await matcher.match('one shot & loop reset to 0%');
    });

    testWidgets('Test with Spilled time exact', (WidgetTester tester) async {
      final matcher = RiveAnimationMatcher(tester, 'spilled_time_exact');
      final riveBytes = loadFile('assets/spilled_time.riv');
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
            'State Machine 1',
          )!;
          controller.isActive = false;
          artboard.addController(controller);
          trigger = controller.getTriggerInput('Trigger 1')!;
        },
      );
      await tester.pumpWidget(widget);

      trigger.fire();
      artboard.advance(0);
      await matcher.match('one shot & loop lines line up at left hand side');

      artboard.advance(1);
      await matcher.match('one shot & loop get to 100%');

      trigger.fire();
      artboard.advance(0.25);
      await matcher.match('one shot resets to 0% & loop reset to 0%');
    });
  });
}
