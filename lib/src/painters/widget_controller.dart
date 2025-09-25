import 'package:flutter/gestures.dart';
import 'package:rive/rive.dart';

/// {@template rive_controller}
/// This controller builds on top of the concept of a Rive painter, but
/// provides a more convenient API for building Rive widgets.
///
/// To be used with [RiveWidget] and [RiveWidgetBuilder] widgets.
/// {@endtemplate}
base class RiveWidgetController extends BasicArtboardPainter
    with RivePointerEventMixin {
  /// The Rive file to this controller is built from.
  final File file;

  @override

  /// The artboard that the [RiveWidgetController] is painting.
  late final Artboard artboard;

  /// The state machine that the [RiveWidgetController] is using.
  late final StateMachine stateMachine;

  /// {@macro rive_controller}
  /// - The [file] parameter is the Rive file to paint.
  /// - The [artboardSelector] parameter specifies which artboard to use.
  /// - The [stateMachineSelector] parameter specifies which state machine to use.
  RiveWidgetController(
    this.file, {
    ArtboardSelector artboardSelector = const ArtboardDefault(),
    StateMachineSelector stateMachineSelector = const StateMachineDefault(),
  }) {
    artboard = _createArtboard(file, artboardSelector);
    stateMachine = _createStateMachine(artboard, stateMachineSelector);
  }

  /// Whether the state machine advanced during the last tick.
  var _didAdvance = false;

  /// Whether the state machine has been scheduled for repaint.
  ///
  /// Set to false in [advance] (paint).
  var _repaintScheduled = false;

  /// The previous hit result observed.
  var _previousHitResult = HitResult.none;

  Artboard _createArtboard(File file, ArtboardSelector artboardSelector) {
    final artboard = switch (artboardSelector) {
      ArtboardDefault() => file.defaultArtboard(),
      ArtboardNamed(:final name) => file.artboard(name),
      ArtboardAtIndex(:final index) => file.artboardAt(index),
    };
    if (artboard == null) {
      final message = switch (artboardSelector) {
        ArtboardDefault() => 'Default artboard not found.',
        ArtboardNamed(:final name) => 'Artboard with name "$name" not found.',
        ArtboardAtIndex(:final index) => 'Artboard at index $index not found.',
      };
      throw RiveArtboardException(message);
    }
    return artboard;
  }

  StateMachine _createStateMachine(
    Artboard artboard,
    StateMachineSelector stateMachineSelector,
  ) {
    final stateMachine = switch (stateMachineSelector) {
      StateMachineDefault() => artboard.defaultStateMachine(),
      StateMachineNamed(:final name) => artboard.stateMachine(name),
      StateMachineAtIndex(:final index) => artboard.stateMachineAt(index),
    };
    if (stateMachine == null) {
      final message = switch (stateMachineSelector) {
        StateMachineDefault() => 'Default state machine not found.',
        StateMachineNamed(:final name) =>
          'State machine with name "$name" not found.',
        StateMachineAtIndex(:final index) =>
          'State machine at index $index not found.',
      };
      throw RiveStateMachineException(message);
    }
    stateMachine.addAdvanceRequestListener(scheduleRepaint);
    return stateMachine;
  }

  /// Whether this controller is active (painting and advancing).
  bool _active = true;
  bool get active => _active;
  set active(bool value) {
    _active = value;
    notifyListeners();
  }

  /// Binds a [ViewModelInstance] to the [StateMachine].
  ///
  /// - The [dataBind] parameter specifies which view model instance to bind to
  /// the [StateMachine].
  ///
  /// Returns the [ViewModelInstance] that was bound to the [StateMachine].
  ///
  /// Throws a [RiveDataBindException] if the [ViewModelInstance] could not be
  /// found.
  ViewModelInstance dataBind(DataBind dataBind) {
    final vmi = switch (dataBind) {
      AutoBind() => file.createDefaultViewModelInstance(artboard),
      BindByInstance() => dataBind.viewModelInstance,
      BindByIndex() => _safeViewModel?.createInstanceByIndex(dataBind.index),
      BindByName() => _safeViewModel?.createInstanceByName(dataBind.name),
      BindEmpty() => _safeViewModel?.createInstance(),
    };
    if (vmi == null) {
      final message = switch (dataBind) {
        AutoBind() =>
          'Default view model instance not found. Make sure the instance is set to exported in the Rive Editor.',
        BindByInstance() => 'Failed to use the provided view model instance.',
        BindByIndex() =>
          'View model instance by index `${dataBind.index}` not found.',
        BindByName() =>
          'View model instance by name `${dataBind.name}` not found.',
        BindEmpty() =>
          'Something went wrong. Could not create a view model instance.',
      };
      throw RiveDataBindException(message);
    }
    stateMachine.bindViewModelInstance(vmi);
    return vmi;
  }

  ViewModel? get _safeViewModel => file.defaultArtboardViewModel(artboard);

  @override
  void artboardChanged(Artboard artboard) {
    // This painter builds the artboard as part of its constructor.
    // Always use the constructor provided artboard.
    super.artboardChanged(this.artboard);
  }

  @override
  bool hitTest(Offset position) {
    if (!active) return false;

    final hit = stateMachine.hitTest(
      localToArtboard(
        position: position,
        artboardBounds: artboard.bounds,
        fit: fit,
        alignment: alignment,
        size: lastSize / lastPaintPixelRatio,
        scaleFactor: layoutScaleFactor,
      ),
    );
    // We need to process another state machine pointer event, to account for
    // potential exit events.
    return hit || _previousHitResult != HitResult.none;
  }

  @override
  pointerEvent(PointerEvent event, HitTestEntry<HitTestTarget> entry) {
    if (!active) return;

    final stateMachine = this.stateMachine;
    final position = localToArtboard(
      position: event.localPosition,
      artboardBounds: artboard.bounds,
      fit: fit,
      alignment: alignment,
      size: lastSize / lastPaintPixelRatio,
      scaleFactor: layoutScaleFactor,
    );
    final HitResult hitResult;
    if (event is PointerDownEvent) {
      hitResult = stateMachine.pointerDown(position);
    } else if (event is PointerUpEvent) {
      hitResult = stateMachine.pointerUp(position);
    } else if (event is PointerMoveEvent) {
      hitResult = stateMachine.pointerMove(position);
    } else if (event is PointerHoverEvent) {
      hitResult = stateMachine.pointerMove(position);
    } else if (event is PointerExitEvent) {
      hitResult = stateMachine.pointerExit(position);
    } else {
      hitResult = HitResult.none;
    }

    // We handle the _previousHitResult as well to account for potential exit
    // events that may not have been processed.
    if (hitResult != HitResult.none || _previousHitResult != HitResult.none) {
      scheduleRepaint();
    }
    _previousHitResult = hitResult;
  }

  @override
  void scheduleRepaint() {
    if (_didAdvance) {
      return; // Already in an active ticker state
    }
    if (!_repaintScheduled) {
      super.scheduleRepaint();
      _repaintScheduled = true;
    }
  }

  @override
  bool advance(double elapsedSeconds) {
    _repaintScheduled = false;
    _didAdvance = stateMachine.advanceAndApply(elapsedSeconds);
    return _didAdvance && active;
  }

  @override
  void dispose() {
    stateMachine.removeAdvanceRequestListener(scheduleRepaint);
    artboard.dispose();
    stateMachine.dispose();
    super.dispose();
  }
}
