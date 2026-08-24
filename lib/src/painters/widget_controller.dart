import 'package:flutter/foundation.dart' show debugPrint;
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

  /// The artboard that the [RiveWidgetController] is painting.
  @override
  late final Artboard artboard;

  /// The state machine that the [RiveWidgetController] is using.
  late final StateMachine stateMachine;

  /// {@macro rive_controller}
  /// - The [file] parameter is the Rive file to paint.
  /// - The [artboardSelector] parameter specifies which artboard to use.
  /// - The [stateMachineSelector] parameter specifies which state machine to use.
  /// - [main] and [globals] optionally choose the initially bound view model
  /// instances, with the same shapes and semantics as [bind].
  ///
  /// The controller binds at construction: every slot not chosen through
  /// [main]/[globals] receives a default instance, so a bare
  /// `RiveWidgetController(file)` is fully bound. On content without data
  /// binding the bind is a no-op. Rebind later with [bind].
  ///
  /// Prefer these parameters over calling [bind] right after construction:
  /// the constructor already bound everything, so an immediate [bind] pays a
  /// second full rebind before anything rendered (debug builds warn once).
  ///
  /// Throws a [RiveDataBindException] (releasing everything the constructor
  /// created) if [main]/[globals] cannot be resolved, e.g. an unknown global
  /// name.
  RiveWidgetController(
    this.file, {
    ArtboardSelector artboardSelector = const ArtboardDefault(),
    StateMachineSelector stateMachineSelector = const StateMachineDefault(),
    DataBind? main,
    Map<String, DataBind> globals = const {},
  }) {
    artboard = _createArtboard(file, artboardSelector);
    stateMachine = _createStateMachine(artboard, stateMachineSelector);
    try {
      bind(main: main, globals: globals);
    } catch (_) {
      dispose();
      rethrow;
    }
    _suppressEarlyRebindWarning = false;
  }

  /// The debug early-rebind warning is suppressed during construction, after
  /// the first [advance] (the construction bind was rendered), and after
  /// firing once.
  var _suppressEarlyRebindWarning = true;

  /// Debug-only, one-shot: warn when a rebind runs before the first
  /// [advance] - the construction bind was discarded unrendered, so the
  /// configuration should have been passed to the constructor. Always
  /// returns true so it can run inside an assert.
  bool _debugWarnIfRebindBeforeFirstAdvance() {
    if (_suppressEarlyRebindWarning) return true;
    _suppressEarlyRebindWarning = true;
    debugPrint(
      'RiveWidgetController: a rebind ran before the first advance. The '
      'constructor already bound everything, so this pays a second full '
      'rebind before anything rendered. Pass the configuration to the '
      'constructor instead: RiveWidgetController(file, main: ..., '
      'globals: {...}). (Debug-only warning, shown once per controller.)',
    );
    return true;
  }

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

  /// Resolves [dataBind] to an instance to stage: the caller's own instance
  /// for [DataBind.byInstance], otherwise one created from the view model
  /// produced by [lookup] (whose wrapper is released again). Throws a
  /// [RiveDataBindException] when no instance could be resolved.
  BindableViewModelInstance _resolveInstance(
    DataBind dataBind,
    ViewModel? Function() lookup, {
    String? globalName,
  }) {
    if (dataBind is BindByInstance) {
      final instance = dataBind.viewModelInstance;
      if (instance.isDisposed) {
        throw RiveDataBindException(
          'The provided view model instance has been disposed.',
        );
      }
      return instance;
    }
    final viewModel = lookup();
    try {
      final vmi = switch (dataBind) {
        AutoBind() => viewModel?.createDefaultInstance(),
        BindByIndex() => viewModel?.createInstanceByIndex(dataBind.index),
        BindByName() => viewModel?.createInstanceByName(dataBind.name),
        BindEmpty() => viewModel?.createInstance(),
        BindByInstance() => null, // Unreachable: returned above.
      };
      if (vmi == null) {
        final slot = globalName == null ? '' : " for global '$globalName'";
        final message = switch (dataBind) {
          AutoBind() =>
            'Default view model instance$slot not found. Make sure the instance is set to exported in the Rive Editor.',
          BindByIndex() =>
            'View model instance by index `${dataBind.index}`$slot not found.',
          BindByName() =>
            'View model instance by name `${dataBind.name}`$slot not found.',
          BindEmpty() =>
            'Something went wrong. Could not create a view model instance$slot.',
          BindByInstance() => '', // Unreachable: returned above.
        };
        throw RiveDataBindException(message);
      }
      return vmi;
    } finally {
      viewModel?.dispose();
    }
  }

  /// Binds view model instances to the state machine. However many
  /// instances you set, the expensive rebind runs exactly once.
  ///
  /// Construction already binds (see the constructor), so a [bind] call
  /// afterwards is a rebind and applies as a delta on the current bindings.
  /// Prefer the constructor's `main`/`globals` for initial configuration: a
  /// [bind] before the controller's first advance discards the construction
  /// bind unrendered, and debug builds warn once.
  ///
  /// ```dart
  /// // Default instances for the main and every global view model:
  /// controller.bind();
  /// controller.globalViewModelInstance('Theme'); // the default instance
  ///
  /// // Choose specific instances; anything left out keeps working as-is:
  /// controller.bind(
  ///   main: DataBind.auto(),
  ///   globals: {'Theme': DataBind.byInstance(themeInstance)},
  /// );
  /// ```
  ///
  /// Each call only changes what you pass in. Anything left out keeps the
  /// instance it already has, or receives a default instance if it was never
  /// bound - leaving something out never unbinds it. Every variant except
  /// [DataBind.byInstance] creates a fresh instance per call, so passing one
  /// for a slot that is already bound replaces (resets) that slot's
  /// instance; [DataBind.byInstance] is the only way to bind an existing,
  /// possibly modified instance.
  ///
  /// Bad input throws a [RiveDataBindException] before anything changes:
  /// using a key that is not a global view model name in this file, or an
  /// instance that could not be created. One rare exception to "before
  /// anything changes": if the file also contains a non-global view model
  /// with the same name as a global, binding that global fails partway
  /// through - the exception is still thrown, but slots staged earlier in
  /// the same call stay staged.
  ///
  /// Read the bound instances back through [viewModelInstance] and
  /// [globalViewModelInstance], including the defaults created for anything
  /// you did not set. Read-backs are plain [ViewModelInstance] views: use
  /// them to read, write, and listen, but they cannot be passed to
  /// [DataBind.byInstance] (a compile error; forcing a cast throws) - create
  /// your own instance to share one across slots or controllers. Instances
  /// you pass with [DataBind.byInstance] are yours: this controller never
  /// disposes them. Every instance the controller creates itself is disposed
  /// with the controller.
  void bind({DataBind? main, Map<String, DataBind> globals = const {}}) {
    assert(_debugWarnIfRebindBeforeFirstAdvance());
    if (globals.isNotEmpty) {
      final globalNames = file.globalViewModelNames;
      final invalid = globals.keys
          .where((name) => !globalNames.contains(name))
          .toList();
      if (invalid.isNotEmpty) {
        throw RiveDataBindException(
          'The following are not global view model names in this file: '
          "${invalid.join(', ')}.",
        );
      }
    }

    // Snapshot the entries so every loop below sees one consistent order,
    // whatever Map implementation the caller passed.
    final entries = globals.entries.toList(growable: false);

    // Resolve every DataBind before staging anything, so a failure leaves
    // the current bindings fully untouched.
    BindableViewModelInstance? resolvedMain;
    final resolvedGlobals = <String, BindableViewModelInstance>{};
    try {
      if (main != null) {
        resolvedMain = _resolveInstance(
          main,
          () => file.defaultArtboardViewModel(artboard),
        );
      }
      for (final MapEntry(key: name, value: dataBind) in entries) {
        resolvedGlobals[name] = _resolveInstance(
          dataBind,
          () => file.viewModelByName(name),
          globalName: name,
        );
      }
    } catch (_) {
      // Nothing was staged: release what this call already resolved.
      if (main != null && !main.callerOwnsInstance) {
        resolvedMain?.dispose();
      }
      for (final MapEntry(key: name, value: dataBind) in entries) {
        if (!dataBind.callerOwnsInstance) {
          resolvedGlobals[name]?.dispose();
        }
      }
      rethrow;
    }

    if (resolvedMain != null) {
      if (main!.callerOwnsInstance) {
        stateMachine.setViewModelInstance(resolvedMain);
      } else {
        // Resolved for the caller: the state machine owns it from here.
        // ignore: invalid_use_of_internal_member
        stateMachine.adoptViewModelInstance(resolvedMain);
      }
    }
    var staged = 0;
    for (final MapEntry(key: name, value: dataBind) in entries) {
      final resolved = resolvedGlobals[name]!;
      final stagedOk = dataBind.callerOwnsInstance
          ? stateMachine.setGlobalViewModelInstance(name, resolved)
          // Resolved for the caller: the state machine owns it from here.
          // ignore: invalid_use_of_internal_member
          : stateMachine.adoptGlobalViewModelInstance(name, resolved);
      if (!stagedOk) {
        // A pre-validated name can still fail to stage when a non-global view
        // model shadows it in the file's view model list; surface it instead
        // of silently binding an incomplete configuration. Earlier entries
        // are already staged; release the unstaged rest (this entry included).
        for (final rest in entries.skip(staged)) {
          if (!rest.value.callerOwnsInstance) {
            resolvedGlobals[rest.key]!.dispose();
          }
        }
        throw RiveDataBindException(
          "Could not stage global '$name'; another view model may "
          'shadow its name in this file.',
        );
      }
      staged++;
    }
    stateMachine.bind();
  }

  /// The bound main view model instance, or null if nothing is bound. Reads
  /// are live - they always reflect what is currently bound - and reading
  /// the same thing twice returns the same object.
  ViewModelInstance? get viewModelInstance =>
      stateMachine.boundRuntimeViewModelInstance;

  /// The instance bound for the global view model [name], or null if nothing
  /// is bound for it or the name is not a global view model. Reads are live,
  /// same object per slot.
  ViewModelInstance? globalViewModelInstance(String name) =>
      stateMachine.globalViewModelInstance(name);

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
        size: size,
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
      size: size,
      scaleFactor: layoutScaleFactor,
    );
    final hitResult = dispatchPointerEvent(stateMachine, event, position);

    // We handle the _previousHitResult as well to account for potential exit
    // events that may not have been processed.
    if (hitResult != HitResult.none || _previousHitResult != HitResult.none) {
      scheduleRepaint();

      // For pointer down/up/cancel events, advance and apply immediately so
      // that intermediate state, such as a view model property set on pointer
      // down, is processed immediately, even when the down and up occur within
      // the same frame.
      if (event is PointerDownEvent ||
          event is PointerUpEvent ||
          event is PointerCancelEvent) {
        stateMachine.advanceAndApply(0);
      }
    }

    _previousHitResult = hitResult;
  }

  @override
  void scheduleRepaint() {
    if (isTickerActive) {
      return; // Already in an active ticker state
    }
    if (!_repaintScheduled) {
      super.scheduleRepaint();
      _repaintScheduled = true;
    }
  }

  @override
  bool advance(double elapsedSeconds) {
    _suppressEarlyRebindWarning = true;
    _repaintScheduled = false;
    final didAdvance = stateMachine.advanceAndApply(elapsedSeconds);
    return didAdvance && active;
  }

  @override
  void dispose() {
    stateMachine.removeAdvanceRequestListener(scheduleRepaint);
    artboard.dispose();
    stateMachine.dispose();
    super.dispose();
  }
}
