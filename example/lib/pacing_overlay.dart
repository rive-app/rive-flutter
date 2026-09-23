// The pacing diagnostics are deliberately unexported (repo-internal, see
// packages/rive_native/DIAGNOSTICS.md).
// The example resolves rive_native through `rive`, not as a direct
// dependency, so that CI can repoint `rive` at the local path.
// ignore_for_file: implementation_imports, depend_on_referenced_packages
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rive/rive.dart' as rive;
import 'package:rive_native/rive_deferred.dart' as rive_deferred;
import 'package:rive_native/src/deferred_pacing_diagnostics.dart';

/// Toggleable diagnostics overlay for the example app: a small speed chip
/// that, when enabled, shows Rive's draw rate (replays/s, the number that
/// actually drops under load) next to Flutter's fps, the deferred pacing
/// counters (ticks / paints / skips, dedicated-texture path only), and the
/// native record/replay costs from `deferredThreadStats`.
///
/// Interpretation guide: packages/rive_native/DIAGNOSTICS.md.
class RivePacingOverlayHost extends StatefulWidget {
  const RivePacingOverlayHost({
    required this.riveFactory,
    required this.child,
    super.key,
  });

  /// The factory the examples currently render with; thread stats are read
  /// from its recording session (zeros for the Flutter renderer).
  final rive.Factory Function() riveFactory;
  final Widget child;

  @override
  State<RivePacingOverlayHost> createState() => _RivePacingOverlayHostState();
}

class _RivePacingOverlayHostState extends State<RivePacingOverlayHost> {
  bool _visible = false;
  Timer? _timer;
  int _frames = 0;
  DateTime _lastSample = DateTime.now();

  int _fps = 0;
  RiveDeferredPacingWindow? _pacing;
  ({double recordMs, double replayMs, double replaysPerSecond})? _threads;
  // Busy milliseconds per second on each thread. Record runs inside the
  // frame's ticker phase, so it is a subset of ui, not additive.
  ({double ui, double record, double raster, double render})? _busy;
  int _buildUs = 0;
  int _rasterUs = 0;
  TimingsCallback? _timingsCallback;

  void _toggle() {
    setState(() => _visible = !_visible);
    if (_visible) {
      RiveDeferredPacingDiagnostics.enabled = true;
      RiveDeferredPacingDiagnostics.onWindow = _onPacingWindow;
      _lastSample = DateTime.now();
      _frames = 0;
      _buildUs = 0;
      _rasterUs = 0;
      // Frames are counted from the timings callback (one entry per
      // rasterized frame) rather than a Ticker: an active ticker would force
      // a frame every vsync and perturb the pipeline it measures.
      _timingsCallback = (timings) {
        _frames += timings.length;
        for (final t in timings) {
          _buildUs += t.buildDuration.inMicroseconds;
          _rasterUs += t.rasterDuration.inMicroseconds;
        }
      };
      SchedulerBinding.instance.addTimingsCallback(_timingsCallback!);
      _timer = Timer.periodic(const Duration(seconds: 1), _sample);
    } else {
      _stopSampling();
      _pacing = null;
      _threads = null;
      _busy = null;
    }
  }

  void _stopSampling() {
    RiveDeferredPacingDiagnostics.enabled = false;
    RiveDeferredPacingDiagnostics.onWindow = null;
    _timer?.cancel();
    _timer = null;
    if (_timingsCallback != null) {
      SchedulerBinding.instance.removeTimingsCallback(_timingsCallback!);
      _timingsCallback = null;
    }
  }

  void _onPacingWindow(RiveDeferredPacingWindow window) {
    if (!mounted) return;
    setState(() => _pacing = window);
  }

  void _sample(Timer _) {
    final now = DateTime.now();
    final windowUs = now.difference(_lastSample).inMicroseconds;
    _lastSample = now;
    if (windowUs <= 0) return;
    final stats = rive_deferred.deferredThreadStats(widget.riveFactory());
    final seconds = windowUs / 1e6;
    setState(() {
      _fps = (_frames / seconds).round();
      _frames = 0;
      _threads = stats.frames > 0
          ? (
              recordMs: stats.recordUs / stats.frames / 1000,
              replayMs: stats.replayUs / stats.frames / 1000,
              replaysPerSecond: stats.frames / seconds,
            )
          : null;
      _busy = (
        ui: _buildUs / 1000 / seconds,
        record: stats.recordUs / 1000 / seconds,
        raster: _rasterUs / 1000 / seconds,
        render: stats.replayUs / 1000 / seconds,
      );
      _buildUs = 0;
      _rasterUs = 0;
    });
  }

  @override
  void dispose() {
    _stopSampling();
    super.dispose();
  }

  String _pacingLines() {
    final p = _pacing;
    if (p == null) {
      return 'pacing: waiting for a deferred texture...';
    }
    final perSecond = p.seconds <= 0 ? 1.0 : p.seconds;
    // Counters are sums across every ticking texture; divide them back down
    // so the line reads per texture regardless of instance count.
    final textures = p.textures > 0 ? p.textures : 1;
    String rate(int n) => (n / perSecond / textures).toStringAsFixed(1);
    // Painted vs ticked animation time as a ratio: 100% = no time banking.
    final timePct = p.tickedElapsed <= 0
        ? 100
        : (p.paintedElapsed / p.tickedElapsed * 100).round();
    final fails = p.clearFails + p.flushFails;
    return 'per tex (${p.textures}): ticks ${rate(p.ticks)}/s · '
        'paints ${rate(p.paints)}/s · time $timePct%\n'
        'skips: worker ${rate(p.skipsCanAccept)}/s · '
        'paused ${p.skipsPaused} · blocked ${p.skipsAttachBlocked}'
        '${fails > 0 ? ' · fails $fails' : ''}';
  }

  // Rive's actual draw rate: frames replayed on the render thread per
  // second, summed across every texture on the session, with the per-texture
  // share spelled out so aggregates never read as per-instance numbers.
  // Distinct from Flutter's fps, which stays at 60 while Rive paces lower.
  String _headline() {
    final t = _threads;
    if (t == null) {
      return 'rive -/s · flutter $_fps fps';
    }
    final textures = _pacing?.textures ?? 0;
    final perTexture = textures > 1
        ? ' (${(t.replaysPerSecond / textures).toStringAsFixed(1)}/s x $textures tex)'
        : '';
    return 'rive ${t.replaysPerSecond.toStringAsFixed(0)}/s$perTexture · '
        'flutter $_fps fps';
  }

  String _threadLine() {
    final t = _threads;
    if (t == null) {
      return 'record/replay: no session frames';
    }
    return 'per frame: record ${t.recordMs.toStringAsFixed(2)}ms · '
        'replay ${t.replayMs.toStringAsFixed(2)}ms';
  }

  // Total busy time per thread per second (1000 = saturated). ui is the
  // frame's build span, which already contains record; render is Rive's
  // replay thread.
  String _busyLine() {
    final b = _busy;
    if (b == null) {
      return '';
    }
    String ms(double v) => v.toStringAsFixed(0);
    return '\nbusy ms/s: ui ${ms(b.ui)} (record ${ms(b.record)}) · '
        'raster ${ms(b.raster)} · render ${ms(b.render)}';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      textDirection: TextDirection.ltr,
      children: [
        widget.child,
        Positioned(
          right: 8,
          top: MediaQuery.paddingOf(context).top + 8,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Material(
                  color: const Color(0xB0000000),
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _toggle,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.speed,
                        size: 18,
                        color: _visible
                            ? const Color(0xFF7FD4A0)
                            : const Color(0x80FFFFFF),
                      ),
                    ),
                  ),
                ),
                if (_visible) ...[
                  const SizedBox(height: 4),
                  IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xB0000000),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${_headline()}\n${_pacingLines()}\n${_threadLine()}'
                        '${_busyLine()}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Color(0xFF7FD4A0),
                          fontSize: 11,
                          fontFamily: 'monospace',
                          // Rendered above the Navigator, so no ambient
                          // DefaultTextStyle: opt out of the debug fallback.
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
