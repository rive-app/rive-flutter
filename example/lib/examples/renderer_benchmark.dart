// rive_native is resolved through `rive` rather than as a direct
// dependency, so that CI can repoint `rive` at the local path.
// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rive/rive.dart';
// The replay counters are advanced API, not part of `package:rive`.
import 'package:rive_native/rive_deferred.dart' show deferredThreadStats;
import 'package:rive_example/main.dart' show RiveExampleApp;

/// Renderer benchmark: the same content under `Factory.rive` (one render
/// texture per widget, or one shared texture through [RivePanel]) and under
/// `Factory.flutter`, so the two can be compared on a device.
///
/// The factory comes from the app's renderer switch. The controls below set
/// what is drawn: which file, how many copies, and the load that surrounds
/// them. Use the perf overlay (speed chip) to read Rive's update rate next to
/// Flutter's frame rate - they are different numbers, and on Android with
/// `Factory.rive` the Rive one is what drops under load.
///
/// The scenarios worth measuring:
/// - one small graphic, and one large or complex one;
/// - several graphics, as separate textures and as one shared texture;
/// - graphics that move and scale (each scale step resizes the texture unless
///   [RenderResolution.layout] is used);
/// - Flutter content animating alongside Rive;
/// - pages of graphics kept alive off-screen, which is where texture memory
///   and pacing show up.
///
/// Scripted runs (device farms, CI): launch the page directly with a deep
/// link, no tapping required. Every control has a query parameter:
///
/// ```sh
/// adb shell am start -a android.intent.action.VIEW \
///   -d 'riveexample://bench?asset=rewards.riv&count=4&shared=0&stats=1'
/// ```
///
/// `stats=1` prints one `[rive-bench]` line per second (Flutter fps, Rive
/// replays/s and their costs) to the log, which is the only readout on
/// devices where a screenshot of the overlay is impractical. It reads the
/// same counters as the overlay, so leave the overlay off while using it.
class ExampleRendererBenchmark extends StatefulWidget {
  const ExampleRendererBenchmark({super.key, this.config = const BenchConfig()});

  final BenchConfig config;

  @override
  State<ExampleRendererBenchmark> createState() =>
      _ExampleRendererBenchmarkState();
}

/// Files bundled with this example that are useful to benchmark: a couple of
/// simple ones, a shape-heavy one, and two with feathers (which
/// `Factory.flutter` cannot draw, so those two only compare Rive builds).
const benchAssets = <String>[
  'little_machine.riv',
  'skills.riv',
  'vehicles.riv',
  'off_road_car.riv',
  'rewards.riv',
  'blinko.riv',
];

@immutable
class BenchConfig {
  const BenchConfig({
    this.asset = 'little_machine.riv',
    this.count = 1,
    this.shared = false,
    this.move = false,
    this.dots = 0,
    this.layoutResolution = false,
    this.pages = 0,
    this.stats = false,
  });

  /// Reads the config from a `riveexample://bench?...` deep link.
  factory BenchConfig.fromQuery(Map<String, String> q) {
    int asInt(String key, int fallback) =>
        int.tryParse(q[key] ?? '') ?? fallback;
    bool asBool(String key) => asInt(key, 0) != 0;
    return BenchConfig(
      asset: benchAssets.contains(q['asset'])
          ? q['asset']!
          : const BenchConfig().asset,
      count: asInt('count', 1).clamp(1, 16),
      shared: asBool('shared'),
      move: asBool('move'),
      dots: asInt('dots', 0).clamp(0, 60),
      layoutResolution: asBool('layout'),
      pages: asInt('pages', 0).clamp(0, 20),
      stats: asBool('stats'),
    );
  }

  final String asset;
  final int count;

  /// Draw every widget into one [RivePanel] texture instead of one each.
  final bool shared;

  /// Slide and scale every widget, like a game piece being dragged.
  final bool move;

  /// Flutter-drawn circles painted on top every frame.
  final int dots;

  /// Size textures from the layout instead of the on-screen scale, which
  /// stops [move] from resizing the texture every frame.
  final bool layoutResolution;

  /// Wrap the content in this many kept-alive pages, so off-screen graphics
  /// keep their textures and keep ticking.
  final int pages;

  /// Log a `[rive-bench]` line per second instead of using the overlay.
  final bool stats;

  BenchConfig copyWith({
    String? asset,
    int? count,
    bool? shared,
    bool? move,
    int? dots,
    bool? layoutResolution,
    int? pages,
  }) =>
      BenchConfig(
        asset: asset ?? this.asset,
        count: count ?? this.count,
        shared: shared ?? this.shared,
        move: move ?? this.move,
        dots: dots ?? this.dots,
        layoutResolution: layoutResolution ?? this.layoutResolution,
        pages: pages ?? this.pages,
        stats: stats,
      );
}

class _ExampleRendererBenchmarkState extends State<ExampleRendererBenchmark>
    with SingleTickerProviderStateMixin {
  late BenchConfig _config = widget.config;
  late final AnimationController _anim =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat();
  bool _controlsOpen = true;
  Timer? _stats;
  final Stopwatch _since = Stopwatch();
  int _frames = 0;
  double _buildMs = 0;
  double _rasterMs = 0;

  @override
  void initState() {
    super.initState();
    if (_config.stats) {
      SchedulerBinding.instance.addTimingsCallback(_onTimings);
      _since.start();
      _stats = Timer.periodic(const Duration(seconds: 1), _logStats);
    }
  }

  void _onTimings(List<FrameTiming> timings) {
    for (final timing in timings) {
      _frames++;
      _buildMs += timing.buildDuration.inMicroseconds / 1000;
      _rasterMs += timing.rasterDuration.inMicroseconds / 1000;
    }
  }

  void _logStats(Timer _) {
    // Timer.periodic drifts, and drifts most under the load this page
    // exists to measure, so rate by the real interval rather than by 1s.
    final seconds = _since.elapsedMicroseconds / 1e6;
    _since.reset();
    final frames = _frames == 0 ? 1 : _frames;
    final stats = deferredThreadStats(RiveExampleApp.getCurrentFactory);
    final replays = stats.frames == 0 ? 1 : stats.frames;
    // `rive` counts every texture's replays; the per-graphic rate is what a
    // viewer sees, and with a shared texture one replay covers them all.
    final riveRate = stats.frames / seconds;
    // `rive` counts every live texture's replays. Kept-alive pages keep
    // rendering off screen, so with pages there is no way to tell from here
    // how many textures the total covers: report it undivided.
    final perGraphic = _config.pages > 0
        ? ''
        : _config.shared
            ? '${riveRate.toStringAsFixed(1)}/s per graphic '
            : '${(riveRate / math.max(1, _config.count)).toStringAsFixed(1)}'
                '/s per graphic ';
    debugPrint('[rive-bench] flutter ${(_frames / seconds).toStringAsFixed(1)}fps '
        'build ${(_buildMs / frames).toStringAsFixed(1)}ms '
        'raster ${(_rasterMs / frames).toStringAsFixed(1)}ms · '
        'rive ${riveRate.toStringAsFixed(1)}/s total, '
        '$perGraphic'
        '(record ${(stats.recordUs / replays / 1000).toStringAsFixed(2)}ms, '
        'replay ${(stats.replayUs / replays / 1000).toStringAsFixed(2)}ms)');
    _frames = 0;
    _buildMs = 0;
    _rasterMs = 0;
  }

  @override
  void dispose() {
    if (_config.stats) {
      SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    }
    _stats?.cancel();
    _anim.dispose();
    super.dispose();
  }

  void _update(BenchConfig config) => setState(() => _config = config);

  @override
  Widget build(BuildContext context) {
    // A new file load per renderer and per file; the count and the rest are
    // handled without reloading.
    final content = _BenchContent(
      key: ValueKey('${RiveExampleApp.getCurrentFactory}/${_config.asset}'
          '/${_config.pages}'),
      config: _config,
      anim: _anim,
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(child: content),
                  if (_config.dots > 0)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: _Dots(_anim, _config.dots),
                        ),
                      ),
                    ),
                  // Pure Flutter: its smoothness is the app's frame rate.
                  Positioned(
                    left: 8,
                    top: 8,
                    child: RotationTransition(
                      turns: _anim,
                      child: Container(
                        width: 24,
                        height: 24,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _controls(),
          ],
        ),
      ),
    );
  }

  Widget _controls() {
    final config = _config;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${config.count} x ${config.asset}'
                    '${config.pages > 0 ? ' on ${config.pages} pages' : ''} · '
                    '${config.shared ? 'shared texture' : 'texture each'}',
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(_controlsOpen
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up),
                  onPressed: () =>
                      setState(() => _controlsOpen = !_controlsOpen),
                ),
              ],
            ),
            if (_controlsOpen) ...[
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: config.asset,
                      items: [
                        for (final asset in benchAssets)
                          DropdownMenuItem(value: asset, child: Text(asset)),
                      ],
                      onChanged: (asset) =>
                          _update(config.copyWith(asset: asset)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('${config.count}'),
                  Expanded(
                    flex: 2,
                    child: Slider(
                      value: config.count.toDouble(),
                      min: 1,
                      max: 16,
                      divisions: 15,
                      label: '${config.count} graphics',
                      onChanged: (value) =>
                          _update(config.copyWith(count: value.round())),
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('shared texture'),
                    selected: config.shared,
                    onSelected: (value) =>
                        _update(config.copyWith(shared: value)),
                  ),
                  FilterChip(
                    label: const Text('move + scale'),
                    selected: config.move,
                    onSelected: (value) => _update(config.copyWith(move: value)),
                  ),
                  FilterChip(
                    label: const Text('Flutter dots'),
                    selected: config.dots > 0,
                    onSelected: (value) =>
                        _update(config.copyWith(dots: value ? 60 : 0)),
                  ),
                  FilterChip(
                    label: const Text('layout resolution'),
                    selected: config.layoutResolution,
                    onSelected: (value) =>
                        _update(config.copyWith(layoutResolution: value)),
                  ),
                  FilterChip(
                    label: const Text('10 kept-alive pages'),
                    selected: config.pages > 0,
                    onSelected: (value) =>
                        _update(config.copyWith(pages: value ? 10 : 0)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The graphics themselves: one grid, or [BenchConfig.pages] kept-alive pages
/// of that grid in a [PageView].
class _BenchContent extends StatefulWidget {
  const _BenchContent({super.key, required this.config, required this.anim});

  final BenchConfig config;
  final AnimationController anim;

  @override
  State<_BenchContent> createState() => _BenchContentState();
}

class _BenchContentState extends State<_BenchContent> {
  File? _file;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final file = await File.asset(
      'assets/${widget.config.asset}',
      riveFactory: RiveExampleApp.getCurrentFactory,
    );
    if (!mounted) {
      file?.dispose();
      return;
    }
    setState(() => _file = file);
  }

  @override
  void dispose() {
    _file?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final file = _file;
    if (file == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (widget.config.pages == 0) {
      return _BenchGrid(file: file, config: widget.config, anim: widget.anim);
    }
    return PageView.builder(
      itemCount: widget.config.pages,
      itemBuilder: (context, index) => _KeptAlivePage(
        child: _BenchGrid(
          file: file,
          config: widget.config,
          anim: widget.anim,
        ),
      ),
    );
  }
}

/// Keeps a page's graphics alive once it has been visited, so their textures
/// and tickers stay around while other pages are on screen.
class _KeptAlivePage extends StatefulWidget {
  const _KeptAlivePage({required this.child});

  final Widget child;

  @override
  State<_KeptAlivePage> createState() => _KeptAlivePageState();
}

class _KeptAlivePageState extends State<_KeptAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class _BenchGrid extends StatefulWidget {
  const _BenchGrid({
    required this.file,
    required this.config,
    required this.anim,
  });

  final File file;
  final BenchConfig config;
  final AnimationController anim;

  @override
  State<_BenchGrid> createState() => _BenchGridState();
}

class _BenchGridState extends State<_BenchGrid> {
  final List<RiveWidgetController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _syncCount();
  }

  @override
  void didUpdateWidget(_BenchGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config.count != widget.config.count) {
      _syncCount();
    }
  }

  void _syncCount() {
    while (_controllers.length > widget.config.count) {
      _controllers.removeLast().dispose();
    }
    while (_controllers.length < widget.config.count) {
      _controllers.add(RiveWidgetController(widget.file));
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _cell(int index, RiveWidgetController controller) {
    Widget child = RiveWidget(
      controller: controller,
      fit: Fit.contain,
      useSharedTexture: widget.config.shared,
      renderResolution:
          widget.config.layoutResolution ? const RenderResolution.layout() : null,
    );
    if (widget.config.move) {
      child = AnimatedBuilder(
        animation: widget.anim,
        builder: (context, child) {
          final phase = widget.anim.value * 2 * math.pi + index;
          return Transform.translate(
            offset: Offset(math.sin(phase) * 24, math.cos(phase) * 24),
            child: Transform.scale(
              scale: 0.85 + 0.15 * math.sin(phase),
              child: child,
            ),
          );
        },
        child: child,
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    Widget grid = GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: math.max(1, math.sqrt(widget.config.count).ceil()),
      children: [
        for (var i = 0; i < _controllers.length; i++) _cell(i, _controllers[i]),
      ],
    );
    if (widget.config.shared) {
      grid = RivePanel(child: grid);
    }
    return grid;
  }
}

class _Dots extends CustomPainter {
  _Dots(this.anim, this.count) : super(repaint: anim);

  final AnimationController anim;
  final int count;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var i = 0; i < count; i++) {
      final phase = anim.value * 2 * math.pi + i * 0.37;
      paint.color = HSVColor.fromAHSV(0.8, (i * 37) % 360.0, 0.7, 1).toColor();
      canvas.drawCircle(
        Offset(
          size.width * (0.5 + 0.45 * math.sin(phase + i)),
          size.height * (0.5 + 0.45 * math.cos(phase * 1.3 + i * 0.5)),
        ),
        10 + (i % 5) * 3,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_Dots oldDelegate) => false;
}
