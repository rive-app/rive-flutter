import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart' as rive;

import 'src/headless_support.dart';

/// Semantics must work through the shared-texture path (`useSharedTexture`,
/// which renders via a proxy painter and a shared ticker), not only the
/// regular RiveArtboardWidget path. RiveWidget wraps both paths in the same
/// RiveSemanticsWidget backed by the controller, and the shared painter's
/// paint drives the controller's advance - so the tree should populate and
/// actions should still advance the controller.
///
/// Shared textures require Factory.rive (headless render on macOS).
void main() {
  SemanticsNode? findByLabel(SemanticsNode node, String label) {
    if (node.label == label) return node;
    SemanticsNode? result;
    node.visitChildren((child) {
      result ??= findByLabel(child, label);
      return result == null;
    });
    return result;
  }

  setUpAll(() async {
    expect(await rive.RiveNative.init(), isTrue);
  });

  group('shared-texture semantics', () {
    testWidgets('semantics populate and actions work over a shared texture', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      final bytes = File('test/assets/tabtest.riv').readAsBytesSync();
      final file = (await rive.File.decode(
        bytes,
        riveFactory: rive.Factory.rive,
      ))!;
      addTearDown(file.dispose);

      final controller = rive.RiveWidgetController(file);
      addTearDown(controller.dispose);
      final vmi = controller.viewModelInstance!;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Semantics(
              container: true,
              label: 'probe',
              child: rive.RivePanel(
                child: SizedBox(
                  width: 500,
                  height: 400,
                  child: rive.RiveWidget(
                    controller: controller,
                    useSharedTexture: true,
                    semantics: rive.RiveSemantics.enabled,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      final probe = tester.getSemantics(find.bySemanticsLabel('probe'));
      final parentTab = findByLabel(probe, 'Parent');
      expect(
        parentTab,
        isNotNull,
        reason: 'Rive semantic nodes must appear through the shared texture',
      );

      expect(vmi.enumerator('enumProperty')?.value, 'All');
      tester
          .renderObject(find.byType(rive.RiveWidget))
          .owner!
          .semanticsOwner!
          .performAction(parentTab!.id, SemanticsAction.tap);
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(
        vmi.enumerator('enumProperty')?.value,
        'Parent',
        reason:
            'a screen reader tap must advance the controller even '
            'through the shared-texture proxy painter',
      );

      // Unmount so the panel's shared ticker disposes before the test ends.
      await tester.pumpWidget(const SizedBox());
      handle.dispose();
    });
  }, skip: headlessRendererSupported ? false : headlessSkipReason);
}
