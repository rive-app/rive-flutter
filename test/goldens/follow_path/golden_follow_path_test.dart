import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

import '../../src/utils.dart';
import '../golden_comparator.dart';

void main() {
  group('Golden - follow path tests', () {
    testWidgets('Follow path over time', (WidgetTester tester) async {
      final riveBytes = loadFile('assets/follow_path_shapes.riv');
      final file = RiveFile.import(riveBytes);
      late Artboard artboard;

      final widget = RiveAnimation.direct(
        file,
        stateMachines: const ['State Machine 1'],
        onInit: (a) {
          artboard = a;
        },
      );
      await tester.pumpWidget(widget);

      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'follow_path_over_time_01.png',
        reason: 'Follow path should work as animation advances',
      );

      artboard.advance(0.1, nested: true);
      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'follow_path_over_time_02.png',
        reason: 'Follow path should work as animation advances',
      );

      artboard.advance(0.1, nested: true);
      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'follow_path_over_time_03.png',
        reason: 'Follow path should work as animation advances',
      );

      artboard.advance(0.1, nested: true);
      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'follow_path_over_time_04.png',
        reason: 'Follow path should work as animation advances',
      );
    });
  });
}
