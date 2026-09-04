import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart' as rive;

/// tabtest.riv - Row with three tabs (All / Parent / Child). Tapping a tab
/// sets the view model's enumProperty to the tab's name.

SemanticsNode? _findByLabel(SemanticsNode node, String label) {
  if (node.label == label) return node;
  SemanticsNode? result;
  node.visitChildren((child) {
    result ??= _findByLabel(child, label);
    return result == null;
  });
  return result;
}

const _probeLabel = 'rive-probe';

void main() {
  late rive.File riveFile;
  setUp(() async {
    final bytes = await File('test/assets/tabtest.riv').readAsBytes();
    riveFile = await rive.File.decode(
      bytes,
      riveFactory: rive.Factory.flutter,
    ) as rive.File;
  });

  Widget app(rive.RiveWidgetController controller,
          {rive.RiveSemantics semantics = rive.RiveSemantics.disabled}) =>
      MaterialApp(
        home: Scaffold(
          body: Semantics(
            container: true,
            label: _probeLabel,
            child: SizedBox(
              width: 500,
              height: 400,
              child: rive.RiveWidget(
                controller: controller,
                semantics: semantics,
              ),
            ),
          ),
        ),
      );

  SemanticsNode probeNode(WidgetTester tester) =>
      tester.getSemantics(find.bySemanticsLabel(_probeLabel));

  Future<void> pumpFrames(WidgetTester tester, [int frames = 10]) async {
    for (var i = 0; i < frames; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  testWidgets('semantics are off by default', (tester) async {
    final handle = tester.ensureSemantics();
    final controller = rive.RiveWidgetController(riveFile);

    await tester.pumpWidget(app(controller));
    await pumpFrames(tester);

    expect(_findByLabel(probeNode(tester), 'Parent'), isNull,
        reason: 'no Rive semantics without opting in');
    expect(controller.isSemanticsEnabled, isFalse,
        reason: 'zero overhead by default - tracking must stay off');

    controller.dispose();
    handle.dispose();
  });

  testWidgets('RiveSemantics.enabled exposes nodes and actions work',
      (tester) async {
    final handle = tester.ensureSemantics();
    final controller = rive.RiveWidgetController(riveFile);
    final vmi = controller.viewModelInstance!;

    await tester.pumpWidget(
        app(controller, semantics: rive.RiveSemantics.enabled));
    await pumpFrames(tester);

    final parentTab = _findByLabel(probeNode(tester), 'Parent');
    expect(parentTab, isNotNull,
        reason: 'Rive semantic nodes must be in the Flutter tree');

    expect(vmi.enumerator('enumProperty')?.value, 'All');

    tester
        .renderObject(find.byType(rive.RiveWidget))
        .owner!
        .semanticsOwner!
        .performAction(parentTab!.id, SemanticsAction.tap);
    await pumpFrames(tester, 5);

    expect(vmi.enumerator('enumProperty')?.value, 'Parent',
        reason: 'screen reader tap must drive the state machine');

    controller.dispose();
    handle.dispose();
  });

  // testWidgets runs with semantics enabled by default; turn that off so
  // the mid-test ensureSemantics() is the platform's "screen reader
  // connected" flip.
  testWidgets('RiveSemantics.auto stays off until the platform asks',
      semanticsEnabled: false, (tester) async {
    final controller = rive.RiveWidgetController(riveFile);

    // No SemanticsHandle yet - the platform has not requested semantics.
    await tester
        .pumpWidget(app(controller, semantics: rive.RiveSemantics.auto));
    await pumpFrames(tester);

    expect(controller.isSemanticsEnabled, isFalse,
        reason: 'auto must not track semantics before the platform asks');

    // A screen reader connects.
    final handle = tester.ensureSemantics();
    await pumpFrames(tester);

    expect(controller.isSemanticsEnabled, isTrue,
        reason: 'auto must activate when the platform requests semantics');
    expect(_findByLabel(probeNode(tester), 'Parent'), isNotNull,
        reason: 'Rive nodes must appear after activation');

    controller.dispose();
    handle.dispose();
  });

  testWidgets('RiveSemantics.auto activates immediately when already on',
      (tester) async {
    final handle = tester.ensureSemantics();
    final controller = rive.RiveWidgetController(riveFile);

    await tester
        .pumpWidget(app(controller, semantics: rive.RiveSemantics.auto));
    await pumpFrames(tester);

    expect(controller.isSemanticsEnabled, isTrue);
    expect(_findByLabel(probeNode(tester), 'Parent'), isNotNull);

    controller.dispose();
    handle.dispose();
  });

  testWidgets('switching auto to enabled with the platform off activates',
      semanticsEnabled: false, (tester) async {
    final controller = rive.RiveWidgetController(riveFile);

    await tester
        .pumpWidget(app(controller, semantics: rive.RiveSemantics.auto));
    await pumpFrames(tester);
    expect(controller.isSemanticsEnabled, isFalse,
        reason: 'sanity: auto waits while the platform is off');

    // Same controller, same widget position - only the mode changes.
    await tester
        .pumpWidget(app(controller, semantics: rive.RiveSemantics.enabled));
    await pumpFrames(tester);

    expect(controller.isSemanticsEnabled, isTrue,
        reason: 'enabled must activate immediately even when the previous '
            'mode was still waiting for the platform');

    controller.dispose();
  });

  testWidgets('semantics survive unmount/remount with a kept controller',
      (tester) async {
    final handle = tester.ensureSemantics();
    final controller = rive.RiveWidgetController(riveFile);

    await tester.pumpWidget(
        app(controller, semantics: rive.RiveSemantics.enabled));
    await pumpFrames(tester);
    expect(_findByLabel(probeNode(tester), 'Parent'), isNotNull,
        reason: 'sanity: populated on first mount');

    // Unmount; the controller (and its state machine) stays alive, as when
    // navigating away from a route and back.
    await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SizedBox.expand())));

    await tester.pumpWidget(
        app(controller, semantics: rive.RiveSemantics.enabled));
    await pumpFrames(tester);

    expect(_findByLabel(probeNode(tester), 'Parent'), isNotNull,
        reason: 'the semantic tree must survive widget teardown when the '
            'controller keeps its state machine');

    controller.dispose();
    handle.dispose();
  });
}
