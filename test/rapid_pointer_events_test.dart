import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart' as rive;

/// A no-op hit test target so we can build [HitTestEntry] instances to pass to
/// [rive.RiveWidgetController.pointerEvent]. The entry is not used by the
/// controller, but is required by the method signature.
class _NoopHitTestTarget implements HitTestTarget {
  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {}
}

void main() {
  late rive.File riveFile;

  setUp(() async {
    final file = File('test/assets/rapid_pointer_events.riv');
    final bytes = await file.readAsBytes();
    riveFile = await rive.File.decode(
      bytes,
      riveFactory: rive.Factory.flutter,
    ) as rive.File;
  });

  final entry = HitTestEntry(_NoopHitTestTarget());

  /// Builds a controller whose paint area matches the artboard bounds with
  /// [rive.Fit.contain], so a local pointer offset maps 1:1 to artboard space.
  rive.RiveWidgetController buildController() {
    final controller = rive.RiveWidgetController(
      riveFile,
    );
    final bounds = controller.artboard.bounds;
    controller.fit = rive.Fit.contain;
    controller.alignment = Alignment.center;
    // ignore: invalid_use_of_internal_member
    controller.updateSize(Size(bounds.width, bounds.height));
    return controller;
  }

  // Within the "onDown" listener's hit area for this artboard.
  const hitPosition = Offset(250, 250);

  void sendDownThenUp(rive.RiveWidgetController controller) {
    controller.pointerEvent(
      const PointerDownEvent(pointer: 1, position: hitPosition),
      entry,
    );
    controller.pointerEvent(
      const PointerUpEvent(pointer: 1, position: hitPosition),
      entry,
    );
  }

  test(
      'advances on pointer up/down so intermediate state is processed when '
      'down and up occur within the same frame', () async {
    final controller = buildController();
    final vmi = controller.dataBind(rive.DataBind.auto());
    final hasReached = vmi.boolean('hasReached');
    expect(hasReached, isNotNull,
        reason: 'The view model should expose a "hasReached" boolean.');

    controller.stateMachine.advanceAndApply(0);
    expect(hasReached!.value, false);

    // A pointer down (sets "isDown" true) immediately followed by a pointer up
    // (sets "isDown" false) without an intervening frame advance. Because the
    // controller advances on pointer up/down, the intermediate "isDown" state
    // is processed and the state machine enters the "toDown" state.
    sendDownThenUp(controller);
    controller.advance(0.016);

    expect(hasReached.value, true);
  });
}
