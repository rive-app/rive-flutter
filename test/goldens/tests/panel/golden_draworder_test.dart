@TestOn('!browser')
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';
import 'package:rive_native/rive_native.dart' as rive;

import '../../src/golden_comparator.dart';
import '../../src/panel_support.dart';
import '../../../src/headless_support.dart';

/// Golden coverage for shared-texture painter stacking: three overlapping
/// panes stepping diagonally through one `RivePanel`, rendered by the real
/// Rive Renderer (headless Metal). Uses `rive_file_controller_test.riv`
/// (static artboards — `Artboard1` dark grey with a centered red square,
/// `Artboard2` solid red) so captures are deterministic regardless of how
/// many frames have been pumped, which lets the runtime-restack test assert
/// against the same goldens as the static-orderings tests.
///
/// Three orderings share two goldens:
/// - explicit `drawOrder` reversing widget order → `_explicit` golden;
/// - no `drawOrder` (all default) → widget-tree order → `_widget_order`
///   golden;
/// - mounted with ascending orders (visually identical to `_widget_order`),
///   then swapped by rebuild alone — must converge on `_explicit`. This is
///   the pixel regression lock for drawOrder changes being ignored until
///   remount.
void main() {
  setUpAll(() async {
    expect(await rive.RiveNative.init(), isTrue);
  });

  Future<List<RiveWidgetController>> controllers(WidgetTester tester) async {
    final file = await decodeRiveFile(
        tester, 'test/assets/rive_file_controller_test.riv');
    RiveWidgetController controllerFor(String artboard) {
      final controller = RiveWidgetController(
        file,
        artboardSelector: ArtboardSelector.byName(artboard),
      );
      addTearDown(controller.dispose);
      return controller;
    }

    return [
      for (final artboard in ['Artboard1', 'Artboard2', 'Artboard1'])
        controllerFor(artboard)
    ];
  }

  // 140×140 panes stepping diagonally through a 260×260 panel. Every pane
  // overlaps the next, and (120..140)² is covered by all three, so any
  // stacking change is visible.
  const paneRects = [
    Rect.fromLTWH(0, 0, 140, 140),
    Rect.fromLTWH(60, 60, 140, 140),
    Rect.fromLTWH(120, 120, 140, 140),
  ];

  /// Panes are listed in [paneRects] order (top-left first). A null in
  /// [drawOrders] omits the parameter, exercising the default.
  Widget panel(List<RiveWidgetController> controllers, List<int?> drawOrders) {
    Widget pane(int i) {
      final order = drawOrders[i];
      return Positioned.fromRect(
        rect: paneRects[i],
        child: order == null
            ? RiveWidget(
                controller: controllers[i],
                fit: Fit.fill,
                useSharedTexture: true,
              )
            : RiveWidget(
                controller: controllers[i],
                fit: Fit.fill,
                useSharedTexture: true,
                drawOrder: order,
              ),
      );
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: SizedBox(
          width: 260,
          height: 260,
          child: RivePanel(
            backgroundColor: const Color(0xFF202020),
            child: Stack(children: [for (var i = 0; i < 3; i++) pane(i)]),
          ),
        ),
      ),
    );
  }

  /// Settle allocation/first paint with fixed-duration pumps (the content is
  /// static, but keep captures frame-schedule independent anyway).
  Future<void> pumpSettled(WidgetTester tester, Widget widget) async {
    await tester.pumpWidget(widget);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 16));
  }

  /// dpr 1 keeps the goldens at the panel's logical 260×260.
  void useDpr1(WidgetTester tester) {
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> unmount(WidgetTester tester) =>
      tester.pumpWidget(const SizedBox());

  testWidgets('explicit drawOrder beats widget order', (tester) async {
    useDpr1(tester);
    // The tree lists the top pane FIRST: if stacking followed widget order
    // the bottom-right pane would cover the others; drawOrder must win.
    await pumpSettled(tester, panel(await controllers(tester), [3, 2, 1]));

    await expectGoldenMatches(await captureSharedTexture(tester),
        'rive_panel_draworder_explicit.png');

    await unmount(tester);
  }, skip: !headlessRendererSupported);

  testWidgets('unspecified drawOrder stacks in widget-tree order',
      (tester) async {
    useDpr1(tester);
    // All panes at the default drawOrder: the tie must resolve to
    // widget-tree order (later siblings on top), like Flutter's own
    // painting — and stay there across re-sorts.
    await pumpSettled(
        tester, panel(await controllers(tester), [null, null, null]));

    await expectGoldenMatches(await captureSharedTexture(tester),
        'rive_panel_draworder_widget_order.png');

    await unmount(tester);
  }, skip: !headlessRendererSupported);

  testWidgets(
      'changing drawOrder on mounted widgets restacks to match the '
      'explicit golden', (tester) async {
    useDpr1(tester);
    final panes = await controllers(tester);

    // Ascending orders paint in tree order — visually identical to the
    // widget-order golden.
    await pumpSettled(tester, panel(panes, [1, 2, 3]));
    final mounted = tester
        .renderObjectList<SharedTextureViewRenderObject>(
            find.byType(SharedTextureViewRenderer))
        .first;
    await expectGoldenMatches(await captureSharedTexture(tester),
        'rive_panel_draworder_widget_order.png');

    // Swap to the explicit ordering by rebuild alone — same elements, no
    // remount — and the pixels must converge on the explicit golden.
    // (Regression: drawOrder used to be applied only in addPainter, so the
    // stacking silently stayed as mounted.)
    await pumpSettled(tester, panel(panes, [3, 2, 1]));
    expect(
      tester
          .renderObjectList<SharedTextureViewRenderObject>(
              find.byType(SharedTextureViewRenderer))
          .first,
      same(mounted),
      reason: 'the swap must reuse the mounted render objects — a remount '
          'would exercise the attach path instead of the runtime one',
    );
    await expectGoldenMatches(await captureSharedTexture(tester),
        'rive_panel_draworder_explicit.png');

    await unmount(tester);
  }, skip: !headlessRendererSupported);
}
