import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart' as rive;

import 'src/utils.dart';

/// focus.riv (trays/testing/focus), Buttons artboard: four focusable
/// buttons in a row.

void main() {
  late rive.File riveFile;
  late FocusNode before;
  late FocusNode after;

  setUp(() async {
    riveFile = await decodeRiveFixture('test/assets/focus.riv');
    before = FocusNode(debugLabel: 'before');
    after = FocusNode(debugLabel: 'after');
  });

  tearDown(() {
    before.dispose();
    after.dispose();
    riveFile.dispose();
  });

  Widget app(rive.RiveWidgetController controller, {bool? keyboardFocus}) =>
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TextButton(
                focusNode: before,
                onPressed: () {},
                child: const Text('before'),
              ),
              SizedBox(
                width: 640,
                height: 360,
                child: keyboardFocus == null
                    ? rive.RiveWidget(controller: controller)
                    : rive.RiveWidget(
                        controller: controller,
                        keyboardFocus: keyboardFocus,
                      ),
              ),
              TextButton(
                focusNode: after,
                onPressed: () {},
                child: const Text('after'),
              ),
            ],
          ),
        ),
      );

  Future<void> tab(WidgetTester tester) async {
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
  }

  testWidgets('takes keyboard focus by default', (tester) async {
    final controller = rive.RiveWidgetController(
      riveFile,
      artboardSelector: const rive.ArtboardNamed('Buttons'),
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(app(controller));
    await tester.pump();
    before.requestFocus();
    await tester.pump();

    await tab(tester);
    expect(controller.stateMachine.focusState.hasFocus, isTrue);
    expect(after.hasFocus, isFalse);

    for (var i = 0; i < 4; i++) {
      await tab(tester);
    }
    expect(after.hasFocus, isTrue);
    expect(controller.stateMachine.focusState.hasFocus, isFalse);
  });

  testWidgets('keyboardFocus: false keeps the graphic out of traversal', (
    tester,
  ) async {
    final controller = rive.RiveWidgetController(
      riveFile,
      artboardSelector: const rive.ArtboardNamed('Buttons'),
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(app(controller, keyboardFocus: false));
    await tester.pump();
    before.requestFocus();
    await tester.pump();

    await tab(tester);
    expect(after.hasFocus, isTrue);
    expect(controller.stateMachine.focusState.hasFocus, isFalse);
  });
}
