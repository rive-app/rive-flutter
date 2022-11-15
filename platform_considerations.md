# Platform Considerations

In order to support some of our more low level features, Rive brings some of its C++ runtime to Flutter.
| Platform | Technology | Dependencies |
| ------------- | ------------- | ------------- |
| iOS | FFI | statically linked |
| Android | FFI | rive_text.so |
| Windows | FFI | rive_plugin.dll |
| Mac | FFI | statically linked |
| Web | WASM | rive_text.js, rive_text.wasm |

## iOS & Mac

We use cocoapods to build and statically link to your project the portions of Rive's C++ runtime that are necessary for text features.

## Android

We use Gradle & CMake to build rive_text.so. Rive's runtime uses modern features that are only available on newer NDKs, for this reason we recommend updating your build.gradle to include ndkVersion 25.1.8937393

```
android {
  compileSdkVersion 31
  ndkVersion "25.1.8937393"
  ...
}
```

## Windows

We use CMake to build rive_plugin.dll. Note that Clang compiler is required, see here for how to enable it in your Visual Studio:
https://learn.microsoft.com/en-us/cpp/build/clang-support-msbuild?view=msvc-170

## Web

We use emscripten to build a wasm and js file which are statically served via unpkg similarly to how Flutter delivers the CanvasKit wasm file.
