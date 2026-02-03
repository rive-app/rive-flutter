# Rive Flutter Example

A demo application showcasing Rive Flutter.

## Getting Started

The `rive` package depends on `rive_native`, and the code on GitHub may reference an unpublished version of `rive_native`. We recommend using the published version from [Pub](https://pub.dev/packages/rive):

```bash
dart pub unpack rive        # Unpack the package source code and example app
cd rive/example             # Navigate to the example folder
flutter create .            # Create the platform folders
flutter pub get             # Fetch dependencies
flutter run                 # Run the example app
```

Alternatively, clone this repository (requires building native libraries locally):

```bash
git clone https://github.com/rive-app/rive-flutter
cd rive-flutter/example
flutter pub get
flutter run
```

### Flutter Installation Instructions
If you're new to [Flutter](https://flutter.dev), see the official [installation instructions](https://docs.flutter.dev/get-started/install).