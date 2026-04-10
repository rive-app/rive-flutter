import 'dart:ffi';

// Internal import to access raw native pointers for artboard/SM/VMI handoff.
// ignore: implementation_imports
import 'package:rive_native/src/ffi/rive_ffi_reference.dart'
    show RiveFFIReference;
// ignore: implementation_imports
import 'package:rive_native/src/ffi/rive_ffi.dart'
    show FFIRiveArtboard, FFIStateMachine;
import 'package:rive_native/rive_native.dart';

/// A controller for Rive content that advances and renders on a dedicated C++
/// background thread.
///
/// Unlike [RiveWidgetController], this class does NOT advance the state machine
/// on the Flutter UI thread. Instead it:
///
/// 1. Creates its own [RenderTexture] to obtain a `MetalTextureRenderer*`.
/// 2. Passes that renderer — plus the artboard, state machine, and optional
///    ViewModel instance — to [RiveThreadedBindings.create] which hands off
///    native ownership to a [ThreadedScene] running on a background C++ thread.
/// 3. Exposes [advance], [setEnumProperty], [acquireSnapshot], etc. as thin
///    wrappers around [RiveThreadedBindings].
///
/// ## Ownership
///
/// After [initialize] succeeds:
/// - The native [ThreadedScene] owns the artboard and state machine via
///   `unique_ptr`. [releaseNativeOwnership] is called on the Dart wrappers so
///   their [NativeFinalizer]s do not attempt a double-free.
/// - The ViewModel instance is ref-counted; both Dart and C++ hold a ref.
/// - The [RenderTexture] is owned by this controller and disposed in [dispose].
///
/// ## Lifecycle
///
/// 1. Construct with already-created [artboard], [stateMachine], optional
///    [viewModelInstance].
/// 2. Call [initialize] once the layout size is known (async — awaits
///    [RenderTexture.makeRenderTexture]).
/// 3. [BackgroundRiveView] drives the ticker and calls [advance] each frame.
/// 4. Call [dispose] when done.
class BackgroundRiveWidgetController {
  BackgroundRiveWidgetController({
    required this.artboard,
    required this.stateMachine,
    this.viewModelInstance,
  });

  final Artboard artboard;
  final StateMachine stateMachine;

  /// Optional ViewModel instance. The C++ side adds its own ref, so the Dart
  /// side retains ownership and must call [viewModelInstance.dispose] normally.
  final ViewModelInstance? viewModelInstance;

  RenderTexture? _renderTexture;
  RiveThreadedBindings? _bindings;

  bool get isInitialized => _bindings != null;

  /// The [RenderTexture] whose [textureId] [BackgroundRiveView] composites.
  ///
  /// Valid only after [initialize] returns `true`.
  RenderTexture get renderTexture {
    assert(isInitialized, 'renderTexture accessed before initialize()');
    return _renderTexture!;
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  /// Initialises the [RenderTexture] and the native [ThreadedScene] binding.
  ///
  /// [width] / [height] are physical pixel dimensions (logical × device pixel
  /// ratio). [devicePixelRatio] is used for Metal's display scaling.
  ///
  /// Returns `true` on success (Metal / iOS / macOS with Phase 2 symbols).
  /// Returns `false` on unsupported platforms or if object pointers are invalid.
  Future<bool> initialize({
    required int width,
    required int height,
    required double devicePixelRatio,
  }) async {
    assert(!isInitialized, 'initialize() called more than once');

    final rt = RiveNative.instance.makeRenderTexture();
    await rt.makeRenderTexture(width, height);

    if (!rt.isReady) {
      rt.dispose();
      return false;
    }

    final rendererPtr = rt.nativeRendererPtr;
    if (rendererPtr is! Pointer<Void> || rendererPtr == nullptr) {
      rt.dispose();
      return false;
    }

    final abPtr = _nativePtrOf(artboard);
    final smPtr = _nativePtrOf(stateMachine);
    final vmiPtr = _nativePtrOf(viewModelInstance);

    if (abPtr == nullptr || smPtr == nullptr) {
      rt.dispose();
      return false;
    }

    final bindings = RiveThreadedBindings.create(
      metalTextureRenderer: rendererPtr,
      artboard: abPtr,
      stateMachine: smPtr,
      viewModelInstance: vmiPtr,
      width: width,
      height: height,
      devicePixelRatio: devicePixelRatio,
    );

    if (bindings == null) {
      rt.dispose();
      return false;
    }

    // Transfer native ownership so Dart finalizers don't double-free.
    if (artboard is FFIRiveArtboard) {
      (artboard as FFIRiveArtboard).releaseNativeOwnership();
    }
    if (stateMachine is FFIStateMachine) {
      (stateMachine as FFIStateMachine).releaseNativeOwnership();
    }

    _renderTexture = rt;
    _bindings = bindings;
    return true;
  }

  /// Stops the background thread, unregisters the Flutter texture, and
  /// disposes the [RenderTexture].
  void dispose() {
    _bindings?.dispose();
    _bindings = null;
    _renderTexture?.dispose();
    _renderTexture = null;
    // Artboard/SM are owned by C++ (already released above).
    // ViewModelInstance retains normal Dart ownership — caller disposes it.
  }

  // ---------------------------------------------------------------------------
  // Per-frame
  // ---------------------------------------------------------------------------

  /// Posts [elapsedSeconds] to the background thread. Non-blocking.
  void advance(double elapsedSeconds) =>
      _bindings?.postElapsedTime(elapsedSeconds);

  // ---------------------------------------------------------------------------
  // ViewModel inputs
  // ---------------------------------------------------------------------------

  void setEnumProperty(String name, String value) =>
      _bindings?.setEnumProperty(name, value);

  void setNumberProperty(String name, double value) =>
      _bindings?.setNumberProperty(name, value);

  void setBoolProperty(String name, bool value) =>
      _bindings?.setBoolProperty(name, value);

  void setStringProperty(String name, String value) =>
      _bindings?.setStringProperty(name, value);

  void fireTriggerProperty(String name) => _bindings?.fireTrigger(name);

  // ---------------------------------------------------------------------------
  // Snapshot / watch
  // ---------------------------------------------------------------------------

  void watchProperty(String name) => _bindings?.watchProperty(name);
  void unwatchProperty(String name) => _bindings?.unwatchProperty(name);

  /// Atomically acquires the latest ViewModel property snapshot.
  ///
  /// Returns an empty list if the controller is not initialised or no snapshot
  /// has been produced yet.
  List<SnapshotEntry> acquireSnapshot({int maxProperties = 32}) =>
      _bindings?.acquireSnapshot(maxProperties: maxProperties) ?? const [];

  // ---------------------------------------------------------------------------
  // Events
  // ---------------------------------------------------------------------------

  /// Drains pending Rive state-machine reported events.
  List<RiveThreadedEvent> pollEvents({int maxEvents = 32}) =>
      _bindings?.pollEvents(maxEvents: maxEvents) ?? const [];

  // ---------------------------------------------------------------------------
  // Pointer events
  // ---------------------------------------------------------------------------

  void pointerDown(double x, double y, {int pointerId = 0}) =>
      _bindings?.pointerDown(x, y, pointerId: pointerId);

  void pointerMove(double x, double y, {int pointerId = 0}) =>
      _bindings?.pointerMove(x, y, pointerId: pointerId);

  void pointerUp(double x, double y, {int pointerId = 0}) =>
      _bindings?.pointerUp(x, y, pointerId: pointerId);

  void pointerExit(double x, double y, {int pointerId = 0}) =>
      _bindings?.pointerExit(x, y, pointerId: pointerId);
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Pointer<Void> _nativePtrOf(Object? obj) {
  if (obj == null) return nullptr;
  if (obj is RiveFFIReference) return obj.pointer;
  return nullptr;
}
