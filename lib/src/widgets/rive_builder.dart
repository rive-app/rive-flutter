import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// A function that builds a widget based on the state of the Rive file.
///
/// - The [context] parameter is the context of the widget.
/// - The [state] parameter is the current state of the Rive file.
typedef RiveBuilder = Widget Function(BuildContext context, RiveState state);

/// A function that builds a controller based on the Rive file.
///
/// - The [file] parameter is the Rive file.
typedef Controller = RiveWidgetController Function(File file);

/// A function that is called when the Rive state is loaded.
typedef RiveOnLoaded = void Function(RiveLoaded state);

/// A function that is called when the Rive state failed to load.
typedef RiveOnFailed = void Function(Object error, StackTrace stackTrace);

/// A widget that builds a Rive file.
///
/// - The [fileLoader] parameter is the file loader.
/// - The [artboardSelector] parameter specifies which artboard to use
/// - The [stateMachineSelector] parameter specifies which state machine to use
/// - The [builder] parameter is the builder that builds the widget based on
/// the state of the Rive file and controller.
/// - The [controller] parameter is an optional function that builds a
/// controller based on the Rive file. Use this to manually create the
/// controller instead of using the default one.
class RiveWidgetBuilder extends StatefulWidget {
  const RiveWidgetBuilder({
    super.key,
    required this.fileLoader,
    this.artboardSelector = const ArtboardDefault(),
    this.stateMachineSelector = const StateMachineDefault(),
    required this.builder,
    this.controller,
    this.onLoaded,
    this.onFailed,
  });

  /// The file loader to load the Rive file.
  final FileLoader fileLoader;

  /// The selector to specify which artboard to use.
  final ArtboardSelector artboardSelector;

  /// The selector to specify which state machine to use.
  final StateMachineSelector stateMachineSelector;

  /// The builder to build the widget based on the state of the Rive file and
  /// controller.
  final RiveBuilder builder;

  /// An optional function to manually create the controller instead of using
  /// the default one.
  final Controller? controller;

  /// An optional function to call when the Rive state is loaded.
  final RiveOnLoaded? onLoaded;

  /// An optional function to call when the Rive state failed to load.
  final RiveOnFailed? onFailed;

  @override
  State<RiveWidgetBuilder> createState() => _RiveWidgetBuilderState();
}

class _RiveWidgetBuilderState extends State<RiveWidgetBuilder> {
  RiveState _state = RiveLoading();
  late File _file;
  Future<void>? _currentSetup;

  @override
  void initState() {
    super.initState();
    _setup(withFileLoad: true);
  }

  @override
  void didUpdateWidget(RiveWidgetBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fileLoader != oldWidget.fileLoader) {
      _setup(withFileLoad: true);
    } else if (widget.artboardSelector != oldWidget.artboardSelector ||
        widget.stateMachineSelector != oldWidget.stateMachineSelector) {
      _setup(withFileLoad: false);
    }
  }

  Future<void> _setup({required bool withFileLoad}) async {
    final completer = Completer<void>();
    _currentSetup = completer.future;

    try {
      await _setupImpl(completer.future, withFileLoad: withFileLoad);
      if (!completer.isCompleted) {
        completer.complete();
      }
    } catch (e, stackTrace) {
      if (!completer.isCompleted) {
        completer.completeError(e, stackTrace);
      }
    } finally {
      // Only clear if this is still the current setup
      if (identical(_currentSetup, completer.future)) {
        _currentSetup = null;
      }
    }
  }

  Future<void> _setupImpl(
    Future<void> thisSetup, {
    required bool withFileLoad,
  }) async {
    RiveWidgetController? controller;
    try {
      if (withFileLoad) {
        _file = await widget.fileLoader.file();
        // Check if this operation was cancelled or the widget was disposed
        if (!mounted || !identical(_currentSetup, thisSetup)) {
          return;
        }
      }

      final controllerBuilder = widget.controller;
      final created = controllerBuilder != null
          ? controllerBuilder(_file)
          : RiveWidgetController(
              _file,
              artboardSelector: widget.artboardSelector,
              stateMachineSelector: widget.stateMachineSelector,
            );
      controller = created;

      // Check if this operation was cancelled or the widget was disposed
      if (!mounted || !identical(_currentSetup, thisSetup)) {
        created.dispose();
        return;
      }

      final previousState = _state;
      setState(() {
        _state = RiveLoaded(file: _file, controller: created);
      });
      // A reconfigure replaced a previously loaded state: release what the
      // widget created for it (the file is owned by the parent; the
      // controller owns the instances it resolved).
      if (previousState is RiveLoaded) {
        previousState.controller.dispose();
      }
      widget.onLoaded?.call(_state as RiveLoaded);
    } on Exception catch (e, stackTrace) {
      // Release this setup's controller, unless the state already took it
      // (onLoaded threw after the swap) - then it is released below with the
      // hidden state. When the setup was cancelled, a loaded state stays
      // current and its replacement disposes it instead.
      final hidden = _state;
      final stateOwnsController = hidden is RiveLoaded &&
          controller != null &&
          identical(hidden.controller, controller);
      if (controller != null && !stateOwnsController) {
        controller.dispose();
      }
      // Check if this operation was cancelled or the widget was disposed
      if (!mounted || !identical(_currentSetup, thisSetup)) {
        return;
      }
      setState(() {
        _state = RiveFailed(e, stackTrace);
      });
      // The failure hides a loaded state (a previous configuration's, or this
      // setup's own when onLoaded threw): release its controller.
      if (hidden is RiveLoaded) {
        hidden.controller.dispose();
      }
      widget.onFailed?.call(e, stackTrace);
    }
  }

  @override
  void dispose() {
    switch (_state) {
      case RiveLoaded state:
        // Don't dispose the file because it's owned by the parent widget;
        // the controller owns the instances it resolved.
        state.controller.dispose();
      case RiveLoading():
      case RiveFailed():
        // Nothing to dispose
        break;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _state);
}

/// The state of the [RiveBuilder] widget.
///
/// [RiveLoading] is the initial state.
///
/// [RiveLoaded] is the state when the Rive file is loaded and the
/// controller is created.
///
/// [RiveFailed] is the state when the Rive file or controller fails to
/// load.
sealed class RiveState {}

/// The state when the Rive file is still loading.
class RiveLoading extends RiveState {}

/// The state when the Rive file is loaded and the controller is created.
class RiveLoaded extends RiveState {
  final File file;
  final RiveWidgetController controller;

  RiveLoaded({required this.file, required this.controller});
}

/// The state when the Rive file or controller fails to load.
class RiveFailed extends RiveState {
  final Object error;
  final StackTrace stackTrace;

  RiveFailed(this.error, [this.stackTrace = StackTrace.empty]);
}
