import 'dart:ffi';

import 'package:rive/src/ffi/rive_threaded_ffi.dart';
// Internal imports to access raw native pointers for artboard/SM/VMI handoff.
// This is intentional: rive-flutter is tightly coupled to rive_native internals.
// ignore: implementation_imports
import 'package:rive_native/src/ffi/rive_ffi_reference.dart'
    show RiveFFIReference;
import 'package:rive_native/rive_native.dart';

/// A controller for Rive content that advances and renders on a dedicated C++
/// background thread.
///
/// Unlike [RiveWidgetController], this class does NOT advance the state machine
/// on the Flutter UI thread. Instead it posts elapsed time and ViewModel inputs
/// via FFI to a native [ThreadedScene] (Phase 2). The GPU texture written by
/// the background thread is composited by [BackgroundRiveView] via Flutter's
/// [Texture] widget.
///
/// ## Ownership
///
/// After [initialize] succeeds, the native side owns the [artboard],
/// [stateMachine], and [viewModelInstance] objects. The Dart wrappers must NOT
/// be used for advance, draw, or property mutation. Dispose is handled
/// internally by [dispose].
///
/// ## Lifecycle
///
/// 1. Construct with the already-created [artboard], [stateMachine], and
///    optional [viewModelInstance].
/// 2. Call [initialize] once the widget layout size is known.
/// 3. On each frame tick, [BackgroundRiveView] calls [advance].
/// 4. When done, call [dispose].
class BackgroundRiveWidgetController {
  BackgroundRiveWidgetController({
    required this.artboard,
    required this.stateMachine,
    this.viewModelInstance,
  });

  final Artboard artboard;
  final StateMachine stateMachine;

  /// Optional ViewModel instance to bind to the state machine on the background
  /// thread. Provide this when using Rive data binding (the character rig).
  final ViewModelInstance? viewModelInstance;

  Pointer<Void> _handle = nullptr;

  bool get _initialized => _handle != nullptr;

  /// The Flutter texture id rendered by the background thread.
  ///
  /// Valid only after [initialize] returns `true`. Use this with Flutter's
  /// [Texture] widget.
  int get textureId {
    assert(_initialized, 'textureId accessed before initialize()');
    return RiveThreadedFfi.getTextureId(_handle);
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  /// Initialises the native [ThreadedScene] binding.
  ///
  /// [width] and [height] are the physical pixel dimensions of the rendering
  /// surface (logical size × device pixel ratio).
  ///
  /// Returns `true` on success (Metal / iOS / macOS). Returns `false` on
  /// unsupported platforms or if Phase 2 native symbols are not yet available.
  bool initialize({required int width, required int height}) {
    assert(!_initialized, 'initialize() called more than once');
    final abPtr = _nativePtrOf(artboard);
    final smPtr = _nativePtrOf(stateMachine);
    final vmiPtr = _nativePtrOf(viewModelInstance);

    if (abPtr == nullptr || smPtr == nullptr) {
      return false;
    }

    final handle = RiveThreadedFfi.create(
      artboard: abPtr,
      stateMachine: smPtr,
      viewModelInstance: vmiPtr,
      width: width,
      height: height,
    );

    if (handle == nullptr) return false;
    _handle = handle;
    return true;
  }

  /// Frees the native [ThreadedScene] and unregisters the Flutter texture.
  void dispose() {
    if (_initialized) {
      RiveThreadedFfi.destroy(_handle);
      _handle = nullptr;
    }
  }

  // ---------------------------------------------------------------------------
  // Per-frame
  // ---------------------------------------------------------------------------

  /// Posts [elapsedSeconds] to the background thread's time queue.
  ///
  /// Called each frame by [BackgroundRiveView]'s ticker. Non-blocking.
  void advance(double elapsedSeconds) {
    if (_initialized) {
      RiveThreadedFfi.postTime(_handle, elapsedSeconds);
    }
  }

  // ---------------------------------------------------------------------------
  // ViewModel inputs
  // ---------------------------------------------------------------------------

  /// Posts an enum-property change to the background thread.
  void setEnumProperty(String name, String value) {
    if (_initialized) {
      RiveThreadedFfi.setVmEnum(_handle, name, value);
    }
  }

  /// Posts a number-property change to the background thread.
  void setNumberProperty(String name, double value) {
    if (_initialized) {
      RiveThreadedFfi.setVmNumber(_handle, name, value);
    }
  }

  /// Posts a trigger fire to the background thread.
  void fireTriggerProperty(String name) {
    if (_initialized) {
      RiveThreadedFfi.fireVmTrigger(_handle, name);
    }
  }

  // ---------------------------------------------------------------------------
  // Snapshot / watch
  // ---------------------------------------------------------------------------

  /// Registers a ViewModel property name to be captured in each snapshot.
  void watchProperty(String name) {
    if (_initialized) {
      RiveThreadedFfi.watchProperty(_handle, name);
    }
  }

  /// Removes a property from the snapshot watch list.
  void unwatchProperty(String name) {
    if (_initialized) {
      RiveThreadedFfi.unwatchProperty(_handle, name);
    }
  }

  /// Atomically acquires the latest ViewModel snapshot.
  ///
  /// Returns a map of [String] property name → [String] value for every
  /// watched property. Returns an empty map if no snapshot is ready yet.
  ///
  /// The caller is responsible for diffing this against the previous snapshot
  /// and notifying Dart-side listeners (e.g., [CharacterRig._onBackgroundFrame]).
  Map<String, String> acquireSnapshot() {
    if (!_initialized) return const {};
    return RiveThreadedFfi.acquireSnapshot(_handle);
  }

  // ---------------------------------------------------------------------------
  // Events
  // ---------------------------------------------------------------------------

  /// Drains pending Rive events from the background thread.
  ///
  /// Returns event names (e.g. `'speechEnd'`, `'drawingEnd'`). The caller
  /// should process these and fire the appropriate Dart callbacks.
  List<String> pollEvents() {
    if (!_initialized) return const [];
    return RiveThreadedFfi.pollEvents(_handle);
  }

  // ---------------------------------------------------------------------------
  // Pointer events
  // ---------------------------------------------------------------------------

  /// Forwards a pointer-down event to the state machine queue.
  void pointerDown(double x, double y, int pointerId) {
    if (_initialized) {
      RiveThreadedFfi.pointerDown(_handle, x, y, pointerId);
    }
  }

  /// Forwards a pointer-move event to the state machine queue.
  void pointerMove(double x, double y, int pointerId) {
    if (_initialized) {
      RiveThreadedFfi.pointerMove(_handle, x, y, pointerId);
    }
  }

  /// Forwards a pointer-up event to the state machine queue.
  void pointerUp(double x, double y, int pointerId) {
    if (_initialized) {
      RiveThreadedFfi.pointerUp(_handle, x, y, pointerId);
    }
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Extracts the native [Pointer<Void>] from a rive_native runtime object.
///
/// All concrete rive_native objects ([FFIRiveArtboard], [FFIStateMachine],
/// [FFIRiveViewModelInstanceRuntime]) implement [RiveFFIReference] which
/// exposes the raw pointer. Returns [nullptr] for Flutter-renderer objects
/// (not supported in background mode) or null inputs.
Pointer<Void> _nativePtrOf(Object? obj) {
  if (obj == null) return nullptr;
  if (obj is RiveFFIReference) return obj.pointer;
  return nullptr;
}
