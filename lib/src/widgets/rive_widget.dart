import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// A widget that displays a Rive artboard.
///
/// - The [controller] parameter is the [RiveControlelr] that controls the
/// artboard and state machine. This controller builds on top of the concept
/// of a Rive painter, but provides a more convenient API for building
/// Rive widgets.
/// - The [fit] parameter is the fit of the artboard.
/// - The [alignment] parameter is the alignment of the artboard.
/// - The [hitTestBehavior] parameter is the hit test behavior of the artboard.
class RiveWidget extends StatefulWidget {
  const RiveWidget({
    super.key,
    required this.controller,
    this.fit = RiveDefaults.fit,
    this.alignment = RiveDefaults.alignment,
    this.hitTestBehavior = RiveDefaults.hitTestBehaviour,
    this.cursor = RiveDefaults.mouseCursor,
    this.layoutScaleFactor = RiveDefaults.layoutScaleFactor,
  });
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

  @override
  Widget build(BuildContext context) {
    return RiveArtboardWidget(
      artboard: widget.controller.artboard,
      painter: widget.controller,
    );
  }
}
