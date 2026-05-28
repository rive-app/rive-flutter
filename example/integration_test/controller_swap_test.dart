// Regression test for the shared-texture controller-swap leak in
// [RiveWidget]. Runs as an integration test because the bug only fires under
// [Factory.rive], which requires a real GPU context — the rive_flutter unit
// tests run headless under [Factory.flutter] and the shared-texture branch
// errors out under that factory.
//
// Before the fix: the wrapping [SharedTextureArtboardWidgetPainter] was
// constructed once via `late final` and held a [ChangeNotifier] listener on
// the original controller forever. Swapping the controller without changing
// the widget [Key] left the painter pointing at the old controller; once the
// caller disposed it the next frame that reached into the painter (via the
// shared-texture render path or an advance-request listener) crashed at the
// FFI boundary with EXC_BAD_ACCESS / SIGABRT.
//
// After the fix: [didUpdateWidget] disposes and nulls `_painter` whenever
// the controller swaps, so the next build rebinds to the new controller.

// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rive/rive.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'swapping the controller on a stable shared-texture RiveWidget does not '
    'leak the wrapping painter or crash when the old controller is disposed',
    (tester) async {
      await RiveNative.init();

      final bytes = await rootBundle.load('assets/rating.riv');
      final file = await File.decode(
        bytes.buffer.asUint8List(),
        riveFactory: Factory.rive,
      );
      expect(file, isNotNull, reason: 'rating.riv failed to decode');

      var controller = RiveWidgetController(file!);
      late void Function(VoidCallback) hostSetState;

      Widget tree() => MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  hostSetState = setState;
                  return RivePanel(
                    child: Center(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: RiveWidget(
                          controller: controller,
                          useSharedTexture: true,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );

      await tester.pumpWidget(tree());
      await tester.pump(const Duration(milliseconds: 100));

      // Swap the controller several times, disposing the previous one after
      // each swap. Without the fix the leaked painter still listens on the
      // disposed controller and the next frame's shared-texture pass crashes
      // at the native boundary.
      for (var i = 0; i < 5; i++) {
        final previous = controller;
        final next = RiveWidgetController(file);
        hostSetState(() {
          controller = next;
        });
        await tester.pump();
        previous.dispose();
        await tester.pump(const Duration(milliseconds: 100));
      }

      // If we got here the painter was correctly rebuilt on every swap.
      controller.dispose();
      file.dispose();
    },
  );
}
