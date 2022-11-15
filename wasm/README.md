# Rive Flutter WASM

This folder contains the WASM portion of the Rive Flutter runtime.

## Delivered via Unpkg

This is published to NPM so that Flutter Web projects can all benefit from common caching of the WASM file via unpkg (similar to Flutter's same strategy for CanvasKit).

## Local Development

For local development the Flutter Runtime can be configured to use a local dev server. Steps are as follows:

```
cd wasm
npm run serve
```

Run any project depending on rive-flutter with a `--dart-define` argument to instruct the runtime to look for the local dev server.

```
flutter run --dart-define=LOCAL_RIVE_FLUTTER_WASM=true -d chrome
```

As you make changes to the C++ codebase, recompile with:

```
./build_wasm.sh
```

Refresh or Hot Restart the Flutter Web project.
