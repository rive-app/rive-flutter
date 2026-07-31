import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// Web-only reproducer for WebGL context lifecycle bugs (run with
/// `-d chrome`, devtools console open).
///
/// Browsers cap live WebGL contexts (~16 in Chrome), shared between every
/// `Factory.rive` widget (one context each), Flutter's own CanvasKit
/// surfaces, and anything else on the page. Past the cap, Chrome evicts the
/// least-recently-used context. On a leaking SDK, disposed widgets keep
/// their contexts alive forever, so the app permanently squats at its
/// lifetime high-water mark: over-budget moments evict contexts that matter
/// (covered widgets, Flutter's idle offscreen surfaces — fatal on stable,
/// flutter/flutter#184683), the pool re-issues dead textures as permanently
/// blank widgets, and headless environments fail context creation outright.
/// Follow the numbered steps on screen; each explains what to expect on a
/// leaking vs fixed SDK.
class TestWebGLContextLifecycle extends StatefulWidget {
  const TestWebGLContextLifecycle({super.key});

  @override
  State<TestWebGLContextLifecycle> createState() =>
      _TestWebGLContextLifecycleState();
}

class _TestWebGLContextLifecycleState extends State<TestWebGLContextLifecycle> {
  bool _showBaseline = false;
  bool _visitedHeavyScreen = false;

  @override
  void initState() {
    super.initState();
    // Log texture create/reuse/release with live context counts to the JS
    // console while this page (and the heavy screen it pushes) is up.
    RiveNative.debugRenderTextureLogging = true;
  }

  @override
  void dispose() {
    RiveNative.debugRenderTextureLogging = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Each Factory.rive widget owns one WebGL context; browsers cap '
            'live contexts (~16, shared with CanvasKit) and evict the '
            'least-recently-used past the cap. Keep the devtools console '
            'open — every texture create/reuse/release is logged with live '
            'context counts — and follow the steps in order.',
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => setState(() => _showBaseline = !_showBaseline),
            child: Text(
              _showBaseline
                  ? 'Hide the baseline graphics'
                  : '1. Show 6 baseline graphics here',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const _HeavyScreen(),
                ),
              );
              setState(() => _visitedHeavyScreen = true);
            },
            child: const Text('2. Visit a Rive-heavy screen (12 graphics)'),
          ),
          const SizedBox(height: 8),
          Text(
            !_visitedHeavyScreen
                ? 'With the baseline showing, this pushes live contexts over '
                    'the budget: expect console warnings, blank baseline '
                    'widgets on return, and possibly a fatal engine error.'
                : 'Visited. Step 3: hide the baseline graphics and visit '
                    'again — a leaking SDK shows permanently blank widgets '
                    '(poisoned pool); a fixed SDK fully recovers. Toggling '
                    'the baseline graphics off and on shows the same '
                    'contrast.',
          ),
          const SizedBox(height: 16),
          if (_showBaseline) const _RiveGrid(count: 6),
        ],
      ),
    );
  }
}

class _HeavyScreen extends StatelessWidget {
  const _HeavyScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rive-heavy screen')),
      body: const _RiveGrid(count: 12),
    );
  }
}

class _RiveGrid extends StatelessWidget {
  const _RiveGrid({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (var i = 0; i < count; i++) const _RiveTile(),
      ],
    );
  }
}

/// One graphic with its own file, controller, and (on web) WebGL context.
class _RiveTile extends StatefulWidget {
  const _RiveTile();

  @override
  State<_RiveTile> createState() => _RiveTileState();
}

class _RiveTileState extends State<_RiveTile> {
  late final _fileLoader = FileLoader.fromAsset(
    'assets/rating.riv',
    riveFactory: Factory.rive,
  );

  @override
  void dispose() {
    _fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiveWidgetBuilder(
      fileLoader: _fileLoader,
      builder: (context, state) => switch (state) {
        RiveLoading() => const SizedBox.shrink(),
        RiveFailed() => ErrorWidget.withDetails(
            message: state.error.toString(),
          ),
        RiveLoaded() => RiveWidget(controller: state.controller),
      },
    );
  }
}
