import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

/// Maximum number of events returned from [RiveThreadedFfi.pollEvents] per
/// call.
const int kMaxThreadedEvents = 64;

/// Maximum number of snapshot properties returned from
/// [RiveThreadedFfi.acquireSnapshot] per call.
const int kMaxSnapshotProperties = 32;

/// Dart FFI bindings for the native threaded-scene exports (`rive_threaded_*`).
///
/// These symbols are provided by **Phase 2** of the background-advance
/// implementation (native C++ bridge in the rive_native plugin). Until that
/// phase is complete, any call to a method here will throw a [LookupError] at
/// the point of first use (lazy symbol resolution).
///
/// All string parameters are converted to native UTF-8 with [toNativeUtf8] and
/// freed immediately after the native call. The caller must never cache the
/// native string pointers.
///
/// Platform support: Metal (iOS / macOS) only. On Android / Windows / Linux the
/// native `rive_threaded_create` returns nullptr and [create] returns null.
abstract final class RiveThreadedFfi {
  static final DynamicLibrary _lib = _openLib();

  static DynamicLibrary _openLib() {
    if (Platform.isAndroid) {
      try {
        return DynamicLibrary.open('librive_native.so');
      } catch (_) {
        return DynamicLibrary.process();
      }
    }
    return DynamicLibrary.process();
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  /// `void* rive_threaded_create(artboard, stateMachine, viewModelInstance,
  ///                             width, height)`
  ///
  /// Takes ownership of the three object pointers. Returns the binding handle,
  /// or nullptr on failure (non-Metal platform, or bad pointers).
  static final Pointer<Void> Function(
    Pointer<Void>,
    Pointer<Void>,
    Pointer<Void>,
    int,
    int,
  ) _create = _lib.lookupFunction<
      Pointer<Void> Function(
        Pointer<Void>,
        Pointer<Void>,
        Pointer<Void>,
        Int32,
        Int32,
      ),
      Pointer<Void> Function(
        Pointer<Void>,
        Pointer<Void>,
        Pointer<Void>,
        int,
        int,
      )>('rive_threaded_create');

  /// `void rive_threaded_destroy(handle)`
  static final void Function(Pointer<Void>) _destroy = _lib
      .lookupFunction<Void Function(Pointer<Void>), void Function(Pointer<Void>)>(
          'rive_threaded_destroy');

  /// `int64_t rive_threaded_get_texture_id(handle)`
  ///
  /// Returns the Flutter texture id registered by the native binding. Must be
  /// called after [create] returns a non-null handle.
  static final int Function(Pointer<Void>) _getTextureId = _lib
      .lookupFunction<Int64 Function(Pointer<Void>), int Function(Pointer<Void>)>(
          'rive_threaded_get_texture_id');

  // ---------------------------------------------------------------------------
  // Per-frame
  // ---------------------------------------------------------------------------

  /// `void rive_threaded_post_time(handle, elapsedSeconds)`
  ///
  /// Posts elapsed time to the background thread's input queue. Non-blocking.
  static final void Function(Pointer<Void>, double) _postTime = _lib
      .lookupFunction<Void Function(Pointer<Void>, Float),
          void Function(Pointer<Void>, double)>('rive_threaded_post_time');

  // ---------------------------------------------------------------------------
  // ViewModel inputs
  // ---------------------------------------------------------------------------

  /// `void rive_threaded_set_vm_enum(handle, name, value)`
  static final void Function(
    Pointer<Void>,
    Pointer<Utf8>,
    Pointer<Utf8>,
  ) _setVmEnum = _lib.lookupFunction<
      Void Function(Pointer<Void>, Pointer<Utf8>, Pointer<Utf8>),
      void Function(Pointer<Void>, Pointer<Utf8>, Pointer<Utf8>)>(
      'rive_threaded_set_vm_enum');

  /// `void rive_threaded_set_vm_number(handle, name, value)`
  static final void Function(Pointer<Void>, Pointer<Utf8>, double)
      _setVmNumber = _lib.lookupFunction<
          Void Function(Pointer<Void>, Pointer<Utf8>, Float),
          void Function(Pointer<Void>, Pointer<Utf8>, double)>(
          'rive_threaded_set_vm_number');

  /// `void rive_threaded_fire_vm_trigger(handle, name)`
  static final void Function(Pointer<Void>, Pointer<Utf8>) _fireVmTrigger =
      _lib.lookupFunction<Void Function(Pointer<Void>, Pointer<Utf8>),
          void Function(Pointer<Void>, Pointer<Utf8>)>(
          'rive_threaded_fire_vm_trigger');

  // ---------------------------------------------------------------------------
  // Snapshot / watch
  // ---------------------------------------------------------------------------

  /// `void rive_threaded_watch_property(handle, name)`
  ///
  /// Registers a ViewModel property to be included in the next snapshot.
  static final void Function(Pointer<Void>, Pointer<Utf8>) _watchProperty =
      _lib.lookupFunction<Void Function(Pointer<Void>, Pointer<Utf8>),
          void Function(Pointer<Void>, Pointer<Utf8>)>(
          'rive_threaded_watch_property');

  /// `void rive_threaded_unwatch_property(handle, name)`
  static final void Function(Pointer<Void>, Pointer<Utf8>)
      _unwatchProperty = _lib.lookupFunction<
          Void Function(Pointer<Void>, Pointer<Utf8>),
          void Function(Pointer<Void>, Pointer<Utf8>)>(
          'rive_threaded_unwatch_property');

  /// `int rive_threaded_acquire_snapshot(handle, names_out, values_out, max)`
  ///
  /// Atomically swaps the latest ViewModel snapshot into [names_out] and
  /// [values_out] (arrays of UTF-8 pointers). Returns the count of properties.
  /// The string pointers remain valid until the next [acquireSnapshot] call.
  static final int Function(
    Pointer<Void>,
    Pointer<Pointer<Utf8>>,
    Pointer<Pointer<Utf8>>,
    int,
  ) _acquireSnapshot = _lib.lookupFunction<
      Int32 Function(
        Pointer<Void>,
        Pointer<Pointer<Utf8>>,
        Pointer<Pointer<Utf8>>,
        Int32,
      ),
      int Function(
        Pointer<Void>,
        Pointer<Pointer<Utf8>>,
        Pointer<Pointer<Utf8>>,
        int,
      )>('rive_threaded_acquire_snapshot');

  // ---------------------------------------------------------------------------
  // Events
  // ---------------------------------------------------------------------------

  /// `int rive_threaded_poll_events(handle, event_names_out, max)`
  ///
  /// Drains pending Rive events into [event_names_out]. Returns the count.
  /// The string pointers remain valid until the next [pollEvents] call.
  static final int Function(
    Pointer<Void>,
    Pointer<Pointer<Utf8>>,
    int,
  ) _pollEvents = _lib.lookupFunction<
      Int32 Function(Pointer<Void>, Pointer<Pointer<Utf8>>, Int32),
      int Function(Pointer<Void>, Pointer<Pointer<Utf8>>, int)>(
      'rive_threaded_poll_events');

  // ---------------------------------------------------------------------------
  // Pointer events (forwarded to SM on background thread)
  // ---------------------------------------------------------------------------

  /// `void rive_threaded_pointer_down(handle, x, y, pointerId)`
  static final void Function(Pointer<Void>, double, double, int)
      _pointerDown = _lib.lookupFunction<
          Void Function(Pointer<Void>, Float, Float, Int32),
          void Function(Pointer<Void>, double, double, int)>(
          'rive_threaded_pointer_down');

  /// `void rive_threaded_pointer_move(handle, x, y, pointerId)`
  static final void Function(Pointer<Void>, double, double, int)
      _pointerMove = _lib.lookupFunction<
          Void Function(Pointer<Void>, Float, Float, Int32),
          void Function(Pointer<Void>, double, double, int)>(
          'rive_threaded_pointer_move');

  /// `void rive_threaded_pointer_up(handle, x, y, pointerId)`
  static final void Function(Pointer<Void>, double, double, int)
      _pointerUp = _lib.lookupFunction<
          Void Function(Pointer<Void>, Float, Float, Int32),
          void Function(Pointer<Void>, double, double, int)>(
          'rive_threaded_pointer_up');

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Creates a native threaded scene and returns its opaque handle.
  ///
  /// The artboard, state machine, and (optional) view-model instance pointers
  /// are transferred to native ownership. After this call the Dart objects
  /// wrapping those pointers must not be used for advance, draw, or property
  /// mutation.
  ///
  /// Returns [nullptr] on failure (non-Metal platform or null input pointers).
  static Pointer<Void> create({
    required Pointer<Void> artboard,
    required Pointer<Void> stateMachine,
    required Pointer<Void> viewModelInstance,
    required int width,
    required int height,
  }) =>
      _create(artboard, stateMachine, viewModelInstance, width, height);

  /// Destroys the threaded scene and frees all native resources including the
  /// Flutter texture registration.
  static void destroy(Pointer<Void> handle) => _destroy(handle);

  /// Returns the Flutter texture id that the background thread renders into.
  static int getTextureId(Pointer<Void> handle) => _getTextureId(handle);

  /// Posts [elapsedSeconds] to the background thread. Non-blocking queue push.
  static void postTime(Pointer<Void> handle, double elapsedSeconds) =>
      _postTime(handle, elapsedSeconds);

  /// Sets a ViewModel enum property by name on the background thread.
  static void setVmEnum(Pointer<Void> handle, String name, String value) {
    final namePtr = name.toNativeUtf8();
    final valuePtr = value.toNativeUtf8();
    try {
      _setVmEnum(handle, namePtr, valuePtr);
    } finally {
      calloc.free(namePtr);
      calloc.free(valuePtr);
    }
  }

  /// Sets a ViewModel number property by name on the background thread.
  static void setVmNumber(Pointer<Void> handle, String name, double value) {
    final namePtr = name.toNativeUtf8();
    try {
      _setVmNumber(handle, namePtr, value);
    } finally {
      calloc.free(namePtr);
    }
  }

  /// Fires a ViewModel trigger by name on the background thread.
  static void fireVmTrigger(Pointer<Void> handle, String name) {
    final namePtr = name.toNativeUtf8();
    try {
      _fireVmTrigger(handle, namePtr);
    } finally {
      calloc.free(namePtr);
    }
  }

  /// Registers a ViewModel property to be included in subsequent snapshots.
  static void watchProperty(Pointer<Void> handle, String name) {
    final namePtr = name.toNativeUtf8();
    try {
      _watchProperty(handle, namePtr);
    } finally {
      calloc.free(namePtr);
    }
  }

  /// Removes a property from the snapshot watch list.
  static void unwatchProperty(Pointer<Void> handle, String name) {
    final namePtr = name.toNativeUtf8();
    try {
      _unwatchProperty(handle, namePtr);
    } finally {
      calloc.free(namePtr);
    }
  }

  /// Atomically acquires the latest ViewModel snapshot.
  ///
  /// Returns a map of watched property names to their current string
  /// representations. The map is empty if no snapshot is available yet.
  static Map<String, String> acquireSnapshot(Pointer<Void> handle) {
    final namesOut = calloc<Pointer<Utf8>>(kMaxSnapshotProperties);
    final valuesOut = calloc<Pointer<Utf8>>(kMaxSnapshotProperties);
    try {
      final count =
          _acquireSnapshot(handle, namesOut, valuesOut, kMaxSnapshotProperties);
      final result = <String, String>{};
      for (var i = 0; i < count; i++) {
        result[namesOut[i].toDartString()] = valuesOut[i].toDartString();
      }
      return result;
    } finally {
      calloc.free(namesOut);
      calloc.free(valuesOut);
    }
  }

  /// Drains pending Rive events (by name) from the background thread.
  static List<String> pollEvents(Pointer<Void> handle) {
    final namesOut = calloc<Pointer<Utf8>>(kMaxThreadedEvents);
    try {
      final count = _pollEvents(handle, namesOut, kMaxThreadedEvents);
      return [
        for (var i = 0; i < count; i++) namesOut[i].toDartString(),
      ];
    } finally {
      calloc.free(namesOut);
    }
  }

  /// Forwards a pointer-down event to the state machine on the background
  /// thread.
  static void pointerDown(
          Pointer<Void> handle, double x, double y, int pointerId) =>
      _pointerDown(handle, x, y, pointerId);

  /// Forwards a pointer-move event to the state machine on the background
  /// thread.
  static void pointerMove(
          Pointer<Void> handle, double x, double y, int pointerId) =>
      _pointerMove(handle, x, y, pointerId);

  /// Forwards a pointer-up event to the state machine on the background thread.
  static void pointerUp(
          Pointer<Void> handle, double x, double y, int pointerId) =>
      _pointerUp(handle, x, y, pointerId);
}
