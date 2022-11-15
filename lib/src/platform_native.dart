import 'dart:io' as io show Platform;

import 'platform.dart';

Platform makePlatform() => PlatformNative();

class PlatformNative extends Platform {
  @override
  bool get isTesting => io.Platform.environment.containsKey('FLUTTER_TEST');
}
