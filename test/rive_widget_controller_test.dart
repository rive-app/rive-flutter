import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart' as rive;

void main() {
  late rive.File riveFile;
  setUp(() async {
    final file = File('test/assets/rive_file_controller_test.riv');
    final bytes = await file.readAsBytes();
    final riveFactory = rive.Factory.flutter;
    riveFile = await rive.File.decode(
      bytes,
      riveFactory: riveFactory,
    ) as rive.File;
  });

  test('Rive File controller defaults', () async {
    final controller = rive.RiveWidgetController(riveFile);

    expect(controller.artboard.name, 'Artboard1');
    expect(controller.stateMachine.name, 'State Machine 1');
    expect(controller.active, true);
    expect(controller.cursor, MouseCursor.defer);
    expect(controller.hitTestBehavior, rive.RiveHitTestBehavior.opaque);
    expect(controller.alignment, Alignment.center);
    expect(controller.fit, rive.Fit.contain);
    expect(controller.isTickerActive, false);
    expect(controller.layoutScaleFactor, 1.0);
    expect(controller.size, Size.zero);
  });

  test('Rive File controller can specify specific artboard', () async {
    var controller = rive.RiveWidgetController(
      riveFile,
      artboardSelector: rive.ArtboardSelector.byDefault(),
    );
    expect(controller.artboard.name, 'Artboard1');
    controller = rive.RiveWidgetController(
      riveFile,
      artboardSelector: rive.ArtboardSelector.byName('Artboard2'),
    );
    expect(controller.artboard.name, 'Artboard2');
    controller = rive.RiveWidgetController(
      riveFile,
      artboardSelector: rive.ArtboardSelector.byIndex(1),
    );
    expect(controller.artboard.name, 'Artboard2');
  });

  test('Rive File controller can specify specific state machine', () async {
    var controller = rive.RiveWidgetController(
      riveFile,
      stateMachineSelector: rive.StateMachineSelector.byDefault(),
    );
    expect(controller.stateMachine.name, 'State Machine 1');
    controller = rive.RiveWidgetController(
      riveFile,
      stateMachineSelector: rive.StateMachineSelector.byName('State Machine 2'),
    );
    expect(controller.stateMachine.name, 'State Machine 2');
    controller = rive.RiveWidgetController(
      riveFile,
      stateMachineSelector: rive.StateMachineSelector.byIndex(1),
    );
    expect(controller.stateMachine.name, 'State Machine 2');
  });

  test('Rive File controller can update properties', () async {
    final controller = rive.RiveWidgetController(riveFile);
    controller.active = false;
    expect(controller.active, false);
    controller.cursor = MouseCursor.uncontrolled;
    expect(controller.cursor, MouseCursor.uncontrolled);
    controller.hitTestBehavior = rive.RiveHitTestBehavior.transparent;
    expect(controller.hitTestBehavior, rive.RiveHitTestBehavior.transparent);
    controller.alignment = Alignment.topLeft;
    expect(controller.alignment, Alignment.topLeft);
    controller.fit = rive.Fit.layout;
    expect(controller.fit, rive.Fit.layout);
    controller.layoutScaleFactor = 2.0;
    expect(controller.layoutScaleFactor, 2.0);
  });

  test('Continue to advance on active', () async {
    final controller = rive.RiveWidgetController(riveFile);
    final shouldContinue = controller.advance(1 / 60);
    expect(shouldContinue, true);
  });

  test('Stop advance on inactive', () async {
    final controller = rive.RiveWidgetController(riveFile);
    controller.active = false;
    final shouldContinue = controller.advance(1 / 60);
    expect(shouldContinue, false);
  });
}
