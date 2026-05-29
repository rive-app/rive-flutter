import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive_native/rive_native.dart' as rive;

/// Lightweight [rive.RenderTexture] stub so we can construct a
/// [rive.RiveNativeRenderBox] in a unit test. None of these members are
/// exercised by the scale-derivation code under test.
base class _FakeRenderTexture extends rive.RenderTexture {
  @override
  rive.Renderer get renderer => throw UnimplementedError();
  @override
  int get textureId => -1;
  @override
  dynamic get nativeTexture => null;
  @override
  int get actualWidth => 0;
  @override
  int get actualHeight => 0;
  @override
  bool get isReady => false;
  @override
  bool get isDisposed => false;
  @override
  bool clear(Color color, [bool write = true]) => true;
  @override
  bool flush(double devicePixelRatio) => true;
  @override
  bool needsResize(int width, int height) => false;
  @override
  Future<void> makeRenderTexture(int width, int height) async {}
  @override
  Future<ui.Image> toImage() => throw UnimplementedError();
  @override
  Widget widget({rive.RenderTexturePainter? painter, Key? key}) =>
      SizedBox.shrink(key: key);
  @override
  void dispose() {}
}

/// Concrete [rive.RiveNativeRenderBox] for tests. The base class is abstract
/// only because the production subclasses customise texture allocation;
/// the scale-derivation block in `paint()` lives on the base class itself,
/// so a minimal subclass suffices.
class _TestRiveNativeRenderBox extends rive.RiveNativeRenderBox {
  _TestRiveNativeRenderBox(super.renderTexture);
}

class _TestRiveNativeView extends LeafRenderObjectWidget {
  const _TestRiveNativeView({required this.renderTexture});

  final rive.RenderTexture renderTexture;

  @override
  _TestRiveNativeRenderBox createRenderObject(BuildContext context) =>
      _TestRiveNativeRenderBox(renderTexture);
}

/// Pumps a tree where the rive render box sits inside an optional
/// [wrapper] (e.g. `Transform.rotate`). Returns the live render object so
/// tests can read its captured transform scales.
Future<_TestRiveNativeRenderBox> _pump(
  WidgetTester tester, {
  required double dpr,
  Widget Function(Widget child)? wrapper,
}) async {
  Widget rive = _TestRiveNativeView(renderTexture: _FakeRenderTexture());
  rive = SizedBox(width: 200, height: 200, child: rive);
  if (wrapper != null) rive = wrapper(rive);

  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(devicePixelRatio: dpr),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: rive),
      ),
    ),
  );

  final ro = tester.renderObject<_TestRiveNativeRenderBox>(
    find.byType(_TestRiveNativeView),
  );
  // The scale-derivation block in paint() only runs when
  // _markNeedsLayoutCalled is set. The framework doesn't call
  // markNeedsLayout() during initial layout, so we trigger it explicitly
  // and pump again so the derivation runs against the laid-out tree.
  ro.markNeedsLayout();
  await tester.pump();
  return ro;
}

void main() {
  group('RiveNativeRenderBox.paint() — desiredTransform*Scale derivation', () {
    testWidgets('no ancestor transform — scales are 1', (tester) async {
      final ro = await _pump(tester, dpr: 1.0);

      expect(ro.desiredTransformWidthScale, closeTo(1.0, 1e-6));
      expect(ro.desiredTransformHeightScale, closeTo(1.0, 1e-6));
    });

    testWidgets('Transform.scale(2.0) ancestor — scales are 2', (tester) async {
      final ro = await _pump(
        tester,
        dpr: 1.0,
        wrapper: (child) => Transform.scale(scale: 2.0, child: child),
      );

      expect(ro.desiredTransformWidthScale, closeTo(2.0, 1e-6));
      expect(ro.desiredTransformHeightScale, closeTo(2.0, 1e-6));
    });

    // Regression: the previous implementation read entry(0,0) / entry(1,1) of
    // the widget-to-screen matrix. Under a 90° rotation those diagonal entries
    // are `S * cos(θ) = 0`, so the texture was sized at zero pixels wide and
    // Flutter upscaled the composite (visible blur at 90° / 270°).
    testWidgets(
      'Transform.rotate(π/2) ancestor — scales stay at 1, not |cos θ|=0',
      (tester) async {
        final ro = await _pump(
          tester,
          dpr: 1.0,
          wrapper: (child) =>
              Transform.rotate(angle: math.pi / 2, child: child),
        );

        expect(ro.desiredTransformWidthScale, closeTo(1.0, 1e-6));
        expect(ro.desiredTransformHeightScale, closeTo(1.0, 1e-6));
      },
    );

    // Regression: same root cause. At 45° the diagonal entries are
    // `cos(π/4) ≈ 0.707`, so the texture was sized at 70% of its actual
    // on-screen footprint — visible softening throughout the rotation.
    testWidgets(
      'Transform.rotate(π/4) ancestor — scales stay at 1, not |cos θ|≈0.707',
      (tester) async {
        final ro = await _pump(
          tester,
          dpr: 1.0,
          wrapper: (child) =>
              Transform.rotate(angle: math.pi / 4, child: child),
        );

        expect(ro.desiredTransformWidthScale, closeTo(1.0, 1e-6));
        expect(ro.desiredTransformHeightScale, closeTo(1.0, 1e-6));
      },
    );

    testWidgets(
      'Transform.flip(flipX) ancestor — mirror gives positive scale of 1 '
      '(matches the on-screen footprint magnitude)',
      (tester) async {
        final ro = await _pump(
          tester,
          dpr: 1.0,
          wrapper: (child) => Transform.flip(flipX: true, child: child),
        );

        expect(ro.desiredTransformWidthScale, closeTo(1.0, 1e-6));
        expect(ro.desiredTransformHeightScale, closeTo(1.0, 1e-6));
      },
    );

    testWidgets(
      'Combined rotation + scale — scales reflect the uniform scale factor',
      (tester) async {
        // 1.5× scale composed with a 30° rotation. The on-screen basis-vector
        // magnitudes equal the scale factor regardless of the rotation angle.
        final ro = await _pump(
          tester,
          dpr: 1.0,
          wrapper: (child) => Transform.rotate(
            angle: math.pi / 6,
            child: Transform.scale(scale: 1.5, child: child),
          ),
        );

        expect(ro.desiredTransformWidthScale, closeTo(1.5, 1e-6));
        expect(ro.desiredTransformHeightScale, closeTo(1.5, 1e-6));
      },
    );

    testWidgets(
      'Matrix4.skewX ancestor — height scale grows to sec(angle), width '
      'stays at 1',
      (tester) async {
        // skewX(angle) maps local (x, y) → (x + y·tan(angle), y). The
        // X basis vector (1, 0) stays at length 1; the Y basis vector
        // (0, 1) becomes (tan(angle), 1), length = sec(angle).
        const angle = 0.3;
        final ro = await _pump(
          tester,
          dpr: 1.0,
          wrapper: (child) => Transform(
            transform: Matrix4.skewX(angle),
            child: child,
          ),
        );

        expect(ro.desiredTransformWidthScale, closeTo(1.0, 1e-6));
        expect(
          ro.desiredTransformHeightScale,
          closeTo(1 / math.cos(angle), 1e-6),
        );
      },
    );

    testWidgets(
      'Non-uniform scale + rotation — basis-vector magnitudes track each axis '
      '(swap once rotated 90°)',
      (tester) async {
        // 3× horizontal, 2× vertical, rotated 90°. After the rotation the
        // original X basis vector points along screen-Y (length 3), and the
        // original Y basis vector points along screen-X (length 2). The
        // formula returns the magnitudes of the transformed basis vectors,
        // so widthScale=3 and heightScale=2 regardless of orientation.
        final ro = await _pump(
          tester,
          dpr: 1.0,
          wrapper: (child) => Transform.rotate(
            angle: math.pi / 2,
            child: Transform(
              transform: Matrix4.diagonal3Values(3.0, 2.0, 1.0),
              child: child,
            ),
          ),
        );

        expect(ro.desiredTransformWidthScale, closeTo(3.0, 1e-6));
        expect(ro.desiredTransformHeightScale, closeTo(2.0, 1e-6));
      },
    );
  });
}
