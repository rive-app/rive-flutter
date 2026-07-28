import 'package:rive_native/src/ffi/dynamic_library_helper.dart';

/// True when the loaded native library exports the headless Metal rendering
/// entry points (see `native/src/headless_rendering.mm`).
final bool headlessRendererSupported =
    DynamicLibraryHelper.nativeLib.providesSymbol('createHeadlessContext');

/// Standard skip message for suites that need the headless renderer.
const String headlessSkipReason = 'Headless symbols not in the native lib '
    '(build with: cd native && ./build.sh shared)';
