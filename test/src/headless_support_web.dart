/// The web runs the real WebGL renderer; the FFI headless path never exists.
const bool headlessRendererSupported = false;

const String headlessSkipReason =
    'Headless rendering is a VM-only test path (web runs the real WebGL '
    'renderer)';
