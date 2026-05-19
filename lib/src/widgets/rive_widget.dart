import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:meta/meta.dart';

/// A widget that displays a Rive artboard.
///
/// - The [controller] parameter is the [RiveWidgetController] that controls the
/// artboard and state machine. This controller builds on top of the concept
/// of a Rive painter, but provides a more convenient API for building
/// Rive widgets.
/// - The [fit] parameter is the fit of the artboard.
/// - The [alignment] parameter is the alignment of the artboard.
/// - The [hitTestBehavior] parameter is the hit test behavior of the artboard.
/// - The [cursor] parameter is the platform/Flutter cursor when interacting with an area that has a `hitTest` of `true`.
/// - The [layoutScaleFactor] parameter is the layout scale factor of the artboard when using `Fit.layout`.
/// - The [useSharedTexture] parameter is whether to use a shared texture ([RivePanel]) to draw the artboard to.
/// - The [sharedTexture] parameter is an explicit [SharedRenderTexture] to draw into, bypassing the
/// ancestor-based [RivePanel] lookup. Use this together with
/// [SharedRenderTexture.create] and [RiveSurface] to share a texture across
/// arbitrary parts of the widget tree (siblings, separate subtrees, across
/// routes, etc.).
/// - The [drawOrder] parameter is the draw order of the artboard. This is only used when drawing to a
/// shared texture (either via [useSharedTexture] + [RivePanel] or an
/// explicit [sharedTexture]), and using [Factory.rive].
class RiveWidget extends StatefulWidget {
  const RiveWidget({
    super.key,
    required this.controller,
    this.fit = RiveDefaults.fit,
    this.alignment = RiveDefaults.alignment,
    this.hitTestBehavior = RiveDefaults.hitTestBehaviour,
    this.cursor = RiveDefaults.mouseCursor,
    this.layoutScaleFactor = RiveDefaults.layoutScaleFactor,
    this.useSharedTexture = false,
    this.sharedTexture,
    this.drawOrder = 1,
  });

  /// The controller of the graphic. Manages the artboard, state machine and data binding.
  final RiveWidgetController controller;

  /// The fit of the artboard.
  ///
  /// Defaults to [RiveDefaults.fit].
  final Fit fit;

  /// The alignment of the artboard.
  ///
  /// Defaults to [RiveDefaults.alignment].
  final Alignment alignment;

  /// The hit test behavior of the artboard.
  ///
  /// Defaults to [RiveDefaults.hitTestBehaviour].
  final RiveHitTestBehavior hitTestBehavior;

  /// The cursor of the artboard.
  ///
  /// Defaults to [RiveDefaults.mouseCursor].
  final MouseCursor cursor;

  /// The layout scale factor of the artboard.
  ///
  /// Defaults to [RiveDefaults.layoutScaleFactor].
  final double layoutScaleFactor;

  /// Whether to use a shared texture [(RivePanel]) to draw the artboard to.
  ///
  /// Defaults to false. When set to true, it draws to the nearest ancestor
  /// [RivePanel] via inherited widget lookup. Ignored when [sharedTexture] is
  /// provided.
  ///
  /// **EXPERIMENTAL**: This API may change or be removed in a future release.
  @experimental
  final bool useSharedTexture;

  /// Explicit [SharedRenderTexture] to draw into, bypassing the
  /// ancestor-based [RivePanel] lookup. Use this together with
  /// [SharedRenderTexture.create] and [RiveSurface] to share a texture across
  /// arbitrary parts of the widget tree (siblings, separate subtrees, across
  /// routes, etc.).
  ///
  /// When non-null, this takes precedence over [useSharedTexture].
  ///
  /// **EXPERIMENTAL**: This API may change or be removed in a future release.
  @experimental
  final SharedRenderTexture? sharedTexture;

  /// The draw order of the artboard. This is only used when drawing to a
  /// shared texture (either via [useSharedTexture] + [RivePanel] or an
  /// explicit [sharedTexture]), and using [Factory.rive].
  ///
  /// Defaults to 1.
  final int drawOrder;

  @override
  State<RiveWidget> createState() => _RiveWidgetState();
}

class _RiveWidgetState extends State<RiveWidget> {
  @override
  void initState() {
    super.initState();
    _setupView();
  }

  void _setupView() {
    final controller = widget.controller;
    controller.alignment = widget.alignment;
    controller.fit = widget.fit;
    controller.hitTestBehavior = widget.hitTestBehavior;
    controller.cursor = widget.cursor;
    controller.layoutScaleFactor = widget.layoutScaleFactor;

    // Advance the state machine to ensure it is in a valid state.
    controller.advance(0);
  }

  @override
  void didUpdateWidget(covariant RiveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      // If the controller changes, we need to re-setup all the properties
      _setupView();
      return;
    }

    // Else we only update the properties that have changed.
    final controller = widget.controller;
    if (widget.alignment != oldWidget.alignment) {
      controller.alignment = widget.alignment;
    }
    if (widget.fit != oldWidget.fit) {
      controller.fit = widget.fit;
    }
    if (widget.hitTestBehavior != oldWidget.hitTestBehavior) {
      controller.hitTestBehavior = widget.hitTestBehavior;
    }
    if (widget.cursor != oldWidget.cursor) {
      controller.cursor = widget.cursor;
    }
    if (widget.layoutScaleFactor != oldWidget.layoutScaleFactor) {
      controller.layoutScaleFactor = widget.layoutScaleFactor;
    }

    // TODO (Gordon): Can optimize this out once we poll for changes.
    // At the moment, we give force a repaint the ensure Rive is updated
    // under the condition that the user is rebuilding the widget (calling
    // setState).
    controller.scheduleRepaint();
  }

  late final SharedTextureArtboardWidgetPainter _painter =
      SharedTextureArtboardWidgetPainter(widget.controller);

  @override
  Widget build(BuildContext context) {
    final explicitTexture = widget.sharedTexture;
    if (explicitTexture != null || widget.useSharedTexture) {
      if (widget.controller.artboard.riveFactory == Factory.flutter) {
        return errorWidget(
          'Shared textures are only supported when using Factory.rive',
        );
      }
      final sharedTexture = explicitTexture ?? RiveSharedTexture.of(context);
      if (sharedTexture == null) {
        return errorWidget(
          'RiveWidget requires a shared texture when useSharedTexture is true.\n'
          'Either wrap this widget with a RivePanel, or pass an explicit\n'
          'SharedRenderTexture via the sharedTexture parameter.',
        );
      }
      return SharedTextureView(
        artboard: widget.controller.artboard,
        painter: _painter,
        sharedTexture: sharedTexture,
        drawOrder: widget.drawOrder,
      );
    }

    return RiveArtboardWidget(
      artboard: widget.controller.artboard,
      painter: widget.controller,
    );
  }

  ErrorWidget errorWidget(String message) {
    return ErrorWidget.withDetails(
      message: message,
      error: FlutterError(message),
    );
  }
}
