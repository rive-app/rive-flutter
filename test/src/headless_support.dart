/// Whether the native library provides the headless rendering symbols that
/// back `Factory.rive` in VM widget tests (`_HeadlessRenderTexture`).
///
/// Only macOS builds of `./build.sh shared` (no `flutter_runtime`) export
/// them; suites gated on this must skip cleanly everywhere else.
library;

export 'headless_support_io.dart'
    if (dart.library.js_interop) 'headless_support_web.dart';
