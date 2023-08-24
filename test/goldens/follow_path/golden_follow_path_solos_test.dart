import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

import '../../src/utils.dart';
import '../golden_comparator.dart';

void main() {
  group('Golden - follow path solo tests', () {
    testWidgets('Follow path over time', (WidgetTester tester) async {
      final riveBytes = loadFile('assets/follow_path_solos.riv');
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
        'follow_path_solos_01.png',
        reason: 'Follow path should work as animation advances',
      );

      artboard.advance(1.0, nested: true);
      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'follow_path_solos_02.png',
        reason: 'Follow path should work as animation advances',
      );

      artboard.advance(1.5, nested: true);
      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'follow_path_solos_03.png',
        reason: 'Follow path should work as animation advances',
      );

      artboard.advance(1.0, nested: true);
      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'follow_path_solos_04.png',
        reason: 'Follow path should work as animation advances',
      );
    });
  });
}
