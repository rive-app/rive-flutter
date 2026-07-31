import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// Web-only: scroll-recycling churn against the render texture reuse pool
/// (run with `-d chrome`).
///
/// The .riv file is decoded once and shared by every tile — each tile owns
/// only its controller and (on web) its WebGL context — so scroll churn
/// exercises exactly the texture/context lifecycle, with no file loading in
/// the loop (which also sidesteps the known FileLoader dispose-during-load
/// race).
///
/// Two access patterns, two outcomes:
///
/// - Steady scrolling is one-out-one-in: disposals refill the pool as fast
///   as entries drain it, so even a small pool mostly reuses. Expect smooth
///   (after the first pass, which always creates from scratch).
/// - The jump buttons churn the whole visible working set (~6 items) in a
///   single frame. A pool of 4 serves 4 and the rest are fresh context +
///   shader creations — expect a stutter on every jump. A larger (or
///   decaying) pool makes repeat jumps free.
class TestWebGLScrollRecycling extends StatefulWidget {
  const TestWebGLScrollRecycling({super.key});

  @override
  State<TestWebGLScrollRecycling> createState() =>
      _TestWebGLScrollRecyclingState();
}

class _TestWebGLScrollRecyclingState extends State<TestWebGLScrollRecycling> {
  final _scrollController = ScrollController();
  File? _file;

  @override
  void initState() {
    super.initState();
    // Log texture create/reuse/release with live context counts to the JS
    // console while this page is up.
    RiveNative.debugRenderTextureLogging = true;
    File.asset('assets/rating.riv', riveFactory: Factory.rive).then((file) {
      if (!mounted) {
        file?.dispose();
        return;
      }
      setState(() => _file = file);
    });
  }

  @override
  void dispose() {
    RiveNative.debugRenderTextureLogging = false;
    _scrollController.dispose();
    _file?.dispose();
    super.dispose();
  }

  void _jumpTo(double offset) => _scrollController.jumpTo(offset);

  @override
  Widget build(BuildContext context) {
    final file = _file;
    return Scaffold(
      body: file == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Scroll steadily: recycling is one-out-one-in, the '
                          'pool covers it. Jump: the whole working set churns '
                          'in one frame — past the pool cap, each jump pays '
                          'fresh context creations. The JS console logs every '
                          'create/reuse/release with live context counts.',
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed: () => _jumpTo(0),
                        child: const Text('Top'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () => _jumpTo(
                          _scrollController.position.maxScrollExtent,
                        ),
                        child: const Text('Bottom'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: 12,
                    // Fixed extent (tile height + vertical padding): exact
                    // scroll metrics mean jumps never lay children out
                    // against an estimated offset and discard them in the
                    // same frame — which trips a debug-only Flutter assert
                    // in HtmlElementView's placeholder (its post-frame
                    // localToGlobal runs on a detached render box).
                    itemExtent: 216,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: SizedBox(
                        height: 200,
                        child: Card(
                          child: Row(
                            children: [
                              const SizedBox(width: 16),
                              Text('Item $index'),
                              const SizedBox(width: 16),
                              Expanded(child: _RiveTile(file: file)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

/// One graphic sharing the page's [File]; owns only its controller and (on
/// web) its WebGL context.
class _RiveTile extends StatefulWidget {
  const _RiveTile({required this.file});

  final File file;

  @override
  State<_RiveTile> createState() => _RiveTileState();
}

class _RiveTileState extends State<_RiveTile> {
  late final _controller = RiveWidgetController(widget.file);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiveWidget(controller: _controller);
  }
}
