# Platform Considerations

In order to support some of our more low level features, Rive brings some of its C++ runtime to Flutter.

| Platform | Technology | Dependencies                     |
| -------- | ---------- | -------------------------------- |
| iOS      | FFI        | statically linked                |
| Android  | FFI        | `rive_native.so`                   |
| Windows  | FFI        | `rive_native.dll`                |
| Mac      | FFI        | statically linked                |
| Web      | WASM       | `rive_native.js`, `rive_native.wasm` |

## iOS & Mac

We use CocoaPods to build and statically link to your project the portions of Rive's C++ runtime that are necessary for text features.

## Android

We use Gradle & CMake to build `rive_text.so`. Rive's runtime uses modern features that are only available on newer NDKs. For this reason we recommend updating your build.gradle to include `ndkVersion "27.2.12479018"`.

```gradle
android {
  compileSdkVersion 35
  ndkVersion "27.2.12479018"
  ...
}
```

## Windows

We use CMake to build `rive_plugin.dll`. Note that Clang compiler is required, [see here](https://learn.microsoft.com/en-us/cpp/build/clang-support-msbuild?view=msvc-170) for how to enable it in your Visual Studio.

## Web

We use Emscripten to build a WASM and JS file which are statically served via UNPKG similarly to how Flutter delivers the CanvasKit WASM file.
