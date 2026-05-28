import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';
import 'package:rive_native/rive_native.dart' as rive;

/// A test double that records calls instead of touching any real GPU
/// resources. Sufficient to exercise [SharedRenderTexture]'s pure-Dart logic.
base class _FakeRenderTexture extends rive.RenderTexture {
  int clearCount = 0;
  int flushCount = 0;
  int disposeCount = 0;
  Color? lastClearColor;
  double? lastFlushDpr;

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
  bool get isDisposed => disposeCount > 0;

  @override
  rive.Renderer get renderer => throw UnimplementedError();

  @override
  bool clear(Color color, [bool write = true]) {
    clearCount++;
    lastClearColor = color;
    return true;
  }

  @override
  bool flush(double devicePixelRatio) {
    flushCount++;
    lastFlushDpr = devicePixelRatio;
    return true;
  }

  @override
  bool needsResize(int width, int height) => false;

  @override
  Future<void> makeRenderTexture(int width, int height) async {}

  @override
  Future<ui.Image> toImage() => throw UnimplementedError();

  @override
  Widget widget({rive.RenderTexturePainter? painter, Key? key}) =>
      throw UnimplementedError();

  @override
  void dispose() {
    disposeCount++;
  }
}

class _FakePainter implements SharedTexturePainter {
  _FakePainter({this.drawOrder = 1, this.framesToAdvance = 0});

  int paintCount = 0;
  rive.RenderTexture? lastPaintedInto;
  final int drawOrder;
  // Number of remaining paint passes the painter still wants to advance for.
  // After this counter reaches 0, paintIntoSharedTexture returns false and the
  // painter is "settled".
  int framesToAdvance;

  @override
  int get sharedDrawOrder => drawOrder;

  @override
  bool paintIntoSharedTexture(
      rive.RenderTexture texture, double elapsedSeconds) {
    paintCount++;
    lastPaintedInto = texture;
    if (framesToAdvance > 0) {
      framesToAdvance--;
      return true;
    }
    return false;
  }
}

SharedRenderTexture _makeShared(_FakeRenderTexture texture) {
  return SharedRenderTexture(
    texture: texture,
    devicePixelRatio: 2.0,
    backgroundColor: const Color(0xFF112233),
    panelKey: GlobalKey(),
  );
}

/// Drives a frame so any post-frame callbacks registered via
/// [SharedRenderTexture.schedulePaint] are flushed. Pumping a (no-op) widget
/// is the simplest way to get the [SchedulerBinding] to actually run a frame
/// — `tester.pump()` alone is a no-op when nothing is scheduled.
Future<void> _flushPostFrame(WidgetTester tester) =>
    tester.pumpWidget(const SizedBox.shrink());

void main() {
  group('SharedRenderTexture (pure Dart)', () {
    // Regression: a post-frame callback scheduled before the last painter
    // detached used to fire afterwards with an empty painters list and blank
    // the shared texture — the iOS carousel "flash" report.
    testWidgets(
      'paint is a no-op when painters list is empty',
      (tester) async {
        final texture = _FakeRenderTexture();
        final shared = _makeShared(texture);

        shared.schedulePaint();
        await _flushPostFrame(tester);

        expect(texture.clearCount, 0,
            reason: 'no painters means no clear should be emitted');
        expect(texture.flushCount, 0,
            reason: 'no painters means no flush should be emitted');
      },
    );

    testWidgets(
      'paint runs clear/paint/flush when at least one painter is attached',
      (tester) async {
        final texture = _FakeRenderTexture();
        final shared = _makeShared(texture);
        final painter = _FakePainter();
        shared.addPainter(painter);

        shared.schedulePaint();
        await _flushPostFrame(tester);

        expect(texture.clearCount, 1);
        expect(painter.paintCount, 1);
        expect(painter.lastPaintedInto, same(texture));
        expect(texture.flushCount, 1);
        expect(texture.lastClearColor, const Color(0xFF112233));
        expect(texture.lastFlushDpr, 2.0);
      },
    );

    testWidgets(
      'schedulePaint deduplicates within a single frame',
      (tester) async {
        final texture = _FakeRenderTexture();
        final shared = _makeShared(texture);
        shared.addPainter(_FakePainter());

        shared.schedulePaint();
        shared.schedulePaint();
        shared.schedulePaint();
        await _flushPostFrame(tester);

        expect(texture.clearCount, 1);
        expect(texture.flushCount, 1);
      },
    );

    test('addPainter is idempotent for the same painter instance', () {
      final shared = _makeShared(_FakeRenderTexture());
      final painter = _FakePainter();
      shared.addPainter(painter);
      shared.addPainter(painter);
      shared.addPainter(painter);
      expect(shared.painters, [painter]);
    });

    // Regression: with per-widget tickers, one active widget would drive the
    // shared paint pass which re-called advance() on settled siblings and
    // accidentally revived their tickers. With a single shared ticker, every
    // painter returning false from paintIntoSharedTexture must stop the
    // ticker.
    testWidgets(
      'ticker stops once every painter reports settled',
      (tester) async {
        final texture = _FakeRenderTexture();
        final shared = _makeShared(texture);
        final settled = _FakePainter();
        final stillAdvancing = _FakePainter(framesToAdvance: 2);
        shared.addPainter(settled);
        shared.addPainter(stillAdvancing);

        // First frame: stillAdvancing returns true → ticker stays running.
        await tester.pump();
        expect(shared.isTickerActive, isTrue);
        expect(settled.paintCount, 1);
        expect(stillAdvancing.paintCount, 1);

        // Second frame: stillAdvancing returns true once more.
        await tester.pump();
        expect(shared.isTickerActive, isTrue);

        // Third frame: stillAdvancing finally settles → ticker stops.
        await tester.pump();
        expect(shared.isTickerActive, isFalse);

        final paintsBeforeIdle = texture.clearCount;
        // Additional pumps must not re-tick a settled scene.
        await tester.pump();
        await tester.pump();
        expect(shared.isTickerActive, isFalse);
        expect(texture.clearCount, paintsBeforeIdle,
            reason: 'settled scene must not paint on subsequent frames');
      },
    );

    testWidgets(
      'addPainter wakes the ticker so a newly attached painter shows up',
      (tester) async {
        final texture = _FakeRenderTexture();
        final shared = _makeShared(texture);
        final settled = _FakePainter();
        shared.addPainter(settled);

        // Let the initial paint settle the ticker.
        await tester.pump();
        expect(shared.isTickerActive, isFalse);
        expect(settled.paintCount, 1);

        // Add a second painter mid-flight. The ticker must restart so the
        // new painter actually gets painted into the shared texture.
        final joiner = _FakePainter();
        shared.addPainter(joiner);
        expect(shared.isTickerActive, isTrue,
            reason: 'addPainter must wake the shared ticker');

        await tester.pump();
        expect(joiner.paintCount, 1);
        expect(shared.isTickerActive, isFalse,
            reason: 'ticker should settle again after one paint pass');
      },
    );

    test('painters are kept sorted by sharedDrawOrder', () {
      final shared = _makeShared(_FakeRenderTexture());
      final back = _FakePainter(drawOrder: 1);
      final mid = _FakePainter(drawOrder: 5);
      final front = _FakePainter(drawOrder: 10);

      shared.addPainter(front);
      shared.addPainter(back);
      shared.addPainter(mid);

      expect(shared.painters, [back, mid, front]);
    });

    testWidgets(
      'mutating backgroundColor takes effect on the next paint',
      (tester) async {
        final texture = _FakeRenderTexture();
        final shared = _makeShared(texture);
        shared.addPainter(_FakePainter());

        shared.backgroundColor = const Color(0xFFAA00FF);
        shared.schedulePaint();
        await _flushPostFrame(tester);

        expect(texture.lastClearColor, const Color(0xFFAA00FF));
      },
    );

    testWidgets(
      'mutating devicePixelRatio takes effect on the next paint',
      (tester) async {
        final texture = _FakeRenderTexture();
        final shared = _makeShared(texture);
        shared.addPainter(_FakePainter());

        shared.devicePixelRatio = 3.5;
        shared.schedulePaint();
        await _flushPostFrame(tester);

        expect(texture.lastFlushDpr, 3.5);
      },
    );

    testWidgets(
      'schedulePaint after dispose is a no-op',
      (tester) async {
        final texture = _FakeRenderTexture();
        final shared = _makeShared(texture);
        shared.addPainter(_FakePainter());

        shared.dispose();
        shared.schedulePaint();
        await _flushPostFrame(tester);

        expect(texture.clearCount, 0);
        expect(texture.flushCount, 0);
      },
    );

    testWidgets(
      'a pending post-frame callback that fires after dispose() does not '
      'touch the underlying texture',
      (tester) async {
        final texture = _FakeRenderTexture();
        final shared = _makeShared(texture);
        shared.addPainter(_FakePainter());

        shared.schedulePaint();
        shared.dispose();
        await _flushPostFrame(tester);

        expect(texture.clearCount, 0);
        expect(texture.flushCount, 0);
      },
    );

    test(
      'dispose() only releases the underlying texture for instances created '
      'via SharedRenderTexture.create (externally-owned textures are '
      'released by their owner)',
      () {
        final texture = _FakeRenderTexture();
        final shared = _makeShared(texture);
        shared.dispose();
        expect(texture.disposeCount, 0,
            reason: 'externally-owned texture must NOT be disposed by the '
                'shared wrapper');
        expect(shared.isDisposed, isTrue);
      },
    );
  });

  group('RiveSharedTexture inherited widget', () {
    // Regression: ancestor setState used to allocate a new SharedRenderTexture
    // wrapper on every rebuild, dirtying every descendant RiveWidget and
    // ripping their painters off the previous wrapper.
    testWidgets(
      'updateShouldNotify is false when the instance is stable across rebuilds',
      (tester) async {
        final shared = _makeShared(_FakeRenderTexture());
        final harness = _RebuildHarness();

        await tester.pumpWidget(_Host(
          harness: harness,
          builder: (_) => RiveSharedTexture(
            texture: shared,
            child: const _DependencyCounter(),
          ),
        ));

        final counterState = tester.state<_DependencyCounterState>(
          find.byType(_DependencyCounter),
        );
        expect(counterState.dependencyChanges, 1,
            reason: 'initial mount should register one dependency change');

        // Simulate setState higher up. The descendant should NOT see a
        // dependency change because the SharedRenderTexture is the same
        // instance.
        harness.bump();
        await tester.pump();
        expect(counterState.dependencyChanges, 1,
            reason: 'stable instance must not notify dependents on '
                'ancestor rebuild');

        harness.bump();
        await tester.pump();
        expect(counterState.dependencyChanges, 1);
      },
    );

    testWidgets(
      'updateShouldNotify is true when the instance is replaced',
      (tester) async {
        final first = _makeShared(_FakeRenderTexture());
        final second = _makeShared(_FakeRenderTexture());
        SharedRenderTexture current = first;
        final harness = _RebuildHarness();

        await tester.pumpWidget(_Host(
          harness: harness,
          builder: (_) => RiveSharedTexture(
            texture: current,
            child: const _DependencyCounter(),
          ),
        ));

        final counterState = tester.state<_DependencyCounterState>(
          find.byType(_DependencyCounter),
        );
        expect(counterState.dependencyChanges, 1);

        // Swap to a different instance and rebuild.
        current = second;
        harness.bump();
        await tester.pump();
        expect(counterState.dependencyChanges, 2,
            reason: 'swapping the instance must notify dependents');
      },
    );

    testWidgets(
      'RiveSharedTexture.of returns the supplied instance',
      (tester) async {
        final shared = _makeShared(_FakeRenderTexture());
        SharedRenderTexture? observed;

        await tester.pumpWidget(RiveSharedTexture(
          texture: shared,
          child: Builder(builder: (context) {
            observed = RiveSharedTexture.of(context);
            return const SizedBox.shrink();
          }),
        ));

        expect(identical(observed, shared), isTrue);
      },
    );
  });
}

/// A stateful harness whose [bump] method calls setState so we can simulate
/// "an ancestor of the RiveSharedTexture rebuilds".
class _RebuildHarness {
  void Function()? _trigger;

  void bump() {
    final t = _trigger;
    if (t != null) t();
  }
}

class _Host extends StatefulWidget {
  const _Host({required this.harness, required this.builder});

  final _RebuildHarness harness;
  final WidgetBuilder builder;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  // Used purely to force a rebuild; the value is not read by the subtree, so
  // descendant element identity is preserved across bumps. This is what
  // simulates "setState higher up the tree" without remounting children.
  int _tick = 0;

  @override
  void initState() {
    super.initState();
    widget.harness._trigger = () => setState(() => _tick++);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: widget.builder);
  }
}

class _DependencyCounter extends StatefulWidget {
  const _DependencyCounter();

  @override
  State<_DependencyCounter> createState() => _DependencyCounterState();
}

class _DependencyCounterState extends State<_DependencyCounter> {
  int dependencyChanges = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Establish (or refresh) the dependency on RiveSharedTexture.
    RiveSharedTexture.of(context);
    dependencyChanges++;
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

