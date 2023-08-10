import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

import '../../src/utils.dart';
import '../golden_comparator.dart';

void main() {
  /// Tests all rivs in the `test/assets/batch_rive` directory
  group('Golden - Batch tests riv files', () {
    List<FileTesterWrapper> riveFiles = [];

    setUpAll(() {
      // Read all files in the batch directory to be tested.
      riveFiles = batchRiveFilesToTest();
    });

    testWidgets('Animation default state machine render as expected',
        (WidgetTester tester) async {
      for (final file in riveFiles) {
        final riveFile =
            RiveFile.import(ByteData.sublistView(file.file.readAsBytesSync()));
        final fileName = file.fileName;
        late Artboard artboard;

        // TODO: change this once the default behavior is to play
        // the default state machine. Adding this for now as it ensures we
        // do not have to update tests when the default behavior changes.
        final defaultStateMachineName =
            riveFile.mainArtboard.defaultStateMachine?.name ??
                riveFile.mainArtboard.stateMachines.first.name;

        await tester.pumpWidget(
          RiveAnimation.direct(
            riveFile,
            stateMachines: [defaultStateMachineName],
            onInit: (a) {
              artboard = a;
            },
          ),
        );

        // Render first frame of animation
        await tester.pump();
        await expectGoldenMatches(
          find.byType(RiveAnimation),
          '$fileName-01.png',
          reason: 'Animation with filename: $fileName should render correctly',
        );

        // Advance animation by a three quarters of a second
        artboard.advance(0.75, nested: true);
        await tester.pump();
        await expectGoldenMatches(
          find.byType(RiveAnimation),
          '$fileName-02.png',
          reason: 'Animation with filename: $fileName should render correctly',
        );

        // Advance animation by a two seconds
        artboard.advance(2, nested: true);
        await tester.pump();
        await expectGoldenMatches(
          find.byType(RiveAnimation),
          '$fileName-03.png',
          reason: 'Animation with filename: $fileName should render correctly',
        );
      }
    });
  });
}
