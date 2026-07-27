import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// Test bed for [RenderResolution]: how the backing texture is sized under an
/// ancestor transform, per policy, for both an own-texture [RiveWidget] and a
/// shared-texture surface ([RiveSurface]).
///
/// Things to try (Factory.rive only — the policy is a no-op for
/// Factory.flutter):
/// - Bump the scale with `display`: the graphic re-renders sharp at the new
///   on-screen footprint (on web, watch `canvas.width` in DevTools follow it).
/// - Same with `layout`: the backing stays at layout size and the upscale
///   just stretches it (softer) — the GPU-budget decoupling.
/// - `fixed 200×200`: the backing never changes, regardless of scale or
///   window size.
/// - Surface mode reads the backing size live below the controls; own-texture
///   mode keeps the texture internal, so use DevTools there.
class ExampleRenderResolution extends StatefulWidget {
  const ExampleRenderResolution({super.key});

  @override
  State<ExampleRenderResolution> createState() =>
      _ExampleRenderResolutionState();
}

class _ExampleRenderResolutionState extends State<ExampleRenderResolution> {
  static const _policies = <(String, RenderResolution)>[
    ('display', RenderResolution.display()),
    ('layout', RenderResolution.layout()),
    ('layout x0.5', RenderResolution.layout(scale: 0.5)),
    ('fixed 200x200', RenderResolution.fixed(200, 200)),
  ];
  static const _scales = <double>[0.5, 1, 2, 4];

  bool isInitialized = false;
  late final File file;
  late final RiveWidgetController controller;

  // The surface is created up front so surface mode can display its live
  // backing size; it only allocates once a RiveSurface lays it out.
  late final SharedRenderTexture _shared = SharedRenderTexture.create();

  int policyIndex = 0;
  double scale = 1;
  bool useSurface = false;

  RenderResolution get policy => _policies[policyIndex].$2;

  @override
  void initState() {
    super.initState();
    _initRive();
  }

  Future<void> _initRive() async {
    file = (await File.asset(
      'assets/rating.riv',
      riveFactory: Factory.rive,
    ))!;
    controller = RiveWidgetController(file);
    setState(() => isInitialized = true);
  }

  @override
  void dispose() {
    _shared.dispose();
    controller.dispose();
    file.dispose();
    super.dispose();
  }

  Widget _riveContent() {
    if (!useSurface) {
      return RiveWidget(
        controller: controller,
        fit: Fit.contain,
        renderResolution: policy,
      );
    }
    // Surface mode: the surface owns the allocation (and its policy); the
    // widget just paints into it. The Transform above this stack is shared by
    // surface and widget, so it cancels out of the painter transform and only
    // affects the surface's backing allocation.
    return Stack(
      children: [
        Positioned.fill(
          child: RiveSurface(sharedTexture: _shared, renderResolution: policy),
        ),
        RiveWidget(
          controller: controller,
          fit: Fit.contain,
          sharedTexture: _shared,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    final backing = useSurface
        ? '${_shared.texture.actualWidth} × ${_shared.texture.actualHeight}'
        : 'internal — check canvas.width in DevTools (web)';
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    for (var i = 0; i < _policies.length; i++)
                      ChoiceChip(
                        label: Text(_policies[i].$1),
                        selected: policyIndex == i,
                        onSelected: (_) => setState(() => policyIndex = i),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final s in _scales)
                      ChoiceChip(
                        label: Text('x$s'),
                        selected: scale == s,
                        onSelected: (_) => setState(() => scale = s),
                      ),
                  ],
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: const Text('Shared surface (RiveSurface owns policy)'),
                  value: useSurface,
                  onChanged: (v) => setState(() => useSurface = v),
                ),
                Row(
                  children: [
                    Expanded(child: Text('Backing: $backing')),
                    IconButton(
                      tooltip: 'Refresh backing readout',
                      icon: const Icon(Icons.refresh),
                      onPressed: () => setState(() {}),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Transform.scale(
              scale: scale,
              child: SizedBox(width: 250, height: 250, child: _riveContent()),
            ),
          ),
        ),
      ],
    );
  }
}
