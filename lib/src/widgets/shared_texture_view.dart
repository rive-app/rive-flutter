import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/src/widgets/inherited_widgets.dart';
import 'package:rive_native/rive_native.dart';
import 'package:meta/meta.dart';

/// Renderers the [artboard] to a [sharedTexture].
///
/// See [RivePanel]. Only useful when using `Factory.rive`.
///
/// **EXPERIMENTAL**: This API may change or be removed in a future release.
@experimental
class SharedTextureView extends StatefulWidget {
  final Artboard artboard;
  final SharedTextureArtboardWidgetPainter painter;
  final SharedRenderTexture sharedTexture;
  final int drawOrder;
  const SharedTextureView({
    required this.artboard,
    required this.painter,
    required this.sharedTexture,
    required this.drawOrder,
    super.key,
  });

  @override
  State<SharedTextureView> createState() => _SharedTextureViewState();
}

class _SharedTextureViewState extends State<SharedTextureView> {
  @override
  void initState() {
    super.initState();
    widget.painter.artboardChanged(widget.artboard);
  }

  @override
  void didUpdateWidget(covariant SharedTextureView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.artboard != widget.artboard) {
      widget.painter.artboardChanged(widget.artboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SharedTextureViewRenderer(
      renderTexturePainter: widget.painter,
      sharedTexture: widget.sharedTexture,
      devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
      drawOrder: widget.drawOrder,
    );
  }
}

class SharedTextureViewRenderer extends LeafRenderObjectWidget {
  final RenderTexturePainter renderTexturePainter;
  final SharedRenderTexture sharedTexture;
  final double devicePixelRatio;
  final int drawOrder;

  const SharedTextureViewRenderer({
    super.key,
    required this.renderTexturePainter,
    required this.sharedTexture,
    required this.devicePixelRatio,
    required this.drawOrder,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return SharedTextureViewRenderObject(sharedTexture)
      ..painter = renderTexturePainter
      ..scrollPosition = Scrollable.maybeOf(context)?.position
      ..devicePixelRatio = devicePixelRatio
      ..drawOrder = drawOrder;
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant SharedTextureViewRenderObject renderObject,
  ) {
    renderObject
      ..shared = sharedTexture
      ..painter = renderTexturePainter
      ..scrollPosition = Scrollable.maybeOf(context)?.position
      ..devicePixelRatio = devicePixelRatio
      ..drawOrder = drawOrder;
  }

  @override
  void didUnmountRenderObject(
    covariant SharedTextureViewRenderObject renderObject,
  ) {}
}

class SharedTextureViewRenderObject
    extends RiveNativeRenderBox<RenderTexturePainter>
    implements SharedTexturePainter {
  SharedRenderTexture _shared;

  SharedTextureViewRenderObject(this._shared) {
    _shared.texture.onTextureChanged = _onRiveTextureChanged;
  }

  int drawOrder = 1;

  SharedRenderTexture get shared => _shared;
  set shared(SharedRenderTexture value) {
    if (_shared == value) {
      return;
    }
    _shared.texture.onTextureChanged = null;
    _shared.removePainter(this);
    _shared = value;
    _shared.texture.onTextureChanged = _onRiveTextureChanged;
    _shared.addPainter(this);
    markNeedsPaint();
  }

  bool _shouldAdvance = true;

  @override
  bool get shouldAdvance => _shouldAdvance;

  // Repaint when the texture is created/changed. This reduces the flicker when
  // resizing the widget. This flicker is caused by recreating the underlying
  // texture Rive draws to.
  void _onRiveTextureChanged() => markNeedsLayout();

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.smallest;

  @override
  void paint(PaintingContext context, Offset offset) => _shared.schedulePaint();

  ScrollPosition? _scrollPosition;
  set scrollPosition(ScrollPosition? v) {
    if (identical(v, _scrollPosition)) return;
    _unsubscribe();
    _scrollPosition = v;
    _subscribe();
    _scheduleCheck();
  }

  void _subscribe() => _scrollPosition?.addListener(_scheduleCheck);
  void _unsubscribe() => _scrollPosition?.removeListener(_scheduleCheck);

  void _scheduleCheck() {
    if (!attached) return;
    markNeedsPaint();
  }

  @override
  void dispose() {
    _shared.removePainter(this);
    _shared.texture.onTextureChanged = null;
    super.dispose();
  }

  @override
  void paintIntoSharedTexture(RenderTexture texture) {
    // TODO (Gordon): could move out this logic to calculate the position only under certain conditions.
    final panelKeyContext = shared.panelKey.currentContext;
    if (panelKeyContext == null) {
      return;
    }
    RenderBox renderBox = panelKeyContext.findRenderObject() as RenderBox;
    Offset panelPosition = renderBox.localToGlobal(Offset.zero);
    Offset globalPosition = localToGlobal(Offset.zero) - panelPosition;

    final renderer = texture.renderer;

    renderer.save();
    renderer.translate(
      globalPosition.dx * devicePixelRatio,
      globalPosition.dy * devicePixelRatio,
    );
    final scaledSize = size * devicePixelRatio;
    final needsAdvance = rivePainter?.paint(
            texture, devicePixelRatio, scaledSize, elapsedSeconds) ??
        false;

    _shouldAdvance = elapsedSeconds == 0 ? true : needsAdvance;

    renderer.restore();
  }

  @override
  int get sharedDrawOrder => drawOrder;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    markNeedsLayout();
    _shared.addPainter(this);
  }

  @override
  void frameCallback(Duration duration) {
    super.frameCallback(duration);
    _shared.schedulePaint();
  }

  @override
  void detach() {
    _unsubscribe();
    _scrollPosition = null;
    _shared.removePainter(this);
    super.detach();
  }
}

base class SharedTextureArtboardWidgetPainter
    extends ArtboardWidgetPainter<ArtboardPainter> {
  SharedTextureArtboardWidgetPainter(ArtboardPainter super.painter);

  void artboardChanged(Artboard artboard) => painter?.artboardChanged(artboard);
}
