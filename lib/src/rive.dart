import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/src/controllers/state_machine_controller.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_render_box.dart';
import 'package:rive/src/runtime_artboard.dart';
import 'package:rive_common/math.dart';

/// How to behave during hit tests on Rive Listeners (hit targets).
enum RiveHitTestBehavior {
  /// The bounds of the Rive animation will consume all hits, even if there is
  /// no animation listener (hit area) at the target point. Content
  /// behind the animation will not receive hits.
  opaque,

  /// Rive will only consume hits where there is a listener (hit area) at the
  /// target point. Content behind the animation will only receive hits if
  /// no animation listener was hit.
  translucent,

  /// All hits will pass through the animation, regardless of whether a
  /// a Rive listener was hit. Rive listeners will still receive hits.
  transparent,
}

class Rive extends LeafRenderObjectWidget {
  /// Artboard used for drawing
  final Artboard artboard;

  /// {@template Rive.useArtboardSize}
  /// Determines whether to use the inherent size of the [artboard], i.e. the
  /// absolute size defined by the artboard, or size the widget based on the
  /// available constraints only (sized by parent).
  ///
  /// Defaults to `false`, i.e. defaults to sizing based on the available
  /// constraints instead of the artboard size.
  ///
  /// When `true`, the artboard size is constrained by the parent constraints.
  /// Using the artboard size has the benefit that the widget now has an
  /// *intrinsic* size.
  ///
  /// When `false`, the intrinsic size is `(0, 0)` because
  /// there is no size intrinsically - it only comes from the parent
  /// constraints. Consequently, if you intend to use the widget in the subtree
  /// of an [IntrinsicWidth] or [IntrinsicHeight] widget or intend to directly
  /// obtain the [RenderBox.getMinIntrinsicWidth] et al., you will want to set
  /// this to `true`.
  /// {@endtemplate}
  final bool useArtboardSize;

  /// Fit for the rendering artboard
  final BoxFit fit;

  /// Alignment for the rendering artboard
  final Alignment alignment;

  /// Enables/disables antialiasing
  final bool antialiasing;

  /// Enable input listeners (such as hover, pointer down, etc.) on the
  /// artboard.
  ///
  /// Default `false`.
  final bool enablePointerEvents;

  /// The mouse cursor for mouse pointers that are hovering over the region.
  ///
  /// When a mouse enters the region, its cursor will be changed to the
  /// [cursor]. When the mouse leaves the region, the cursor will be decided by
  /// the region found at the new location.
  ///
  /// The [cursor] defaults to [MouseCursor.defer], deferring the choice of
  /// cursor to the next region behind it in hit-test order.
  final MouseCursor cursor;

  /// {@template Rive.behavior}
  /// How to behave during hit testing to consider targets behind this
  /// animation.
  ///
  /// Defaults to [RiveHitTestBehavior.opaque].
  ///
  /// See [RiveHitTestBehavior] for the allowed values and their meanings.
  /// {@endtemplate}
  final RiveHitTestBehavior behavior;

  /// {@template Rive.clipRect}
  /// Clip the artboard to this rect.
  ///
  /// If not supplied it'll default to the constraint size provided by the
  /// parent widget. Unless the [Artboard] has clipping disabled, then no
  /// clip will be applied.
  /// {@endtemplate}
  final Rect? clipRect;

  const Rive({
    required this.artboard,
    this.useArtboardSize = false,
    this.antialiasing = true,
    this.enablePointerEvents = false,
    this.cursor = MouseCursor.defer,
    this.behavior = RiveHitTestBehavior.opaque,
    BoxFit? fit,
    Alignment? alignment,
    this.clipRect,
  })  : fit = fit ?? BoxFit.contain,
        alignment = alignment ?? Alignment.center;

  @override
  RenderObject createRenderObject(BuildContext context) {
    // Doing this here and not in constructor so it can remain const
    artboard.antialiasing = antialiasing;
    final tickerModeValue = TickerMode.of(context);
    return RiveRenderObject(artboard as RuntimeArtboard)
      ..fit = fit
      ..alignment = alignment
      ..artboardSize = Size(artboard.width, artboard.height)
      ..useArtboardSize = useArtboardSize
      ..clipRect = clipRect
      ..tickerModeEnabled = tickerModeValue
      ..enableHitTests = enablePointerEvents
      ..cursor = cursor
      ..behavior = behavior;
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RiveRenderObject renderObject) {
    final tickerModeValue = TickerMode.of(context);
    artboard.antialiasing = antialiasing;
    renderObject
      ..artboard = artboard
      ..fit = fit
      ..alignment = alignment
      ..artboardSize = Size(artboard.width, artboard.height)
      ..useArtboardSize = useArtboardSize
      ..clipRect = clipRect
      ..tickerModeEnabled = tickerModeValue
      ..enableHitTests = enablePointerEvents
      ..cursor = cursor
      ..behavior = behavior;
  }
}

class RiveRenderObject extends RiveRenderBox implements MouseTrackerAnnotation {
  RuntimeArtboard _artboard;
  RiveRenderObject(
    this._artboard, {
    this.behavior = RiveHitTestBehavior.opaque,
    MouseCursor cursor = MouseCursor.defer,
    bool validForMouseTracker = true,
  })  : _cursor = cursor,
        _validForMouseTracker = validForMouseTracker {
    _artboard.redraw.addListener(scheduleRepaint);
  }

  RuntimeArtboard get artboard => _artboard;

  set artboard(Artboard value) {
    if (_artboard == value) {
      return;
    }
    _artboard.redraw.removeListener(scheduleRepaint);
    _artboard = value as RuntimeArtboard;
    _artboard.redraw.addListener(scheduleRepaint);
    markNeedsLayout();
  }

  /// Local offset to global artboard position
  Vec2D _toArtboard(Offset local) {
    final globalCoordinates = localToGlobal(local);
    return globalToArtboard(globalCoordinates);
  }

  /// Helper to manage hit testing
  void _hitHelper(PointerEvent event,
      void Function(StateMachineController, Vec2D) callback) {
    final artboardPosition = _toArtboard(event.localPosition);
    final stateMachineControllers =
        _artboard.animationControllers.whereType<StateMachineController>();
    for (final stateMachineController in stateMachineControllers) {
      callback(stateMachineController, artboardPosition);
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    // super.hitTest(result, position: position)
    bool hitTarget = false;
    if (size.contains(position)) {
      hitTarget = hitTestSelf(position);
      if (hitTarget) {
        // if hit add to results
        result.add(BoxHitTestEntry(this, position));
      }
    }

    // Let the hit continue to targets behind the animation.
    if (behavior == RiveHitTestBehavior.transparent) {
      return false;
    }

    // Opaque will always return true, translucent will return true if we
    // hit a Rive listener target.
    return hitTarget;
  }

  @override
  bool hitTestSelf(Offset screenOffset) {
    switch (behavior) {
      case RiveHitTestBehavior.opaque:
        return true; // Always hit
      case RiveHitTestBehavior.translucent:
      case RiveHitTestBehavior.transparent:
        {
          // test to see if any Rive animation listeners were hit
          final artboardPosition = _toArtboard(screenOffset);
          final stateMachineControllers = _artboard.animationControllers
              .whereType<StateMachineController>();
          for (final stateMachineController in stateMachineControllers) {
            if (stateMachineController.hitTest(artboardPosition)) {
              return true;
            }
          }
        }
    }
    return false;
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (!enableHitTests || !attached) {
      return;
    }
    if (event is PointerDownEvent) {
      _hitHelper(
        event,
        (controller, artboardPosition) =>
            controller.pointerDown(artboardPosition, event),
      );
    }
    if (event is PointerUpEvent) {
      _hitHelper(
        event,
        (controller, artboardPosition) =>
            controller.pointerUp(artboardPosition),
      );
    }
    if (event is PointerMoveEvent) {
      _hitHelper(
        event,
        (controller, artboardPosition) =>
            controller.pointerMove(artboardPosition),
      );
    }
    if (event is PointerHoverEvent) {
      _hitHelper(
        event,
        (controller, artboardPosition) =>
            controller.pointerMove(artboardPosition),
      );
    }
  }

  @override
  PointerEnterEventListener? get onEnter => (event) {
        if (!enableHitTests) return;
        _hitHelper(
          event,
          (controller, artboardPosition) =>
              controller.pointerEnter(artboardPosition),
        );
      };

  @override
  PointerExitEventListener? get onExit => (event) {
        if (!enableHitTests) return;
        _hitHelper(
          event,
          (controller, artboardPosition) =>
              controller.pointerExit(artboardPosition),
        );
      };

  @override
  MouseCursor get cursor => _cursor;
  MouseCursor _cursor;
  set cursor(MouseCursor value) {
    if (_cursor != value) {
      _cursor = value;
      // A repaint is needed in order to trigger a device update of
      // [MouseTracker] so that this new value can be found.
      markNeedsPaint();
    }
  }

  @override
  bool get validForMouseTracker => _validForMouseTracker;
  bool _validForMouseTracker;

  /// {@macro Rive.behavior}
  RiveHitTestBehavior behavior;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _validForMouseTracker = true;
  }

  @override
  void detach() {
    // It's possible that the renderObject be detached during mouse events
    // dispatching, set the [MouseTrackerAnnotation.validForMouseTracker] false
    // to prevent the callbacks from being called.
    _validForMouseTracker = false;
    super.detach();
  }

  @override
  void dispose() {
    _artboard.redraw.removeListener(scheduleRepaint);
    super.dispose();
  }

  @override
  AABB get aabb {
    var width = _artboard.width;
    var height = _artboard.height;
    return AABB.fromValues(0, 0, width, height);
  }

  @override
  bool advance(double elapsedSeconds) =>
      _artboard.advance(elapsedSeconds, nested: true);

  @override
  void beforeDraw(Canvas canvas, Offset offset) {
    // Apply clip rect if provided and return early
    if (clipRect != null) {
      return canvas.clipRect(clipRect!);
    }
    if (artboard.clip) {
      canvas.clipRect(offset & size);
    }
  }

  @override
  void draw(Canvas canvas, Mat2D viewTransform) {
    canvas.transform(viewTransform.mat4);
    artboard.draw(canvas);
  }
}
