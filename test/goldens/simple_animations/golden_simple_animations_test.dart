import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

import '../../src/utils.dart';
import '../golden_comparator.dart';

void main() {
  group('Golden - simple linear animations', () {
    testWidgets('Play first animation found', (WidgetTester tester) async {
      final riveBytes = loadFile('assets/off_road_car.riv');
      final file = RiveFile.import(riveBytes);

      await tester.pumpWidget(RiveAnimation.direct(file));

      // Advance animation by one frame
      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'play_first_animation_found.png',
        reason: 'Animation should be advanced by one frame',
      );
    });

    testWidgets('Play provided animation controller',
        (WidgetTester tester) async {
      final riveBytes = loadFile('assets/off_road_car.riv');
      final file = RiveFile.import(riveBytes);

      final controller = SimpleAnimation('bouncing');

      late Artboard artboard;

      await tester.pumpWidget(RiveAnimation.direct(
        file,
        controllers: [controller],
        onInit: (a) {
          artboard = a;
        },
      ));

      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'play_provided_animation_controller_01.png',
        reason: 'Simple animation should be advanced by one frame',
      );

      controller.apply(artboard as RuntimeArtboard, 1);
      await tester.pump();
      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'play_provided_animation_controller_02.png',
        reason: 'Simple animation should be advanced by one second',
      );
    });

    testWidgets('Mixed animations', (WidgetTester tester) async {
      final riveBytes = loadFile('assets/off_road_car.riv');
      final file = RiveFile.import(riveBytes);

      final controllerIdle = SimpleAnimation('idle');
      final controllerBouncing = SimpleAnimation('bouncing');
      final controllerWipers = SimpleAnimation('windshield_wipers');

      late Artboard artboard;

      await tester.pumpWidget(RiveAnimation.direct(
        file,
        controllers: [controllerIdle, controllerBouncing, controllerWipers],
        onInit: (a) {
          artboard = a;
        },
      ));

      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'mixed_animations_01.png',
        reason: 'Mixed animations should be advanced by one frame',
      );

      controllerIdle.apply(artboard as RuntimeArtboard, 0.5);
      controllerBouncing.apply(artboard as RuntimeArtboard, 0.5);
      controllerWipers.apply(artboard as RuntimeArtboard, 0.5);
      await tester.pump();
      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'mixed_animations_02.png',
        reason: 'Mixed animations should be advanced by half a second',
      );
    });
  });
}
