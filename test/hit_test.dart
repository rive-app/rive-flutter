import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

import 'src/utils.dart';

/// `hit_test_pass_through.riv` does not have any listeners. Only a
/// [RiveHitTestBehavior] of type `opaque` should block content underneath.
///
/// `hit_test_consumer.riv` has a listener that covers the entire artboard.
/// Only a [RiveHitTestBehavior] of type `transparent` should allow hits
/// for content underneath.

void main() {
  testWidgets('Hit test pass through artboard to widget beneath',
      (tester) async {
    final riveBytes = loadFile('assets/hit_test_pass_through.riv');
    final riveFile = RiveFile.import(riveBytes);

    int count = 0;
    await tester.pumpWidget(HitTestWidget(
      file: riveFile,
      behavior: RiveHitTestBehavior.translucent,
      onTap: () {
        count++;
      },
    ));

    await tester.pumpAndSettle();

    final titleFinder = find.text(textButtonTitle);
    await tester.tap(titleFinder);

    expect(count, 1);
  });

  testWidgets('Hit test blocked by default opaque behavior', (tester) async {
    final riveBytes = loadFile('assets/hit_test_pass_through.riv');
    final riveFile = RiveFile.import(riveBytes);

    int count = 0;
    await tester.pumpWidget(HitTestWidget(
      file: riveFile,
      behavior: RiveHitTestBehavior.opaque, // default
      onTap: () {
        count++;
      },
    ));

    await tester.pumpAndSettle();

    final titleFinder = find.text(textButtonTitle);
    await tester.tap(titleFinder);

    expect(count, 0);
  });

  testWidgets('Hit test artboard consume hit with opaque', (tester) async {
    final riveBytes = loadFile('assets/hit_test_consume.riv');
    final riveFile = RiveFile.import(riveBytes);

    int count = 0;
    await tester.pumpWidget(HitTestWidget(
      file: riveFile,
      behavior: RiveHitTestBehavior.opaque,
      onTap: () {
        count++;
      },
    ));
    await tester.pumpAndSettle();
    final titleFinder = find.text(textButtonTitle);
    await tester.tap(titleFinder);

    expect(count, 0);
  });

  testWidgets('Hit test artboard consume hit with translucent', (tester) async {
    final riveBytes = loadFile('assets/hit_test_consume.riv');
    final riveFile = RiveFile.import(riveBytes);

    int count = 0;
    await tester.pumpWidget(HitTestWidget(
      file: riveFile,
      behavior: RiveHitTestBehavior.translucent,
      onTap: () {
        count++;
      },
    ));
    await tester.pumpAndSettle();
    final titleFinder = find.text(textButtonTitle);
    await tester.tap(titleFinder);

    expect(count, 0);
  });

  testWidgets('Hit test artboard pass through transparent behavior',
      (tester) async {
    final riveBytes = loadFile('assets/hit_test_consume.riv');
    final riveFile = RiveFile.import(riveBytes);

    int count = 0;
    await tester.pumpWidget(HitTestWidget(
      file: riveFile,
      behavior: RiveHitTestBehavior.transparent,
      onTap: () {
        count++;
      },
    ));
    await tester.pumpAndSettle();
    final titleFinder = find.text(textButtonTitle);
    await tester.tap(titleFinder);

    expect(count, 1);
  });
}

const textButtonTitle = "Widget to click";

class HitTestWidget extends StatelessWidget {
  const HitTestWidget({
    required this.file,
    required this.onTap,
    required this.behavior,
    super.key,
  });

  final RiveFile file;
  final VoidCallback onTap;
  final RiveHitTestBehavior behavior;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 500,
          height: 500,
          child: Stack(
            children: [
              Center(
                child: GestureDetector(
                  onTap: onTap,
                  child: const Text(textButtonTitle),
                ),
              ),
              RiveAnimation.direct(
                file,
                stateMachines: const ['State Machine 1'],
                fit: BoxFit.cover,
                behavior: behavior,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
