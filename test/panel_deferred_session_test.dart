@TestOn('!browser')
library;

import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';
import 'package:rive_native/rive_deferred.dart' as rive_deferred;
import 'package:rive_native/rive_native.dart' as rive;

/// Regression tests for the RivePanel deferred-session attach.
///
/// Under deferred rendering (the only native mode) a texture draws only what
/// its attached recording session replays; a sessionless clear/flush warns
/// and draws nothing. The own-texture path attaches in
/// `RiveNativeRenderBox.paintTexture`, but the shared (panel) paint pass in
/// [SharedRenderTexture] used to clear/flush without ever attaching, so
/// every RivePanel rendered blank on device while the headless test path -
/// which does not require a session - stayed green.
///
/// These tests drive the real render-object plumbing
/// ([SharedTextureViewRenderer] -> [SharedTextureViewRenderObject] ->
/// [SharedRenderTexture]) with a spy texture that records the driver
/// protocol, and a real recording session from the native library.
/// Gates the suite on the complete deferred ABI, the way
/// rive_native's own deferred tests do - null when any symbol is missing.
final rive.Factory? _deferredProbe = rive_deferred.makeHeadlessDeferredFactory();

const String _skipReason = 'Deferred symbols not in the native lib '
    '(build with: cd native && ./build.sh shared)';

/// Minimal renderer so painters can run against the spy texture.
/// noSuchMethod keeps it compiling as [rive.Renderer] grows - CI builds the
/// PR merged into master, where the interface may be newer than this branch.
class _NoopRenderer extends rive.Renderer {
  @override
  dynamic noSuchMethod(Invocation invocation) {}
}

/// Records the driver-protocol calls the shared paint pass makes, in order,
/// so tests can assert the session attach happens and precedes the recorded
/// clear. Toggles simulate the native pacing gates.
base class _SpyRenderTexture extends rive.RenderTexture {
  final List<String> calls = [];
  final List<rive.Factory?> attachedSessions = [];
  bool acceptDeferredFrames = true;
  bool paused = false;
  bool clearResult = true;
  final _NoopRenderer _renderer = _NoopRenderer();

  int get clearCount => calls.where((c) => c == 'clear').length;
  int get flushCount => calls.where((c) => c == 'flush').length;

  @override
  void useDeferredSession(rive.Factory? session) {
    calls.add('attach');
    attachedSessions.add(session);
  }

  @override
  bool get deferredPaused => paused;

  @override
  bool get canAcceptDeferredFrame => acceptDeferredFrames;

  @override
  bool clear(Color color, [bool write = true]) {
    calls.add('clear');
    return clearResult;
  }

  @override
  bool flush(double devicePixelRatio) {
    calls.add('flush');
    return true;
  }

  @override
  rive.Renderer get renderer => _renderer;
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
  bool needsResize(int width, int height) => false;
  @override
  Future<void> makeRenderTexture(int width, int height) async {}
  @override
  Future<ui.Image> toImage() => throw UnimplementedError();
  @override
  Widget widget({
    rive.RenderTexturePainter? painter,
    rive.RenderResolution resolution = const rive.RenderResolution.display(),
    Key? key,
  }) =>
      throw UnimplementedError();
  @override
  void dispose() {}
}

/// Paints nothing; carries the recording [factory] the way an artboard
/// painter carries the factory its file was decoded with.
final class _DeferredContentPainter extends rive.RenderTexturePainter {
  _DeferredContentPainter(this.factory);
  final rive.Factory? factory;
  bool advance = false;
  final List<double> elapsedLog = [];
  int get paintCount => elapsedLog.length;

  @override
  rive.Factory? get riveFactory => factory;

  @override
  Color get background => const Color(0x00000000);

  @override
  bool paint(rive.RenderTexture texture, double devicePixelRatio, Size size,
      double elapsedSeconds) {
    elapsedLog.add(elapsedSeconds);
    return advance;
  }
}

SharedRenderTexture _makeShared(_SpyRenderTexture texture) =>
    SharedRenderTexture(
      texture: texture,
      devicePixelRatio: 1.0,
      backgroundColor: const Color(0x00000000),
      panelKey: GlobalKey(),
    );

/// A real recording session from the native lib, auto-attach enabled the way
/// file decode enables it for the sessions render boxes attach.
rive.Factory _makeSession() {
  final factory = rive_deferred.makeHeadlessDeferredFactory();
  expect(factory, isNotNull, reason: _skipReason);
  rive_deferred.enableDeferredAutoAttach(factory!);
  return factory;
}

/// Panel marker and [SharedTextureViewRenderer]s as Stack siblings, the way
/// [RivePanel] arranges them.
Future<void> _pumpPanel(
  WidgetTester tester, {
  required SharedRenderTexture shared,
  required List<rive.RenderTexturePainter> painters,
}) {
  return tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 400,
            height: 300,
            child: Stack(
              children: [
                Positioned.fill(child: SizedBox.expand(key: shared.panelKey)),
                for (final (i, painter) in painters.indexed)
                  Positioned(
                    left: 10.0 + 110.0 * i,
                    top: 10,
                    width: 100,
                    height: 100,
                    child: SharedTextureViewRenderer(
                      renderTexturePainter: painter,
                      sharedTexture: shared,
                      devicePixelRatio: 1.0,
                      drawOrder: 1,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

/// Two frames: one runs the paint pass scheduled by the painter attach (or a
/// gate flip), one drives the ticker's follow-up post-frame pass.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

void main() {
  setUpAll(() async {
    expect(await rive.RiveNative.init(), isTrue);
  });

  // Spy-only (no recording session), so it runs under any native lib and is
  // deliberately outside the deferred-ABI skip gate below.
  testWidgets(
    'paused passes drop their elapsed instead of banking it',
    (tester) async {
      final spy = _SpyRenderTexture();
      final shared = _makeShared(spy);
      final painter = _DeferredContentPainter(null)..advance = true;

      await _pumpPanel(tester, shared: shared, painters: [painter]);
      await _settle(tester);
      expect(painter.elapsedLog, isNotEmpty);
      final paintsBefore = painter.elapsedLog.length;

      spy.paused = true;
      await tester.pump(const Duration(milliseconds: 16));
      await tester.pump(const Duration(milliseconds: 16));
      expect(painter.elapsedLog.length, paintsBefore,
          reason: 'paused passes must not paint');

      spy.paused = false;
      await tester.pump(const Duration(milliseconds: 16));
      await tester.pump(const Duration(milliseconds: 16));
      expect(painter.elapsedLog.length, greaterThan(paintsBefore));
      expect(painter.elapsedLog.skip(paintsBefore),
          everyElement(lessThan(0.020)),
          reason: 'a pause freezes the animation; resuming must not '
              'fast-forward it by the paused span');
    },
  );

  testWidgets(
    'a pause keeps time banked by a gated pass',
    (tester) async {
      final spy = _SpyRenderTexture();
      final shared = _makeShared(spy);
      final painter = _DeferredContentPainter(null)..advance = true;

      await _pumpPanel(tester, shared: shared, painters: [painter]);
      await _settle(tester);
      final paintsBefore = painter.elapsedLog.length;

      // Gated: the pass banks its elapsed instead of painting.
      spy.acceptDeferredFrames = false;
      await tester.pump(const Duration(milliseconds: 16));
      expect(painter.elapsedLog.length, paintsBefore,
          reason: 'a gated pass must not paint');

      // Paused immediately after, then resumed. The paused tick's own time is
      // dropped, but the gated frame still owes its advance.
      spy.paused = true;
      await tester.pump(const Duration(milliseconds: 16));
      spy.paused = false;
      spy.acceptDeferredFrames = true;
      await tester.pump(const Duration(milliseconds: 16));
      await _settle(tester);

      expect(painter.elapsedLog.length, greaterThan(paintsBefore));
      expect(painter.elapsedLog.skip(paintsBefore).first, greaterThan(0.020),
          reason: 'the gated pass banked ~16ms and the pass after the resume '
              'ticked ~16ms more; dropping the bank with the paused tick '
              'would make the animation permanently lag');
    },
  );

  group('shared paint pass deferred session', () {
    testWidgets(
      'attaches the painters recording session to the texture before drawing',
      (tester) async {
        final session = _makeSession();
        final spy = _SpyRenderTexture();
        final shared = _makeShared(spy);
        final painter = _DeferredContentPainter(session);

        await _pumpPanel(tester, shared: shared, painters: [painter]);
        await _settle(tester);

        expect(spy.attachedSessions, isNotEmpty,
            reason: 'the shared paint pass never attached the recording '
                'session, so a native texture would replay nothing and the '
                'panel would stay blank');
        expect(spy.attachedSessions.last, same(session));
        expect(spy.calls.indexOf('attach'), lessThan(spy.calls.indexOf('clear')),
            reason: 'the session must be attached before the frame records');
        expect(painter.paintCount, greaterThan(0));
      },
    );

    testWidgets(
      'finds the session on any painter, not just the first',
      (tester) async {
        final session = _makeSession();
        final spy = _SpyRenderTexture();
        final shared = _makeShared(spy);

        await _pumpPanel(tester, shared: shared, painters: [
          _DeferredContentPainter(null),
          _DeferredContentPainter(session),
        ]);
        await _settle(tester);

        expect(spy.attachedSessions, isNotEmpty);
        expect(spy.attachedSessions.last, same(session));
      },
    );

    testWidgets(
      'still draws (without attaching) when no painter has a session',
      (tester) async {
        final spy = _SpyRenderTexture();
        final shared = _makeShared(spy);
        final painter = _DeferredContentPainter(null);

        await _pumpPanel(tester, shared: shared, painters: [painter]);
        await _settle(tester);

        expect(spy.attachedSessions, isEmpty);
        expect(spy.clearCount, greaterThan(0));
        expect(spy.flushCount, greaterThan(0));
        expect(painter.paintCount, greaterThan(0));
      },
    );

    testWidgets(
      're-applies the attach on every pass so a recreated native texture '
      'reacquires the session',
      (tester) async {
        final session = _makeSession();
        final spy = _SpyRenderTexture();
        final shared = _makeShared(spy);
        final painter = _DeferredContentPainter(session);

        await _pumpPanel(tester, shared: shared, painters: [painter]);
        await _settle(tester);
        final attachesBefore = spy.attachedSessions.length;
        expect(attachesBefore, greaterThan(0));

        // schedulePaint queues a post-frame pass but does not request a
        // frame, so re-pump the (unchanged) tree to drive one.
        shared.schedulePaint();
        await _pumpPanel(tester, shared: shared, painters: [painter]);

        expect(spy.attachedSessions.length, greaterThan(attachesBefore));
      },
    );

    testWidgets(
      'skips and retries the pass while the replay worker cannot take a frame',
      (tester) async {
        final session = _makeSession();
        final spy = _SpyRenderTexture()..acceptDeferredFrames = false;
        final shared = _makeShared(spy);
        final painter = _DeferredContentPainter(session);

        await _pumpPanel(tester, shared: shared, painters: [painter]);
        await _settle(tester);

        expect(spy.clearCount, 0,
            reason: 'recording must not start while the worker cannot take '
                'a frame - the stream is stateful and a recorded frame can '
                'never be dropped');
        expect(painter.paintCount, 0);
        expect(shared.isTickerActive, isTrue,
            reason: 'the skipped pass must keep retrying');

        spy.acceptDeferredFrames = true;
        await _settle(tester);

        expect(spy.clearCount, greaterThan(0));
        expect(spy.flushCount, greaterThan(0));
        expect(painter.paintCount, greaterThan(0));
      },
    );

    testWidgets(
      'records nothing while the texture is paused',
      (tester) async {
        final session = _makeSession();
        final spy = _SpyRenderTexture()..paused = true;
        final shared = _makeShared(spy);
        final painter = _DeferredContentPainter(session);

        await _pumpPanel(tester, shared: shared, painters: [painter]);
        await _settle(tester);

        expect(spy.clearCount, 0,
            reason: 'a paused texture must not record - the session stream '
                'has no drain while paused');
        expect(painter.paintCount, 0);
        expect(shared.isTickerActive, isTrue,
            reason: 'the paused pass must keep the (vsync-gated) ticker '
                'alive so the resume repaints without an external kick');

        spy.paused = false;
        await _settle(tester);

        expect(spy.clearCount, greaterThan(0));
        expect(painter.paintCount, greaterThan(0));
      },
    );

    testWidgets(
      'settles instead of spinning when the texture cannot clear, and '
      'recovers through the texture-changed listener',
      (tester) async {
        final session = _makeSession();
        final spy = _SpyRenderTexture()..clearResult = false;
        final shared = _makeShared(spy);
        final painter = _DeferredContentPainter(session);

        await _pumpPanel(tester, shared: shared, painters: [painter]);
        await _settle(tester);

        expect(spy.flushCount, 0);
        expect(painter.paintCount, 0);
        expect(shared.isTickerActive, isFalse,
            reason: 'a failed clear must not retry forever - a refused web '
                'context or a sessionless native texture fails permanently');

        // Texture recreation notifies listeners; the pass repaints then.
        spy.clearResult = true;
        spy.textureChanged();
        await _settle(tester);

        expect(spy.flushCount, greaterThan(0));
        expect(painter.paintCount, greaterThan(0));
      },
    );
  }, skip: _deferredProbe != null ? false : _skipReason);
}
