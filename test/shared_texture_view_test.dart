import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';
import 'package:rive_native/rive_native.dart' as rive;

/// Records [transform] / [save] / [restore] calls so tests can assert on the
/// affine that [SharedTextureViewRenderObject] writes to the shared texture.
class _RecordingRenderer extends rive.Renderer {
  final List<List<double>> transforms = [];
  int saveCount = 0;
  int restoreCount = 0;

  @override
  void save() => saveCount++;

  @override
  void restore() => restoreCount++;

  @override
  void transform(rive.Mat2D matrix) {
    transforms.add([
      matrix[0],
      matrix[1],
      matrix[2],
      matrix[3],
      matrix[4],
      matrix[5],
    ]);
  }

  // Remaining members are unused by paintIntoSharedTexture.
  @override
  rive.Factory get riveFactory => throw UnimplementedError();
  @override
  void drawPath(rive.RenderPath path, rive.RenderPaint paint) {}
  @override
  void drawImage(
      rive.RenderImage image, ui.BlendMode blendMode, double opacity) {}
  @override
  void drawImageMesh(
      rive.RenderImage image,
      rive.VertexRenderBuffer vertices,
      rive.VertexRenderBuffer uvs,
      rive.IndexRenderBuffer indices,
      ui.BlendMode blendMode,
      double opacity) {}
  @override
  void drawText(rive.RenderText text, [rive.RenderPaint? paint]) {}
  @override
  void clipPath(rive.RenderPath path) {}
  @override
  void modulateOpacity(double opacity) {}
}

base class _FakeRenderTexture extends rive.RenderTexture {
  final _RecordingRenderer recording = _RecordingRenderer();

  @override
  rive.Renderer get renderer => recording;

  @override
  int get textureId => -1;
  @override
  dynamic get nativeTexture => null;
  @override
  int get actualWidth => 0;
  @override
  int get actualHeight => 0;
  @override
  bool get isReady => true;
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

/// No-op painter — the render object needs a non-null painter to satisfy the
/// widget contract, but paintIntoSharedTexture's matrix construction runs
/// before the painter is invoked, so its body doesn't matter for these tests.
final class _NoopPainter extends rive.RenderTexturePainter {
  @override
  Color get background => const Color(0x00000000);

  @override
  bool paint(rive.RenderTexture texture, double devicePixelRatio,
          Size size, double elapsedSeconds) =>
      false;
}

/// Builds a controlled tree where the panel marker and a single
/// [SharedTextureViewRenderer] are siblings under the same [Stack], the way
/// [RivePanel] arranges them. The caller decorates the rive widget via
/// [riveWrapper] (e.g. wraps it in a Transform.scale) to exercise different
/// ancestor configurations.
Future<SharedTextureViewRenderObject> _pumpHarness(
  WidgetTester tester, {
  required SharedRenderTexture shared,
  required _NoopPainter painter,
  required Rect panelRect,
  required Rect widgetRect,
  required double dpr,
  Widget Function(Widget child)? riveWrapper,
  Widget Function(Widget child)? outerWrapper,
}) async {
  Widget rive = SharedTextureViewRenderer(
    renderTexturePainter: painter,
    sharedTexture: shared,
    devicePixelRatio: dpr,
    drawOrder: 1,
  );
  if (riveWrapper != null) rive = riveWrapper(rive);

  Widget tree = SizedBox(
    width: 1000,
    height: 1000,
    child: Stack(
      children: [
        Positioned.fromRect(
          rect: panelRect,
          child: SizedBox.expand(key: shared.panelKey),
        ),
        Positioned.fromRect(rect: widgetRect, child: rive),
      ],
    ),
  );
  if (outerWrapper != null) tree = outerWrapper(tree);

  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(devicePixelRatio: dpr),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: tree),
      ),
    ),
  );

  return tester.renderObject<SharedTextureViewRenderObject>(
    find.byType(SharedTextureViewRenderer),
  );
}

/// Asserts the captured matrix equals [a, b, c, d, tx, ty] (Mat2D order)
/// within a small floating-point tolerance.
void _expectMatrix(List<double> actual, List<double> expected) {
  expect(actual, hasLength(6));
  for (var i = 0; i < 6; i++) {
    expect(actual[i], closeTo(expected[i], 1e-6),
        reason: 'Mat2D[$i] mismatch — got $actual, expected $expected');
  }
}

void main() {
  group('SharedTextureViewRenderObject.paintIntoSharedTexture', () {
    testWidgets(
      'no ancestor transform — translation is widget-relative-to-panel × dpr, '
      'scale is dpr',
      (tester) async {
        final shared = SharedRenderTexture(
          texture: _FakeRenderTexture(),
          devicePixelRatio: 2.0,
          backgroundColor: const Color(0x00000000),
          panelKey: GlobalKey(),
        );
        final painter = _NoopPainter();

        final ro = await _pumpHarness(
          tester,
          shared: shared,
          painter: painter,
          // Panel fills (0,0)-(800,600); widget sits at (50,100) inside it.
          panelRect: const Rect.fromLTWH(0, 0, 800, 600),
          widgetRect: const Rect.fromLTWH(50, 100, 200, 200),
          dpr: 2.0,
        );

        final out = _FakeRenderTexture();
        ro.paintIntoSharedTexture(out, 0.0);

        expect(out.recording.transforms, hasLength(1));
        // scale=(2,2), translation=(50*2, 100*2)=(100,200).
        _expectMatrix(out.recording.transforms.single,
            [2.0, 0.0, 0.0, 2.0, 100.0, 200.0]);
        expect(out.recording.saveCount, 1);
        expect(out.recording.restoreCount, 1);

        painter.dispose();
      },
    );

    testWidgets(
      'widget offset inside panel — translation tracks the offset',
      (tester) async {
        final shared = SharedRenderTexture(
          texture: _FakeRenderTexture(),
          devicePixelRatio: 1.0,
          backgroundColor: const Color(0x00000000),
          panelKey: GlobalKey(),
        );
        final painter = _NoopPainter();

        final ro = await _pumpHarness(
          tester,
          shared: shared,
          painter: painter,
          panelRect: const Rect.fromLTWH(0, 0, 800, 600),
          widgetRect: const Rect.fromLTWH(300, 250, 100, 100),
          dpr: 1.0,
        );

        final out = _FakeRenderTexture();
        ro.paintIntoSharedTexture(out, 0.0);

        _expectMatrix(out.recording.transforms.single,
            [1.0, 0.0, 0.0, 1.0, 300.0, 250.0]);

        painter.dispose();
      },
    );

    testWidgets(
      'panel not at screen origin — translation is still panel-relative',
      (tester) async {
        final shared = SharedRenderTexture(
          texture: _FakeRenderTexture(),
          devicePixelRatio: 1.0,
          backgroundColor: const Color(0x00000000),
          panelKey: GlobalKey(),
        );
        final painter = _NoopPainter();

        // Panel offset by (100, 80) inside the outer 1000×1000 sandbox;
        // widget at outer (150, 130). Expected panel-relative = (50, 50).
        final ro = await _pumpHarness(
          tester,
          shared: shared,
          painter: painter,
          panelRect: const Rect.fromLTWH(100, 80, 600, 500),
          widgetRect: const Rect.fromLTWH(150, 130, 200, 200),
          dpr: 1.0,
        );

        final out = _FakeRenderTexture();
        ro.paintIntoSharedTexture(out, 0.0);

        _expectMatrix(out.recording.transforms.single,
            [1.0, 0.0, 0.0, 1.0, 50.0, 50.0]);

        painter.dispose();
      },
    );

    testWidgets(
      'Transform.scale on the widget only — scale reflects the live transform '
      'and translation tracks the visually scaled top-left '
      '(this is the carousel regression case)',
      (tester) async {
        final shared = SharedRenderTexture(
          texture: _FakeRenderTexture(),
          devicePixelRatio: 1.0,
          backgroundColor: const Color(0x00000000),
          panelKey: GlobalKey(),
        );
        final painter = _NoopPainter();

        // Widget laid out at panel-local (0,0) with size 200×200, then
        // Transform.scale(0.5, alignment: center) wraps it. Transform.scale's
        // default alignment is center, so the visual top-left of the scaled
        // box is at (50, 50) — half of the (1-0.5)*200 inset on each side.
        final ro = await _pumpHarness(
          tester,
          shared: shared,
          painter: painter,
          panelRect: const Rect.fromLTWH(0, 0, 800, 600),
          widgetRect: const Rect.fromLTWH(0, 0, 200, 200),
          dpr: 1.0,
          riveWrapper: (child) => Transform.scale(scale: 0.5, child: child),
        );

        final out = _FakeRenderTexture();
        ro.paintIntoSharedTexture(out, 0.0);

        // scale=(0.5, 0.5), translation=(50, 50).
        _expectMatrix(out.recording.transforms.single,
            [0.5, 0.0, 0.0, 0.5, 50.0, 50.0]);

        painter.dispose();
      },
    );

    testWidgets(
      'Transform.scale ancestor shared with the panel — cancels out '
      '(texture widget re-applies it at composite time)',
      (tester) async {
        final shared = SharedRenderTexture(
          texture: _FakeRenderTexture(),
          devicePixelRatio: 1.0,
          backgroundColor: const Color(0x00000000),
          panelKey: GlobalKey(),
        );
        final painter = _NoopPainter();

        // Outer Transform.scale wraps the entire Stack (both panel and the
        // rive widget). Their relative transform should NOT include that
        // scale — it'll be applied once at composite time when the texture
        // widget paints into the outer-scaled space.
        final ro = await _pumpHarness(
          tester,
          shared: shared,
          painter: painter,
          panelRect: const Rect.fromLTWH(0, 0, 800, 600),
          widgetRect: const Rect.fromLTWH(50, 100, 200, 200),
          dpr: 1.0,
          outerWrapper: (child) => Transform.scale(scale: 0.5, child: child),
        );

        final out = _FakeRenderTexture();
        ro.paintIntoSharedTexture(out, 0.0);

        // scale=(1,1), translation=(50, 100) — same as the no-transform case.
        _expectMatrix(out.recording.transforms.single,
            [1.0, 0.0, 0.0, 1.0, 50.0, 100.0]);

        painter.dispose();
      },
    );

    testWidgets(
      'dpr scales both translation and scale uniformly',
      (tester) async {
        final shared = SharedRenderTexture(
          texture: _FakeRenderTexture(),
          devicePixelRatio: 3.0,
          backgroundColor: const Color(0x00000000),
          panelKey: GlobalKey(),
        );
        final painter = _NoopPainter();

        final ro = await _pumpHarness(
          tester,
          shared: shared,
          painter: painter,
          panelRect: const Rect.fromLTWH(0, 0, 800, 600),
          widgetRect: const Rect.fromLTWH(40, 60, 200, 200),
          dpr: 3.0,
          riveWrapper: (child) => Transform.scale(scale: 0.5, child: child),
        );

        final out = _FakeRenderTexture();
        ro.paintIntoSharedTexture(out, 0.0);

        // scale=(0.5, 0.5) * dpr=3 = (1.5, 1.5).
        // visual top-left of scaled box at panel-local: (40 + 50, 60 + 50) =
        // (90, 110). × dpr = (270, 330).
        _expectMatrix(out.recording.transforms.single,
            [1.5, 0.0, 0.0, 1.5, 270.0, 330.0]);

        painter.dispose();
      },
    );

    // Regression: an earlier implementation read only the scale diagonal
    // (m[0], m[5]) and the translation (m[12], m[13]) of the widget→panel
    // Matrix4, dropping the off-diagonal rotation/skew terms. A rotated
    // widget would composite correctly into Flutter (the Texture widget
    // honours the real transform) while the Rive content drawn into the
    // shared texture appeared un-rotated.
    testWidgets(
      'Transform.rotate on the widget — rotation reaches the texture transform',
      (tester) async {
        final shared = SharedRenderTexture(
          texture: _FakeRenderTexture(),
          devicePixelRatio: 1.0,
          backgroundColor: const Color(0x00000000),
          panelKey: GlobalKey(),
        );
        final painter = _NoopPainter();

        // 90° CCW rotation around the widget's centre (100, 100). Mapping
        // widget-local (x, y) → panel-local: (200 - y, x). In Mat2D order
        // [xx, xy, yx, yy, tx, ty] that's [0, 1, -1, 0, 200, 0].
        final ro = await _pumpHarness(
          tester,
          shared: shared,
          painter: painter,
          panelRect: const Rect.fromLTWH(0, 0, 800, 600),
          widgetRect: const Rect.fromLTWH(0, 0, 200, 200),
          dpr: 1.0,
          riveWrapper: (child) =>
              Transform.rotate(angle: math.pi / 2, child: child),
        );

        final out = _FakeRenderTexture();
        ro.paintIntoSharedTexture(out, 0.0);

        _expectMatrix(out.recording.transforms.single,
            [0.0, 1.0, -1.0, 0.0, 200.0, 0.0]);

        painter.dispose();
      },
    );

    // Same regression: `.abs()` on the scale diagonal silently swallowed
    // negative scale, so a flipped widget composited mirrored but its Rive
    // content drew un-mirrored.
    testWidgets(
      'Transform.flip on the widget — mirror reaches the texture transform',
      (tester) async {
        final shared = SharedRenderTexture(
          texture: _FakeRenderTexture(),
          devicePixelRatio: 1.0,
          backgroundColor: const Color(0x00000000),
          panelKey: GlobalKey(),
        );
        final painter = _NoopPainter();

        // Horizontal flip around the widget's centre (100, 100). Mapping
        // widget-local (x, y) → panel-local: (200 - x, y). In Mat2D order
        // [xx, xy, yx, yy, tx, ty] that's [-1, 0, 0, 1, 200, 0].
        final ro = await _pumpHarness(
          tester,
          shared: shared,
          painter: painter,
          panelRect: const Rect.fromLTWH(0, 0, 800, 600),
          widgetRect: const Rect.fromLTWH(0, 0, 200, 200),
          dpr: 1.0,
          riveWrapper: (child) => Transform.flip(flipX: true, child: child),
        );

        final out = _FakeRenderTexture();
        ro.paintIntoSharedTexture(out, 0.0);

        _expectMatrix(out.recording.transforms.single,
            [-1.0, 0.0, 0.0, 1.0, 200.0, 0.0]);

        painter.dispose();
      },
    );

    testWidgets(
      'matrix is recomputed every call (no stale-cache regression)',
      (tester) async {
        // Repro for the carousel bug: the previous implementation cached
        // scale in RiveNativeRenderBox.paint() and only refreshed it when
        // the child's paint() ran. Composited ancestors can change the
        // visual transform without invoking that paint(). This test changes
        // the Transform.scale value between two calls to
        // paintIntoSharedTexture without pumping a frame in between — the
        // second call must reflect the new scale, not the previous one.
        final shared = SharedRenderTexture(
          texture: _FakeRenderTexture(),
          devicePixelRatio: 1.0,
          backgroundColor: const Color(0x00000000),
          panelKey: GlobalKey(),
        );
        final painter = _NoopPainter();

        // Use a stateful host that controls Transform.scale via a setter, so
        // we can mutate the scale and pump a fresh frame.
        final host = _ScaleHost(initialScale: 0.5);
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(devicePixelRatio: 1.0),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Center(
                child: SizedBox(
                  width: 1000,
                  height: 1000,
                  child: Stack(
                    children: [
                      Positioned.fromRect(
                        rect: const Rect.fromLTWH(0, 0, 800, 600),
                        child: SizedBox.expand(key: shared.panelKey),
                      ),
                      Positioned.fromRect(
                        rect: const Rect.fromLTWH(0, 0, 200, 200),
                        child: host.wrap(
                          SharedTextureViewRenderer(
                            renderTexturePainter: painter,
                            sharedTexture: shared,
                            devicePixelRatio: 1.0,
                            drawOrder: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        final ro = tester.renderObject<SharedTextureViewRenderObject>(
          find.byType(SharedTextureViewRenderer),
        );

        // First read: scale 0.5, visual top-left (50, 50).
        final firstOut = _FakeRenderTexture();
        ro.paintIntoSharedTexture(firstOut, 0.0);
        _expectMatrix(firstOut.recording.transforms.single,
            [0.5, 0.0, 0.0, 0.5, 50.0, 50.0]);

        // Mutate the live transform and re-pump only enough to update the
        // render tree's transform. Crucially, we do NOT rely on the child's
        // paint() being invoked to refresh a cache — we just call
        // paintIntoSharedTexture again.
        host.setScale(0.75);
        await tester.pump();

        // Second read: scale 0.75, visual top-left (25, 25).
        final secondOut = _FakeRenderTexture();
        ro.paintIntoSharedTexture(secondOut, 0.0);
        _expectMatrix(secondOut.recording.transforms.single,
            [0.75, 0.0, 0.0, 0.75, 25.0, 25.0]);

        painter.dispose();
      },
    );
  });
}

/// Stateful holder so a test can mutate a Transform.scale between pumps.
class _ScaleHost {
  _ScaleHost({required this.initialScale});
  final double initialScale;
  _ScaleHostState? _state;

  Widget wrap(Widget child) =>
      _ScaleHostWidget(host: this, initial: initialScale, child: child);

  void setScale(double v) => _state?.setScale(v);
}

class _ScaleHostWidget extends StatefulWidget {
  const _ScaleHostWidget({
    required this.host,
    required this.initial,
    required this.child,
  });

  final _ScaleHost host;
  final double initial;
  final Widget child;

  @override
  State<_ScaleHostWidget> createState() => _ScaleHostState();
}

class _ScaleHostState extends State<_ScaleHostWidget> {
  late double _scale = widget.initial;

  @override
  void initState() {
    super.initState();
    widget.host._state = this;
  }

  void setScale(double v) => setState(() => _scale = v);

  @override
  Widget build(BuildContext context) =>
      Transform.scale(scale: _scale, child: widget.child);
}
