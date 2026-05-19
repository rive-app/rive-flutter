// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// Demonstrates [SharedRenderTexture.create] + [RiveSurface] for a case where
/// the ancestor-based [RivePanel] lookup does not work.
///
/// The screen is a grid of Rive "thumbnails". Tapping a thumbnail "flies" it
/// out to a centered preview — the preview is mounted via [OverlayEntry] and
/// animates its bounds from the tile's rect to a centered rect using an
/// [AnimationController]. Both the thumbnails *and* the preview paint into a
/// single shared native texture owned by this page, *and* the preview reuses
/// the tapped tile's [RiveWidgetController] so the state machine continues
/// uninterrupted — there's no visual or logical reset.
///
/// ## Why this needs the explicit shared-texture API
///
/// [OverlayEntry] (and [showDialog], [showModalBottomSheet], drag overlays,
/// custom tooltips, etc.) mounts its widget into the nearest [Navigator]'s
/// [Overlay]. That [Overlay] is a **sibling** of the current route — not a
/// descendant of anything inside the route. A [RivePanel] placed inside this
/// screen is therefore not an ancestor of the preview's [RiveWidget], so
/// `useSharedTexture: true` (which finds the panel via inherited-widget
/// lookup) silently fails to share with it.
///
/// With [SharedRenderTexture.create] the texture is just a value held in
/// state, passed explicitly to whichever widget needs to render into it —
/// regardless of where that widget lives in the tree.
///
/// Here we use one [AnimationController] driving an animated [Positioned]
/// inside the [OverlayEntry], and swap the tile out for a placeholder while
/// the preview owns the controller. Exactly one [RiveWidget] is attached
/// per controller at any moment.
class ExampleRivePanelOverlay extends StatefulWidget {
  const ExampleRivePanelOverlay({super.key});

  @override
  State<ExampleRivePanelOverlay> createState() =>
      _ExampleRivePanelOverlayState();
}

class _ExampleRivePanelOverlayState extends State<ExampleRivePanelOverlay>
    with SingleTickerProviderStateMixin {
  // Page-scoped: created in initState, disposed when the page disposes. The
  // texture's lifetime is decoupled from the widget tree's shape.
  late final SharedRenderTexture _shared = SharedRenderTexture.create(
    backgroundColor: Colors.transparent,
  );

  late final FileLoader _fileLoader = FileLoader.fromAsset(
    'assets/rating.riv',
    riveFactory: Factory.rive,
  );

  // One controller per tile, owned here at the page level so the same
  // instance can be handed to the preview's RiveWidget when a tile is
  // tapped — the state machine carries straight through the flight.
  List<RiveWidgetController> _controllers = const [];

  late final AnimationController _flight = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );

  OverlayEntry? _previewEntry;
  int? _previewIndex;
  Rect? _tileRect;
  Rect? _destRect;

  static const int _gridItemCount = 16;

  @override
  void initState() {
    super.initState();
    _loadControllers();
  }

  Future<void> _loadControllers() async {
    final file = await _fileLoader.file();
    if (!mounted) return;
    setState(() {
      _controllers = List.generate(
        _gridItemCount,
        (_) => RiveWidgetController(file),
      );
    });
  }

  @override
  void dispose() {
    _previewEntry?.remove();
    _previewEntry = null;
    _flight.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    _fileLoader.dispose();
    _shared.dispose();
    super.dispose();
  }

  void _openPreview(int index, Rect tileRect) {
    if (_previewIndex != null) return; // already animating one
    final surfaceBox =
        _shared.panelKey.currentContext?.findRenderObject() as RenderBox?;
    if (surfaceBox == null) return;
    final surfaceOrigin = surfaceBox.localToGlobal(Offset.zero);
    final surfaceSize = surfaceBox.size;
    final dim = (surfaceSize.shortestSide * 0.7).clamp(280.0, 560.0).toDouble();
    final destRect = Rect.fromLTWH(
      surfaceOrigin.dx + (surfaceSize.width - dim) / 2,
      surfaceOrigin.dy + (surfaceSize.height - dim) / 2,
      dim,
      dim,
    );

    setState(() {
      _previewIndex = index;
      _tileRect = tileRect;
      _destRect = destRect;
    });

    _previewEntry = OverlayEntry(builder: _buildPreviewOverlay);
    Overlay.of(context).insert(_previewEntry!);
    _flight.forward(from: 0);
  }

  Future<void> _closePreview() async {
    if (_previewEntry == null) return;
    await _flight.reverse();
    _previewEntry?.remove();
    _previewEntry = null;
    if (!mounted) return;
    setState(() {
      _previewIndex = null;
      _tileRect = null;
      _destRect = null;
    });
  }

  Widget _buildPreviewOverlay(BuildContext context) {
    final index = _previewIndex;
    final tileRect = _tileRect;
    final destRect = _destRect;
    if (index == null || tileRect == null || destRect == null) {
      return const SizedBox.shrink();
    }
    final tween = RectTween(begin: tileRect, end: destRect);
    return Stack(
      children: [
        // Barrier — taps outside the preview dismiss it.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _closePreview,
            child: Container(color: Colors.transparent),
          ),
        ),
        AnimatedBuilder(
          animation: _flight,
          builder: (context, _) {
            final t = Curves.easeInOutCubic.transform(_flight.value);
            final rect = tween.transform(t)!;
            return Positioned.fromRect(
              rect: rect,
              child: _PreviewCard(
                index: index,
                controller: _controllers[index],
                sharedTexture: _shared,
                onDismiss: _closePreview,
                // Border grows in from thin → thick alongside the flight, so
                // the framing reads as if it's morphing out of the tile.
                borderWidth: 1 + 2 * t,
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.black26,
          child: const Text(
            'Tap a tile to fly it out to a centered preview. The preview is '
            'mounted via OverlayEntry — outside this route\'s subtree — and '
            'reuses the tapped tile\'s RiveWidgetController so the state '
            'machine continues uninterrupted. All tiles + the preview paint '
            'into one SharedRenderTexture owned by this page.',
            style: TextStyle(fontSize: 12, height: 1.4),
          ),
        ),
        Expanded(
          child: _controllers.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    // Visible texture pixels appear here. Placed explicitly
                    // so the texture can also be addressed from widgets
                    // mounted into the Overlay above this route.

                    GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ),
                      itemCount: _gridItemCount,
                      itemBuilder: (context, index) {
                        return _ThumbnailTile(
                          index: index,
                          controller: _controllers[index],
                          sharedTexture: _shared,
                          // While the preview owns this controller, render a
                          // placeholder here so only one RiveWidget is
                          // attached per controller — no double-advance.
                          isPreviewing: _previewIndex == index,
                          onTap: _openPreview,
                        );
                      },
                    ),
                    Positioned.fill(
                      child: RiveSurface(sharedTexture: _shared),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _ThumbnailTile extends StatefulWidget {
  const _ThumbnailTile({
    required this.index,
    required this.controller,
    required this.sharedTexture,
    required this.isPreviewing,
    required this.onTap,
  });

  final int index;
  final RiveWidgetController controller;
  final SharedRenderTexture sharedTexture;
  final bool isPreviewing;
  final void Function(int index, Rect tileRect) onTap;

  @override
  State<_ThumbnailTile> createState() => _ThumbnailTileState();
}

class _ThumbnailTileState extends State<_ThumbnailTile> {
  final GlobalKey _key = GlobalKey();

  void _handleTap() {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final topLeft = box.localToGlobal(Offset.zero);
    widget.onTap(widget.index, topLeft & box.size);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,
      onTap: _handleTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.isPreviewing ? Colors.amber : Colors.white24,
            width: widget.isPreviewing ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        // When the preview owns the controller, render *nothing* in the
        // tile slot. Detaching the tile's RiveWidget detaches its painter
        // from the shared texture so only the preview's painter is active.
        child: widget.isPreviewing
            ? const SizedBox.expand()
            : RiveWidget(
                controller: widget.controller,
                fit: Fit.contain,
                // Pass-through so the wrapping GestureDetector handles taps.
                hitTestBehavior: RiveHitTestBehavior.transparent,
                sharedTexture: widget.sharedTexture,
              ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.index,
    required this.controller,
    required this.sharedTexture,
    required this.onDismiss,
    required this.borderWidth,
  });

  final int index;
  final RiveWidgetController controller;
  final SharedRenderTexture sharedTexture;
  final VoidCallback onDismiss;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.amber,
          width: borderWidth,
        ),
      ),
      // Transparent so the texture (which lives in the page's body, *behind*
      // this Overlay layer) shows through and reveals the Rive content
      // painted at this widget's screen position.
      color: Colors.black.withOpacity(0.1),
      child: GestureDetector(
        onTap: onDismiss,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                // Same RiveWidgetController as the tile — state continues
                // mid-flight. The OverlayEntry is not a descendant of any
                // RivePanel in the route's body; passing the texture
                // explicitly is the only way to share with it.
                child: RiveWidget(
                  controller: controller,
                  fit: Fit.contain,
                  hitTestBehavior: RiveHitTestBehavior.transparent,
                  sharedTexture: sharedTexture,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  'Preview #${index + 1}  ·  tap to dismiss',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
