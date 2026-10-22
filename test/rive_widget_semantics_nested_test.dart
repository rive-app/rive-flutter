import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart' as rive;

/// The Nested artboard of the semantics tray (example/assets/semantics.riv,
/// source trays/testing/semantics). Its `Hide or show` button flips `shown`,
/// which keys the Screen layout's display. Screen places Panel, which places
/// a ListItem, which places a Button, so `Open` sits three artboards below
/// the layout that hides it.
const _shown = [
  'Nested',
  'Hide or show',
  'Screen',
  'Panel',
  'Nested content',
  'Items',
  'Nested item',
  'Nested item',
  'Open',
];
const _hidden = ['Nested', 'Hide or show'];

void main() {
  late rive.File riveFile;
  setUp(() async {
    final bytes = await File('example/assets/semantics.riv').readAsBytes();
    riveFile = await rive.File.decode(
      bytes,
      riveFactory: rive.Factory.flutter,
    ) as rive.File;
  });

  tearDown(() => riveFile.dispose());

  Future<void> pumpFrames(WidgetTester tester, [int frames = 10]) async {
    for (var i = 0; i < frames; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  // Rive's nodes are children of one render object, so read the labels off
  // the semantics tree, in traversal order, rather than through a finder.
  List<String> labels(WidgetTester tester) {
    final result = <String>[];
    void visit(SemanticsNode node) {
      if (node.label.isNotEmpty) result.add(node.label);
      node.visitChildren((child) {
        visit(child);
        return true;
      });
    }

    visit(tester.getSemantics(find.byType(rive.RiveWidget)));
    return result;
  }

  SemanticsNode? findByLabel(WidgetTester tester, String label) {
    SemanticsNode? found;
    void visit(SemanticsNode node) {
      if (node.label == label) found ??= node;
      node.visitChildren((child) {
        visit(child);
        return found == null;
      });
    }

    visit(tester.getSemantics(find.byType(rive.RiveWidget)));
    return found;
  }

  testWidgets('showing a hidden layout restores nested artboard semantics',
      (tester) async {
    final handle = tester.ensureSemantics();
    final controller = rive.RiveWidgetController(
      riveFile,
      artboardSelector: rive.ArtboardSelector.byName('Nested'),
    );
    final shown = controller.viewModelInstance!.boolean('shown')!;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 600,
          height: 640,
          child: rive.RiveWidget(
            controller: controller,
            semantics: rive.RiveSemantics.enabled,
          ),
        ),
      ),
    ));
    await pumpFrames(tester);
    expect(labels(tester), _shown);

    for (var cycle = 0; cycle < 3; cycle++) {
      shown.value = false;
      await pumpFrames(tester);
      expect(labels(tester), _hidden, reason: 'hide $cycle');

      shown.value = true;
      await pumpFrames(tester);
      expect(labels(tester), _shown, reason: 'show $cycle');
    }

    controller.dispose();
    handle.dispose();
  });

  testWidgets('a semantic tap on the button hides and shows the layout',
      (tester) async {
    final handle = tester.ensureSemantics();
    final controller = rive.RiveWidgetController(
      riveFile,
      artboardSelector: rive.ArtboardSelector.byName('Nested'),
    );
    final shown = controller.viewModelInstance!.boolean('shown')!;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 600,
          height: 640,
          child: rive.RiveWidget(
            controller: controller,
            semantics: rive.RiveSemantics.enabled,
          ),
        ),
      ),
    ));
    await pumpFrames(tester);

    final owner = tester
        .renderObject(find.byType(rive.RiveWidget))
        .owner!
        .semanticsOwner!;
    Future<void> tapToggle() async {
      owner.performAction(
          findByLabel(tester, 'Hide or show')!.id, SemanticsAction.tap);
      await pumpFrames(tester);
    }

    await tapToggle();
    expect(shown.value, isFalse);
    expect(labels(tester), _hidden);

    await tapToggle();
    expect(shown.value, isTrue);
    expect(labels(tester), _shown);

    // The restored nested button still takes actions.
    expect(findByLabel(tester, 'Open')!.getSemanticsData().hasAction(
        SemanticsAction.tap), isTrue);

    controller.dispose();
    handle.dispose();
  });
}
